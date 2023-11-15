from langchain.chat_models import ChatOpenAI
from langchain.document_loaders import TextLoader
from langchain.embeddings import OpenAIEmbeddings
from langchain.indexes import VectorstoreIndexCreator
import openai

openai.api_key = "EMPTY"
openai.api_base = "http://localhost:8000/v1"

embedding = OpenAIEmbeddings(model="text-embedding-ada-002", openai_api_key=openai.api_key, openai_api_base=openai.api_base)
loader = TextLoader("state_of_the_union.txt")
index = VectorstoreIndexCreator(embedding=embedding).from_loaders([loader])
llm = ChatOpenAI(model="gpt-3.5-turbo", openai_api_key=openai.api_key, openai_api_base=openai.api_base)

questions = [
    "Who is the speaker",
    "What did the president say about Ketanji Brown Jackson",
    "What are the threats to America",
    "Who are mentioned in the speech",
    "Who is the vice president",
    "How many projects were announced",
]
response = llm.predict("Hello")
print(response)
for query in questions:
    print("Query:", query)
    print("Answer:", index.query(query, llm=llm))