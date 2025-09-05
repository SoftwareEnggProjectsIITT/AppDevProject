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
        "pdfs": ["essential_commodities_act_1955.pdf"],
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
        "pdfs": ["a1934-2.pdf",
                 "A1999_41.pdf",
                 "A2002-54.pdf",
                 "A194910.pdf"],
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
        "pdfs": ["189304.pdf",
                 "A1948-56.pdf",
                 "a1958-28.pdf",
                 "A1963-47.pdf",
                 "the_registration_act,1908.pdf"],
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
        "pdfs": ["20240716890312078.pdf",
                 "the_general_clauses_act,_1897.pdf"],
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
        "pdfs": ["200634_food_safety_and_standards_act,_2006.pdf",
                 "drug_cosmeticsa1940-23.pdf",
                 "eng201935.pdf",
                 "essential_commodities_act_1955.pdf",
                 "legalmetrology_act_2009.pdf",
                 "right_yo_information_act.pdf",],
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
        "pdfs": ["A1999_42.pdf",
                 "A2003-12.pdf",
                 "A2009-06.pdf",
                 "A2013-18.pdf",
                 "AA1992__15secu.pdf",
                 "indian_partnership_act_1932.pdf",
                 "negotiable_instruments_act,_1881.pdf",
                 "the_insolvency_and_bankruptcy_code,_2016.pdf"],
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
        "pdfs": ["A1959_54.pdf",
                 "A1967-37.pdf",
                 "A2003-15.pdf",
                 "corruptiona1988-49.pdf",
                 "scheduled_castes_and_the_scheduled_tribes.pdf",
                 "the_immoral_traffic_(prevention)_act,_1956.pdf"],
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
        "pdfs": ["A1963-36.pdf",
                 "AAA1948___37.pdf",
                 "iea_1872.pdf",
                 "repealedfileopen.pdf"],
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
        "pdfs": ["195603.pdf",
                 "A2017-10.pdf",
                 "A2019_30.pdf",
                 "the_right_of_children_to_free_and_compulsory_education_act_2009.pdf"],
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
        "pdfs": ["air_act-1981.pdf",
                 "ep_act_1986.pdf",
                 "the_biological_diversity_act,_2002.pdf",
                 "the_forest_(conservation)_act,_1980.pdf",
                 "the_water_(prevention_and_control_of_pollution)_act,_1974.pdf",
                 "the_wild_life_(protection)_act,_1972.pdf"],
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
        "pdfs": ["200016.pdf",
                 "A1970-39.pdf",
                 "A1999-48.pdf",
                 "the_copyright_act,_1957.pdf",
                 "the_trade_marks_act,_1999.pdf"],
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
        "pdfs": ["2bf1f0e9f04e6fb4f8fef35e82c42aa5.pdf",
                 "engaadhaar.pdf",
                 "indiantelegraphact_1885.pdf",
                 "it_act_2000_updated.pdf"],
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
        "pdfs": ["189008.pdf",
                 "A1869-04.pdf",
                 "A1872-15.pdf",
                 "A1937-26.pdf",
                 "A1955-25.pdf",
                 "a2016-2.pdf",
                 "AAA1956suc___30.pdf",
                 "protection_of_women_from_domestic_violence_act,_2005.pdf",
                 "special_marriage_act.pdf",
                 "the_hindu_adoptions_and_maintenance_act,1965.pdf"],
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
        "pdfs": ["a1948-011.pdf",
                 "A1972-39.pdf",
                 "A2013-14.pdf",
                 "A194863.pdf",
                 "maternity_benefit.pdf",
                 "payment_of_wages_act_1936.pdf"],
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
        "pdfs": ["A1923-19.pdf",
                 "a1972-52.pdf",
                 "a1996-26.pdf",
                 "A2005-53.pdf"],
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
        "pdfs": ["a1944-01.pdf",
                 "a1961-43.pdf",
                 "a2017-12.pdf",
                 "igst-act.pdf",
                 "the_customs_act,_1962.pdf"],
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
        "pdfs": ["197833.pdf",
                 "a1988-59.pdf",
                 "AAA1956____48.pdf",
                 "the_railways_act,_1989.pdf"],
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
print(ask_question("My Wife is accusing me for fake domestic violence and demanding money, what can I do?", 13))