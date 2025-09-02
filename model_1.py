import os
from dotenv import load_dotenv
import google.generativeai as genai
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

#Defining Categories for which pdf to pass to embed and corresponding QUERY_PROMPT for it
categories = {
    1: {
        "pdfs": ["data_for_rag/Agriculture_Co-operatives_Farm_laws/essential_commodities_act_1955.pdf"],
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
        "pdfs": ["data_for_rag\Banking_&_Finance_Insurance_Security/a1934-2.pdf",
                 "data_for_rag\Banking_&_Finance_Insurance_Security/A1999_41.pdf",
                 "data_for_rag\Banking_&_Finance_Insurance_Security/A2002-54.pdf",
                 "data_for_rag\Banking_&_Finance_Insurance_Security/A194910.pdf"],
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
        "pdfs": ["data_for_rag\Civil_procedure_Civil_law_Property/189304.pdf",
                 "data_for_rag\Civil_procedure_Civil_law_Property\A1948-56.pdf",
                 "data_for_rag\Civil_procedure_Civil_law_Property/a1958-28.pdf",
                 "data_for_rag\Civil_procedure_Civil_law_Property\A1963-47.pdf",
                 "data_for_rag\Civil_procedure_Civil_law_Property/the_registration_act,1908.pdf"],
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
        "pdfs": ["data_for_rag\Constitutional_General/20240716890312078.pdf",
                 "data_for_rag\Constitutional_General/the_general_clauses_act,_1897.pdf"],
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
        "pdfs": ["data_for_rag\Consumer_Public_interest_Safety/200634_food_safety_and_standards_act,_2006.pdf",
                 "data_for_rag\Consumer_Public_interest_Safety\drug_cosmeticsa1940-23.pdf",
                 "data_for_rag\Consumer_Public_interest_Safety\eng201935.pdf",
                 "data_for_rag\Consumer_Public_interest_Safety\essential_commodities_act_1955.pdf",
                 "data_for_rag\Consumer_Public_interest_Safety\legalmetrology_act_2009.pdf",
                 "data_for_rag\Consumer_Public_interest_Safety/right_yo_information_act.pdf",],
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
        loader = UnstructuredPDFLoader(file_path=path)
        data = loader.load()
        all_docs.extend(data)

    print(f"Total documents loaded: {len(all_docs)}")

    #Split into chunks
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=2000, chunk_overlap=300)
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


print(ask_question("How do Indian property and registration laws regulate transfer, registration, and limitation of rights in immovable property under the Transfer of Property Act, Registration Act, and Limitation Act?", 5))