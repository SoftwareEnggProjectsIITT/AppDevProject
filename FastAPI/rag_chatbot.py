# rag_chatbot.py
#not the correct file just for reference
from langchain_community.document_loaders import UnstructuredPDFLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import Chroma
from langchain_community.embeddings import OllamaEmbeddings
from langchain.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_ollama import ChatOllama
from langchain_core.runnables import RunnablePassthrough

# ---- Load PDF ----
local_path = ["consti.pdf"]
all_docs = []

for path in local_path:
    loader = UnstructuredPDFLoader(file_path=path)
    data = loader.load()
    all_docs.extend(data)

# ---- Split into chunks ----
text_splitter = RecursiveCharacterTextSplitter(chunk_size=5000, chunk_overlap=750)
chunks = text_splitter.split_documents(all_docs)

# ---- Vector DB ----
vector_db = Chroma.from_documents(
    documents=chunks,
    embedding=OllamaEmbeddings(model="mxbai-embed-large", show_progress=True),
    collection_name="local-rag",
)

retriever = vector_db.as_retriever()

# ---- LLM ----
llm = ChatOllama(model="llama2")

# ---- Prompt ----
prompt = ChatPromptTemplate.from_template(
    """
You are a legal assistant. Use the following retrieved context to answer the question.

Context: {context}
Question: {question}
Answer:
"""
)


# ---- RAG Pipeline ----
def rag_chatbot(query: str) -> str:
    # Retrieve docs
    retrieved_docs = retriever.get_relevant_documents(query)
    context = "\n".join([doc.page_content for doc in retrieved_docs])

    # Format prompt
    chain = (
        {"context": RunnablePassthrough(), "question": RunnablePassthrough()}
        | prompt
        | llm
        | StrOutputParser()
    )

    response = chain.invoke({"context": context, "question": query})
    return response
