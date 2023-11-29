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

current_script_path = os.path.abspath(__file__)
current_directory = os.path.dirname(current_script_path)
parent_directory = os.path.dirname(current_directory)
mounted_repos_path = parent_directory+'/mounted_repos/'
embeddings_model_path =  parent_directory+'/model/embedding/bge-base-en-v1.5/' 
embeddings_model_kwargs = {'device': 'cuda'}
embeddings_encode_kwargs = {'normalize_embeddings':True}

openai.api_key = "EMPTY"
openai.api_base = "http://localhost:8000/v1"
llm = ChatOpenAI(model="gpt-3.5-turbo", openai_api_key=openai.api_key, openai_api_base=openai.api_base)

def get_docs(query, db):
    """
    Search for documents similar to the query in the given database.
    """
    docs = db.similarity_search(query,k=10)
    return docs

def get_context(docs):
    """
    Extract and return context from the retrieved documents.
    """
    context = docs[:5]
    return context

def chat_with_db(UserID, Query):
    """
    The main function to chat with database using UserID and Query
    """
    print(f"UserID: {UserID}, Query: {Query}")
        
    
    # Validate UserID
    if not UserID:
        print("UserID cannot be empty.")
        return
    index_file = os.path.join(mounted_repos_path, f"{UserID}_Database")
    # index_file = r"/home/ubuntu/ShenXiaoping/DBChat/mounted_repos/PLUTO_Database/"
    # print(index_file)

    # Initialize global objects
    embeddings = HuggingFaceEmbeddings(model_name=embeddings_model_path,model_kwargs=embeddings_model_kwargs,encode_kwargs=embeddings_encode_kwargs)
    vector_store = Chroma(persist_directory=index_file, embedding_function=embeddings)
    
    # print(vector_store.get())
        
        
    prompt = PromptTemplate(
        input_variables=["query","context"],
        template="""
        Please Give me a sql code based on the Instruction and Input information. Just give me the sql code, don't do any explain.
        
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
    output1 = llm.predict(final_prompt)
    output2 = output1
    # You might want to return llm_output or do something else with it here
    return output1,output2

if __name__ == '__main__':
    llm_output = chat_with_db("PLUTO", "Please give me a Sql code about payments!")
    print(llm_output)
# Example of usage:
# chat_with_db(UserID, Query)

# input:"query","UserID"
# output:"response"