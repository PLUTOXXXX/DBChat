# --*--encoding:utf-8--*--
import os
from langchain.text_splitter import CharacterTextSplitter,RecursiveCharacterTextSplitter
from langchain.vectorstores import FAISS
from langchain.vectorstores import Chroma
from langchain.document_loaders import TextLoader, PyPDFLoader
from langchain.embeddings import HuggingFaceEmbeddings
from langchain.chat_models import ChatOpenAI
from SchemaSplitter import schema_splitter
import openai

openai.api_key = "EMPTY"
openai.api_base = "http://localhost:8000/v1"
llm = ChatOpenAI(model="gpt-3.5-turbo", openai_api_key=openai.api_key, openai_api_base=openai.api_base)


def build_user_database(user_id: str):
    user_directory = f"{user_id}"
    user_database = f"{user_id}_Database"
    directory_path = os.path.join("mounted_repos/Permanent_File/", user_directory)
    index_file = os.path.join("mounted_repos/Permanent_Database/", user_database)    
    #Load embeddings model
    embeddings_model_name = "Retrieval/Embedding/bge-base-en-v1.5/"
    embeddings_model_kwargs = {'device': 'cuda'}
    embeddings_encode_kwargs = {'normalize_embeddings':True}
    embeddings = HuggingFaceEmbeddings(model_name=embeddings_model_name,model_kwargs=embeddings_model_kwargs,encode_kwargs=embeddings_encode_kwargs)
    print("embedding model has loaded!")
    
    #Build database
    chunks = schema_splitter(directory_path)
    db = Chroma.from_documents(chunks, embeddings,persist_directory = index_file)
    print(f"{user_id}'s Private Database was Built!")

# Example of usage:
# build_user_database(user_id)

# input:"UserID"
# output:"/InvestChat/Retrieval/mounted_repos/Permanent_Database/'UseID'_Database"
