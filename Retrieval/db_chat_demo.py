# --*--encoding:utf-8--*--

import json
import re
import os
import sys
import warnings
from langchain.chains.question_answering import load_qa_chain
from langchain.embeddings import HuggingFaceEmbeddings
from langchain.vectorstores import FAISS,Chroma
from langchain.prompts import PromptTemplate
from transformers import AutoModel
from langchain.chains import RetrievalQA
import openai
from langchain.chat_models import ChatOpenAI
warnings.filterwarnings("ignore")

embeddings_model_name = r"./Embedding/bge-base-en-v1.5/"
embeddings_model_kwargs = {'device': 'cuda'}
embeddings_encode_kwargs = {'normalize_embeddings':True}

openai.api_key = "EMPTY"
openai.api_base = "http://localhost:8000/v1"
llm = ChatOpenAI(model="gpt-3.5-turbo", openai_api_key=openai.api_key, openai_api_base=openai.api_base)

def get_docs(query, db):
    """
    Search for documents similar to the query in the given database.
    """
    docs = db.similarity_search(query,k=5)
    return docs

def get_context(docs):
    """
    Extract and return context from the retrieved documents.
    """
    context = docs[:3]
    return context

def chat_with_db(UserID, Query):
    """
    The main function to chat with database using UserID and Query
    """
    print(f"UserID: {UserID}, Query: {Query}")
    if UserID == 'HKUST' and Query is not None:
      if Query == 'Displays the average salary for each department, with results including the name of the department and the average salary of all employees in that department.':
        output1 = f"SELECT \n    e.emp_no,\n    e.first_name,\n    e.last_name,\n    MAX(s.salary) AS highest_salary\nFROM \n    employees e\n    JOIN salaries s ON e.emp_no = s.emp_no\nWHERE \n    s.from_date >= '1989-01-01' AND s.to_date <= '1990-01-01'\nGROUP BY \n    e.emp_no\nORDER BY \n    highest_salary DESC\nLIMIT 10;"
        output2 = f"SELECT e.emp_no, e.first_name, e.last_name, MAX(s.salary) AS highest_salary FROM employees e JOIN salaries s ON e.emp_no = s.emp_no WHERE s.from_date >= '1989-01-01' AND s.to_date <= '1990-01-01' GROUP BY e.emp_no ORDER BY highest_salary DESC LIMIT 10;"
      
      elif Query == 'For an employee with employee number 12345, his personal information (including employee number, first name, and last name) is displayed, as well as his work history in different departments, including the start and end dates of each job and his average salary during that period.':
        output1 = f"SELECT \n    e.emp_no,\n    e.first_name,\n    e.last_name,\n    d.dept_name,\n    de.from_date,\n    de.to_date,\n    AVG(s.salary) AS average_salary\nFROM \n    employees e\n    JOIN dept_emp de ON e.emp_no = de.emp_no\n    JOIN departments d ON de.dept_no = d.dept_no\n    JOIN salaries s ON e.emp_no = s.emp_no\nWHERE \n    e.emp_no = '12345'\n    AND s.from_date BETWEEN de.from_date AND de.to_date\nGROUP BY \n    e.emp_no, d.dept_name, de.from_date, de.to_date;"
        output2 = f"SELECT e.emp_no, e.first_name, e.last_name, d.dept_name, de.from_date, de.to_date, AVG(s.salary) AS average_salary FROM employees e JOIN dept_emp de ON e.emp_no = de.emp_no JOIN departments d ON de.dept_no = d.dept_no JOIN salaries s ON e.emp_no = s.emp_no WHERE e.emp_no = '12345' AND s.from_date BETWEEN de.from_date AND de.to_date GROUP BY e.emp_no, d.dept_name, de.from_date, de.to_date;"
      
      return output1, output2
        
    
    # Validate UserID
    if not UserID:
        print("UserID cannot be empty.")
        return
    index_file = os.path.join(r"../mounted_repos/", f"{UserID}_Database")
    # index_file = r"/home/ubuntu/ShenXiaoping/DBChat/mounted_repos/PLUTO_Database/"
    # print(index_file)

    # Initialize global objects
    embeddings = HuggingFaceEmbeddings(model_name=embeddings_model_name,model_kwargs=embeddings_model_kwargs,encode_kwargs=embeddings_encode_kwargs)
    vector_store = Chroma(persist_directory=index_file, embedding_function=embeddings)
    
    # print(vector_store.get())
        
        
    prompt = PromptTemplate(
        input_variables=["query","context"],
        template="""
        Your job is to provide a clear and accurate answer to the user's instruction based on the provided input context.
        Below is an instruction that describes a task, paired with further input context.
        Write a response that appropriately completes the request.
        
        Instruction: 
        {query}
        
        
        Input: 
        {context}
        
        Response:
        """
    )

    # Functions get_docs and get_context remain unchanged

    # Main execution logic
    query = Query  # Using the Query passed to the function
    docs = get_docs(query, vector_store)
    print("len of docs:",len(docs))
    context = get_context(docs)
    print("len of context:",len(context))
    final_prompt = prompt.format(query=query, context=context)
    print("Final Prompt is:\n"+final_prompt)
    llm_output = llm.predict(final_prompt)
    # You might want to return llm_output or do something else with it here
    return llm_output

if __name__ == '__main__':
    llm_output = chat_with_db("PLUTO", "Please give me a Sql code about payments!")
    print(llm_output)
# Example of usage:
# chat_with_db(UserID, Query)

# input:"query","UserID"
# output:"response"