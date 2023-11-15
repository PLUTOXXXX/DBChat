import re
from langchain.docstore.document import Document
import os


def list_files_in_directory(directory_path):
    list_files = []
    for file_name in os.listdir(directory_path):
        if os.path.isfile(os.path.join(directory_path, file_name)):
            list_files.append(os.path.join(directory_path, file_name))

    return list_files


def schema_splitter(directory_path):
    list_files = list_files_in_directory(directory_path)
    documents = []
    for file in list_files:
        if file[-3:] == 'sql':
            with open(file, 'r') as f:
                schema = f.read()
                f.close()

            # 以CREATE TABLE开头, 以分号;结尾
            pattern = r'CREATE TABLE[\s\S]*?;'
            result = re.findall(pattern, schema)
            for i, text in enumerate(result):
                new_doc = Document(page_content=text, metadata={})
                documents.append(new_doc)

    return documents

