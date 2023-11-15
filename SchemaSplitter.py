import re
from langchain.docstore.document import Document


def schema_splitter(file_path):
    with open(file_path, 'r') as f:
        schema = f.read()
        f.close()

    # 以CREATE TABLE开头, 以分号;结尾
    pattern = r'CREATE TABLE[\s\S]*?;'
    result = re.findall(pattern, schema)

    documents = []
    for i, text in enumerate(result):
        new_doc = Document(page_content=text, metadata={})
        documents.append(new_doc)
    return documents


print(schema_splitter('mediawiki.sql')[0])
