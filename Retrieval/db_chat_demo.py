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
#from .llm_server_demo import LLM_Server     #use our investchat
from .llm_server_gpt import LLM_Server    #use gpt3.5
#from Retrieval import LLM_Server
from langchain.chains import RetrievalQA
warnings.filterwarnings("ignore")

embeddings_model_name = r"Retrieval/Embedding/bge-base-en-v1.5/"
embeddings_model_kwargs = {'device': 'cuda:2'}
embeddings_encode_kwargs = {'normalize_embeddings':True}

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
    # Validate UserID
    if not UserID:
        print("UserID cannot be empty.")
        return
    index_file = os.path.join(r"mounted_repos/Permanent_Database/", f"{UserID}_Database")

    # Initialize global objects
    embeddings = HuggingFaceEmbeddings(model_name=embeddings_model_name,model_kwargs=embeddings_model_kwargs,encode_kwargs=embeddings_encode_kwargs)
#    vector_store = FAISS.load_local(index_file, embeddings)
    vector_store = Chroma(persist_directory=index_file, embedding_function=embeddings)
    prompt = PromptTemplate(
        input_variables=["query","context"],
        template="""
        Your job is to provide a clear and accurate answer to the user's instruction based on the provided input context.
        If the reference context does not contain information to answer the question, please ignore it.
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
    llm = LLM_Server().llm_provider()
    final_prompt = prompt.format(query=query, context=context)
    print("Final Prompt is:\n"+final_prompt)
    llm_output = llm.predict(final_prompt)
    # You might want to return llm_output or do something else with it here
    return llm_output

# Example of usage:
# chat_with_db(UserID, Query)

# input:"query","UserID"
# output:"response"