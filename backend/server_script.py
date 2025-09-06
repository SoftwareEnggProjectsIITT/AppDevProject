import os
from dotenv import load_dotenv
import google.generativeai as genai
from langchain_community.vectorstores import Chroma
from langchain.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain_google_genai import GoogleGenerativeAIEmbeddings, ChatGoogleGenerativeAI
import warnings


warnings.filterwarnings("ignore", category=UserWarning)
warnings.filterwarnings("ignore", category=DeprecationWarning)


#Configure Gemini API
load_dotenv()
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
genai.configure(api_key=GEMINI_API_KEY)

# =============================
# 1. Set up embedding model
# =============================
llm = ChatGoogleGenerativeAI(
    model="gemini-2.5-flash",
    google_api_key=GEMINI_API_KEY,
    temperature=1
)

embedding_model = GoogleGenerativeAIEmbeddings(
    model="models/embedding-001",
    google_api_key=GEMINI_API_KEY
)


# =============================
# 2. Category List
# =============================
CATEGORY_LIST = """
1) Agriculture, Co-operatives, and Farm Laws 
2) Banking, Finance Insurance Security
3) Civil Procedure, Civil Law Property
4) Constitutional and General Law
5) Consumer Public Interest Safety Law
6) Corporate Commercial Financial Laws
7) Crime, Special Statutes Laws
8) Criminal Procedure Evidence Laws
9) Education Health Medical regulation Laws
10) Environment, Forest, Wildlife and Biodiversity Laws
11) Intellectual Property Laws
12) IT, Data and Telecom Laws
13) Juvenile Family and Personal Laws
14) Labor and Employment Laws
15) Miscellaneous Procedure Governance Laws
16) Taxation, Indirect Tax Laws
17) Transport and Infrastructure Laws
"""

VECTOR_DB_ROOT = "vector_db"  # same as embedding script

# =============================
# 3. Classify Category
# =============================
def classify_category(query: str) -> int:
    """
    Use LLM to classify the query into one of the 17 predefined categories.
    """
    prompt = f"""
    You are a legal categorization expert. 
    The user asks: "{query}"

    Based on the list of categories below, determine the **single most relevant category number**.
    Only respond with the number (1-17), nothing else.

    Categories:
    {CATEGORY_LIST}
    """

    response = llm.invoke(prompt)
    try:
        category_num = int(response.content.strip())
        if 1 <= category_num <= 17:
            return category_num
        else:
            raise ValueError(f"Invalid category number from model: {category_num}")
    except Exception as e:
        raise ValueError(f"Failed to classify category: {response.content}") from e

# =============================
# 4. Load Chroma Vector DB
# =============================
def load_vectorstore(category_id: int):
    """
    Load a category-specific Chroma DB.
    """
    category_dirs = os.listdir(VECTOR_DB_ROOT)
    if category_id - 1 >= len(category_dirs):
        raise ValueError(f"No vector DB found for category {category_id}")

    category_name = sorted(category_dirs)[category_id - 1]  # sort to ensure order
    category_path = os.path.join(VECTOR_DB_ROOT, category_name)


    return Chroma(
        persist_directory=category_path,
        embedding_function=embedding_model
    )

# =============================
# 5. Build RAG Chain
# =============================
def build_chain(vectorstore):
    """
    Build a retrieval-augmented generation chain using a vector store.
    """
    retriever = vectorstore.as_retriever(search_kwargs={"k": 5})

    prompt_template = """
    You are an expert legal and law assistant.
When answering, strictly use the provided dataset as your source.

If the answer is present in the dataset, provide it accurately.

If the answer is not present in the dataset, explicitly state:
“No such provision is present in government laws/schemes.”

Then, provide a relevant answer based only on the dataset’s knowledge, not external knowledge.

    Question: {question}

    Context:
    {context}

    Instructions:
    - Keep answers concise (3–5 sentences)
    - Highlight important terms
    - Always cite relevant section/page numbers if available
    """

    prompt = ChatPromptTemplate.from_template(prompt_template)

    chain = (
        {"context": retriever, "question": RunnablePassthrough()}
        | prompt
        | llm
        | StrOutputParser()
    )
    return chain

# =============================
# 6. Ask a Question
# =============================
def ask_question(query: str) -> str:
    try:
        category_id = classify_category(query)

        vectorstore = load_vectorstore(category_id)
        chain = build_chain(vectorstore)

        query += " Explain reasoning and cite section or page number if possible."
        answer = chain.invoke(query)
        return answer.strip()

    except Exception as e:
        return f"Error: {str(e)}"


user_query = "Impact of gst rate cut on new car buy"
print(ask_question(user_query))
