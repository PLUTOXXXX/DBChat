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

current_script_path = os.path.abspath(__file__)
current_directory = os.path.dirname(current_script_path)
parent_directory = os.path.dirname(current_directory)
mounted_repos_path = parent_directory+'/mounted_repos/'
def build_user_database(user_id: str):
    user_directory = f"{user_id}"
    user_database = f"{user_id}_Database"
    directory_path = os.path.join(mounted_repos_path, user_directory)
    index_file = os.path.join(mounted_repos_path, user_database)
    embeddings_model_path =  parent_directory+'/model/embedding/bge-base-en-v1.5/' 
    embeddings_model_kwargs = {'device': 'cuda'}
    embeddings_encode_kwargs = {'normalize_embeddings':True}
    embeddings = HuggingFaceEmbeddings(model_name=embeddings_model_path,model_kwargs=embeddings_model_kwargs,encode_kwargs=embeddings_encode_kwargs)
    print("embedding model has loaded!")
    
    #Build database
    chunks = schema_splitter(directory_path)
    
    print(chunks)
    
    db = Chroma.from_documents(chunks, embeddings,persist_directory = index_file)
    
    # print(db.get())
    
    print(f"{user_id}'s Private Database was Built!")

if __name__ == '__main__':
    build_user_database("PLUTO")
# Example of usage:
# build_user_database(user_id)

# input:"UserID"
# output:"/InvestChat/Retrieval/mounted_repos/Permanent_Database/'UseID'_Database"
