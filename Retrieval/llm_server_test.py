from langchain.chat_models import ChatOpenAI
from langchain.document_loaders import TextLoader
from langchain.indexes import VectorstoreIndexCreator
from langchain.embeddings import HuggingFaceEmbeddings
import openai

openai.api_key = "EMPTY"
openai.api_base = "http://localhost:8000/v1"
embeddings_model_name = r"Retrieval/Embedding/bge-base-en-v1.5/"
embeddings_model_kwargs = {'device': 'cuda'}
embeddings_encode_kwargs = {'normalize_embeddings':True}
embedding = HuggingFaceEmbeddings(model_name=embeddings_model_name,model_kwargs=embeddings_model_kwargs,encode_kwargs=embeddings_encode_kwargs)
loader = TextLoader("/home/ubuntu/ShenXiaoping/DBChat/Retrieval/state_of_the_union.txt")
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