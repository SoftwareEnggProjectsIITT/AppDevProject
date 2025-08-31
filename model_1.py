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

#Configure Gemini API
load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
genai.configure(api_key=GEMINI_API_KEY)

#Load PDF documents
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

#Split into chunks
text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
chunks = text_splitter.split_documents(all_docs)

#Embeddings with Gemini too
embedding_model = GoogleGenerativeAIEmbeddings(
    model="models/embedding-001",
    google_api_key=GEMINI_API_KEY   #pass API key here
)

#Chroma vector DB
vector_db = Chroma.from_documents(
    documents=chunks,
    embedding=embedding_model,
    collection_name="gemini-rag"
)

# Gemini LLM
llm = ChatGoogleGenerativeAI(
    model = "gemini-2.5-flash",
    google_api_key = GEMINI_API_KEY,
    temperature = 0.2
)

QUERY_PROMPT = PromptTemplate(
    input_variables=["question"],
    template="""
You are an expert query reformulator.  
The user has asked the following question about the Indian Constitution:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
)


#Retriever
retriever = MultiQueryRetriever.from_llm(
    vector_db.as_retriever(),
    llm,
    prompt=QUERY_PROMPT
)

#Define custom RAG prompt
template = """
You are an expert assistant. First, check if the provided context has the answer. 
If yes, answer using context. 
If not, use your own knowledge to answer accurately.
 

Provide a concise explanation and include page or section numbers from the context if available.  

Context:
{context}

Question: {question}

Instructions:
- Summarize clearly in 3–5 sentences.  
- Highlight important keywords.  
- Always cite the page/section numbers at the end.  
"""


prompt = ChatPromptTemplate.from_template(template)


#RAG chain
chain = (
    {"context": retriever, "question": RunnablePassthrough()}
    | prompt
    | llm
    | StrOutputParser()
)

#Test the pipeline
'''
prompt = "What is the Preamble of the Constitution, and what are its key words?"
back_prompt = "Explain your reasoning and tell section or page number where it can be found"
answer = chain.invoke(prompt+back_prompt)
'''

def ask_constitution(query: str) -> str:
    """
    Query the RAG pipeline with a user question.
    
    Args:
        query (str): User's question about the Constitution.
    
    Returns:
        str: Formatted answer from the RAG pipeline.
    """
    try:
        back_prompt = "Explain your reasoning and tell section or page number where it can be found"
        query = query + back_prompt
        answer = chain.invoke(query)
        return answer.strip()
    except Exception as e:
        return f"Error: {str(e)}"
