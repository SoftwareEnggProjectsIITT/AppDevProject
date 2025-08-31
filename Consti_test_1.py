#!/usr/bin/env python
# coding: utf-8

# In[1]:


get_ipython().system('pip install langchain')


# In[2]:


from langchain_community.document_loaders import UnstructuredPDFLoader
from langchain_community.document_loaders import OnlinePDFLoader


# In[3]:


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


# In[4]:


get_ipython().system('ollama pull nomic-embed-text')


# In[5]:


get_ipython().system('ollama list')


# In[6]:


from langchain_community.embeddings import OllamaEmbeddings
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import Chroma


# In[7]:


#Split and chunk
text_splitter = RecursiveCharacterTextSplitter(chunk_size = 5000, chunk_overlap = 750)
chunks = text_splitter.split_documents(all_docs)


# In[8]:


#Add to vector database
vector_db = Chroma.from_documents(
    documents = chunks,
    embedding = OllamaEmbeddings(model = "mxbai-embed-large", show_progress = True),
    collection_name = "local-rag"
)


# In[9]:


get_ipython().system('pip install -U langchain-ollama')


# In[10]:


from langchain.prompts import ChatPromptTemplate, PromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_ollama import ChatOllama
from langchain_core.runnables import RunnablePassthrough
from langchain.retrievers.multi_query import MultiQueryRetriever


# In[11]:


#LLM from Ollama
local_model = "llama3.2"
llm = ChatOllama(model=local_model)


# In[12]:


QUERY_PROMPT = PromptTemplate(
    input_variables=["question"],
    template="""You are an AI assistant who only answers based on the given context. Help me resolve my doubts from the Indian Constitution, give an answer in no more than 100 characters: 
    Original question: {question}"""
)


# In[13]:


retriever = MultiQueryRetriever.from_llm(
    vector_db.as_retriever(),
    llm,
    prompt=QUERY_PROMPT
)

#RAG prompt
template = """
You are a helping assistant for the government of India. For the given user input help me find relevant things from it through the context provided and 
also **keep the answer short**. Also tell the page number from where it can be found:


Context:
{context}

Question: {question}
"""


prompt = ChatPromptTemplate.from_template(template)


# In[14]:


chain = (
    {"context": retriever, "question": RunnablePassthrough()}
    | prompt
    | llm
    | StrOutputParser()
)


# In[15]:


retriever


# In[16]:


prompt = "What is the Preamble of the Constitution, and what are its key words (Sovereign, Socialist, Secular…)?"


# In[17]:


back_prompt = "Explain your reasoning and tell section or page number where it can be found"


# In[18]:


text = chain.invoke(prompt + back_prompt).replace("\\n", " ")
text


# In[19]:


get_ipython().system('pip install gtts')


# In[16]:


andu = "tuje chu na jahe !!!! mere ye mere ye !! pink lips pink lips"


# In[17]:


from gtts import gTTS

tts = gTTS(andu, lang = "hi",tld = "co.in")
tts.save("output.mp3")


# In[ ]:




