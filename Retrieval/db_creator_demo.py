# --*--encoding:utf-8--*--
import os
from langchain.text_splitter import CharacterTextSplitter,RecursiveCharacterTextSplitter
from langchain.vectorstores import FAISS
from langchain.vectorstores import Chroma
from langchain.document_loaders import TextLoader, PyPDFLoader
from langchain.embeddings import HuggingFaceEmbeddings
import gradio as gr


def load_and_process_documents(directory_path: str, embeddings_model_name: str, index_file: str,
                               progress=gr.Progress()):
    supported_loaders = {
        '.txt': TextLoader,
        '.pdf': PyPDFLoader
    }

    documents = []
    progresses = progress.tqdm(os.listdir(directory_path),
                               desc="Please wait for building your personal knowledge base...")
    for filename in progresses:
        _, extension = os.path.splitext(filename)
        loader_class = supported_loaders.get(extension.lower())
        if not loader_class:
            print(f"Unsupported file type {extension} for file {filename}. Skipping.")
            continue

        loader = loader_class(os.path.join(directory_path, filename))
        try:
            docs = loader.load()
            documents.extend(docs)
        except Exception as e:
            print(f"Error loading document {filename}: {e}. Skipping.")

    if not documents:
        print("No documents loaded. Exiting.")
        return
    print("len of documents:", len(documents))
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=2000,chunk_overlap=200)
    chunks = text_splitter.split_documents(documents)
    print("A chunk example: "+"\n",chunks[0])
    print("len of chunks:", len(chunks))
    embeddings_model_kwargs = {'device': 'cuda'}
    embeddings_encode_kwargs = {'normalize_embeddings':True}
    embeddings = HuggingFaceEmbeddings(model_name=embeddings_model_name,model_kwargs=embeddings_model_kwargs,encode_kwargs=embeddings_encode_kwargs)
    print("embedding model has loaded!")
#    db = FAISS.from_documents(chunks, embeddings)
    db = Chroma.from_documents(chunks, embeddings,persist_directory = index_file)
#    db.save_local(index_file)
    print(f"Index saved to {index_file}")


def build_user_database(user_id: str, progress=gr.Progress()):
    user_directory = f"{user_id}"
    user_database = f"{user_id}_Database"
    directory_path = os.path.join("mounted_repos/Permanent_File/", user_directory)
    embeddings_model_name = "Retrieval/Embedding/bge-large-en-v1.5/"
    embeddings_model_kwargs = {'device': 'cuda'}
    embeddings_encode_kwargs = {'normalize_embeddings':True}
    index_file = os.path.join("mounted_repos/Permanent_Database/", user_database)

    load_and_process_documents(directory_path, embeddings_model_name, index_file, progress=progress)
    print(f"{user_id}'s Private Database was Built!")

# Example of usage:
# build_user_database(user_id)

# input:"UserID"
# output:"/InvestChat/Retrieval/mounted_repos/Permanent_Database/'UseID'_Database"
