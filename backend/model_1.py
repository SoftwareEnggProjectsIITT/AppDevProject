import os
from dotenv import load_dotenv
import google.generativeai as genai
from pathlib import Path
from langchain_community.document_loaders import UnstructuredPDFLoader, PyPDFLoader
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


# helper to auto fetch all pdfs from folder
def get_pdfs(folder: str):
    folder = os.path.normpath(folder)  # normalize slashes
    return [os.path.join(folder, os.path.basename(p)) for p in Path(folder).glob("*.pdf")]


#Defining Categories for which pdf to pass to embed and corresponding QUERY_PROMPT for it
categories = {
    1: {
        "pdfs": get_pdfs("data_for_rag/Agriculture_Co-operatives_Farm_laws"),
        "QUERY_PROMPT": PromptTemplate(
            input_variables=["question"],
            template="""
You are an expert query reformulator.  
The user has asked the following question about Agriculture, Co-operatives, and Farm Laws in India:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
        )
    },
    2: {
        "pdfs": get_pdfs("data_for_rag/Banking_&_Finance_Insurance_Security"),
        "QUERY_PROMPT": PromptTemplate(
            input_variables=["question"],
            template="""
You are an expert query reformulator.  
The user has asked the following question about Banking, Finance Insurance Security in India:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
        )
    },
    3: {
        "pdfs": get_pdfs("data_for_rag/Civil_procedure_Civil_law_Property"),
        "QUERY_PROMPT": PromptTemplate(
            input_variables=["question"],
            template="""
You are an expert query reformulator.  
The user has asked the following question about Civil Procedure, Civil Law Property in India:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
        )
    },
    4: {
        "pdfs": get_pdfs("data_for_rag/Constitutional_General"),
        "QUERY_PROMPT": PromptTemplate(
            input_variables=["question"],
            template="""
You are an expert query reformulator.  
The user has asked the following question about Civil Procedure, Civil Law Property in India:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
        )
    },
    5: {
        "pdfs": get_pdfs("data_for_rag/Consumer_Public_interest_Safety"),
        "QUERY_PROMPT": PromptTemplate(
            input_variables=["question"],
            template="""
You are an expert query reformulator.  
The user has asked the following question about Consumer Public Interest Safety in India:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
        )
    },
    6: {
        "pdfs": get_pdfs("data_for_rag/Corporate_Commercial_Financial"),
        "QUERY_PROMPT": PromptTemplate(
            input_variables=["question"],
            template="""
You are an expert query reformulator.  
The user has asked the following question about Corporate Commercial Financial Laws in India:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
        )
    },
    7: {
        "pdfs": get_pdfs("data_for_rag/Crime_Special_statutes"),
        "QUERY_PROMPT": PromptTemplate(
            input_variables=["question"],
            template="""
You are an expert query reformulator.  
The user has asked the following question about Crime, Special Statutes Laws in India:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
        )
    },
    8: {
        "pdfs": get_pdfs("data_for_rag/Criminal_Procedure_Evidence"),
        "QUERY_PROMPT": PromptTemplate(
            input_variables=["question"],
            template="""
You are an expert query reformulator.  
The user has asked the following question about Criminal Procedure Evidence Laws in India:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
        )
    },
    9: {
        "pdfs": get_pdfs("data_for_rag/Education_Health_Medical_regulation"),
        "QUERY_PROMPT": PromptTemplate(
            input_variables=["question"],
            template="""
You are an expert query reformulator.  
The user has asked the following question about Education Health Medical regulation Laws in India:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
        )
    },
    10: {
        "pdfs": get_pdfs("data_for_rag/Environment_Forest_Wildlife_Biodiversity"),
        "QUERY_PROMPT": PromptTemplate(
            input_variables=["question"],
            template="""
You are an expert query reformulator.  
The user has asked the following question about Environment, Forest, Wildlife and Biodiversity Laws in India:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
        )
    },
    11: {
        "pdfs": get_pdfs("data_for_rag/Intellectual_Property"),
        "QUERY_PROMPT": PromptTemplate(
            input_variables=["question"],
            template="""
You are an expert query reformulator.  
The user has asked the following question about Intellectual Property Laws in India:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
        )
    },
    12: {
        "pdfs": get_pdfs("data_for_rag/IT_Data_Telecom"),
        "QUERY_PROMPT": PromptTemplate(
            input_variables=["question"],
            template="""
You are an expert query reformulator.  
The user has asked the following question about IT, Data and Telecom Laws in India:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
        )
    },
    13: {
        "pdfs": get_pdfs("data_for_rag/Juvenile_Family_Personal_law"),
        "QUERY_PROMPT": PromptTemplate(
            input_variables=["question"],
            template="""
You are an expert query reformulator.  
The user has asked the following question about Juvenile Family and Personal Laws in India:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
        )
    },
    14: {
        "pdfs": get_pdfs("data_for_rag/Labour_&_Employment"),
        "QUERY_PROMPT": PromptTemplate(
            input_variables=["question"],
            template="""
You are an expert query reformulator.  
The user has asked the following question about Labour and Employment Laws in India:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
        )
    },
    15: {
        "pdfs": get_pdfs("data_for_rag/Misc_Procedure_Governance"),
        "QUERY_PROMPT": PromptTemplate(
            input_variables=["question"],
            template="""
You are an expert query reformulator.  
The user has asked the following question about Miscellaneous Procedure Governance Laws in India:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
        )
    },
    16: {
        "pdfs": get_pdfs("data_for_rag/Taxation_Indirect_tax"),
        "QUERY_PROMPT": PromptTemplate(
            input_variables=["question"],
            template="""
You are an expert query reformulator.  
The user has asked the following question about Taxation, Indirect Tax Laws in India:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
        )
    },
    17: {
        "pdfs": get_pdfs("data_for_rag/Transport_Infrastructure"),
        "QUERY_PROMPT": PromptTemplate(
            input_variables=["question"],
            template="""
You are an expert query reformulator.  
The user has asked the following question about Taxation, Indirect Tax Laws in India:  

Question: {question}  

Generate 3 alternative queries that may retrieve relevant passages from the documents.  
Make sure they are semantically different but preserve the meaning.  
Do not answer the question, only produce the reformulated queries.
"""
        )
    },

}


# Gemini LLM
llm = ChatGoogleGenerativeAI(
    model = "gemini-2.5-flash",
    google_api_key = GEMINI_API_KEY,
    temperature = 1
)

#Embeddings with Gemini too
embedding_model = GoogleGenerativeAIEmbeddings(
    model="models/embedding-001",
    google_api_key=GEMINI_API_KEY
)

#Build a general pipeline for the selected documents and query
def build_chain(category_id: int):
    if category_id not in categories:
        raise ValueError(f"Invalid category {category_id}. Choose from {list(categories.keys())}")

    all_docs = []
    for path in categories[category_id]["pdfs"]:
        loader = PyPDFLoader(file_path=path)
        data = loader.load()
        all_docs.extend(data)

    print(f"Total documents loaded: {len(all_docs)}")

    #Split into chunks
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=2500, chunk_overlap=400)
    chunks = text_splitter.split_documents(all_docs)


    #Chroma vector DB
    vector_db = Chroma.from_documents(
        documents=chunks,
        embedding=embedding_model,
        collection_name="gemini-rag"
    )

    #Retriever
    retriever = MultiQueryRetriever.from_llm(
        vector_db.as_retriever(),
        llm,
        prompt=categories[category_id]["QUERY_PROMPT"]
    )

    #Define custom RAG prompt
    template = """
    You are an expert assistant. First, check if the provided context has the answer. 
    If yes, answer using context. 
    If not, use your own knowledge to answer accurately.
    

    Provide a concise explanation and include page or section or article numbers from the context if available.  

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
    return chain


def ask_question(query: str, category_id: int) -> str:
    """
    Query the RAG pipeline with a user question.
    
    Args:
        query (str): User's question about the Constitution.
    
    Returns:
        str: Formatted answer from the RAG pipeline.
    """
    try:
        chain = build_chain(category_id)
        back_prompt = "Explain your reasoning and tell section or page number where it can be found"
        query = query + back_prompt
        answer = chain.invoke(query)
        return answer.strip()
    except Exception as e:
        return f"Error: {str(e)}"


#Testing and improving
#print(ask_question("My Wife is accusing me for fake domestic violence and demanding money, what can I do?", 13))

print(get_pdfs("data_for_rag/Banking_&_Finance_Insurance_Security"))