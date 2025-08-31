#!/usr/bin/env python
# coding: utf-8

# STEP 1: Install dependencies
# pip install google-generativeai langchain langchain-community langchain-google-genai chromadb

import os
from dotenv import load_dotenv
import google.generativeai as genai
from langchain_community.document_loaders import UnstructuredPDFLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import Chroma
from langchain.prompts import ChatPromptTemplate, PromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain.chains import RetrievalQA
from langchain_google_genai import GoogleGenerativeAIEmbeddings, ChatGoogleGenerativeAI
from langchain.retrievers.multi_query import MultiQueryRetriever

# STEP 2: Configure Gemini API
load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
genai.configure(api_key=GEMINI_API_KEY)

# STEP 3: Load PDF documents
local_path = ["consti.pdf"]
all_docs = []

if local_path:
    for path in local_path:
        loader = UnstructuredPDFLoader(file_path=path)
        data = loader.load()
        all_docs.extend(data)

    print(f"Total documents loaded: {len(all_docs)}")
else:
    print("PDF file not uploaded")

# STEP 4: Split into chunks
text_splitter = RecursiveCharacterTextSplitter(chunk_size=2000, chunk_overlap=300)
chunks = text_splitter.split_documents(all_docs)

# STEP 5: Embeddings with Gemini
embedding_model = GoogleGenerativeAIEmbeddings(
    model="models/embedding-001",
    google_api_key=GEMINI_API_KEY   # ✅ pass API key here
)

# STEP 6: Store in Chroma vector DB
vector_db = Chroma.from_documents(
    documents=chunks,
    embedding=embedding_model,
    collection_name="gemini-rag"
)

# STEP 9: Setup Gemini LLM
llm = ChatGoogleGenerativeAI(
    model = "gemini-2.5-flash",
    google_api_key = GEMINI_API_KEY,
    temperature = 0.2
)

QUERY_PROMPT = PromptTemplate(
    input_variables=["question"],
    template="""You are an AI assistant who only answers based on the given context. Help me resolve my doubts from the Indian Constitution, give an answer in no more than 100 characters: 
    Original question: {question}"""
)

# STEP 7: Define Retriever
retriever = MultiQueryRetriever.from_llm(
    vector_db.as_retriever(),
    llm,
    prompt=QUERY_PROMPT
)

# STEP 8: Define custom RAG prompt
template = """
You are a helpful assistant for the government of India.
Use the following context to answer the question briefly 
and mention the page number if possible.

Context:
{context}

Question: {question}
"""

prompt = ChatPromptTemplate.from_template(template)


# STEP 10: RAG chain
chain = (
    {"context": retriever, "question": RunnablePassthrough()}
    | prompt
    | llm
    | StrOutputParser()
)

# STEP 11: Test the pipeline
prompt = "What is the Preamble of the Constitution, and what are its key words?"
back_prompt = "Explain your reasoning and tell section or page number where it can be found"
answer = chain.invoke(prompt+back_prompt)

print("\nQ:", prompt)
print("A:", answer)