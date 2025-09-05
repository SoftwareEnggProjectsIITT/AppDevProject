import os
from dotenv import load_dotenv
import google.generativeai as genai
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from langchain_community.document_loaders import PyPDFLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import Chroma

# =============================
# 1. Load environment variables
# =============================
#Configure Gemini API
load_dotenv()
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
genai.configure(api_key=GEMINI_API_KEY)

# =============================
# 2. Set up embedding model
# =============================
embedding_model = GoogleGenerativeAIEmbeddings(
    model="models/embedding-001",
    google_api_key=GEMINI_API_KEY
)
print('auth key is valid')

# =============================
# 2. Config
# =============================
DOCS_FOLDER = "data_for_rag"  # root folder containing category subfolders
DB_DIR = "vector_db"          # parent folder for all Chroma DBs
os.makedirs(DB_DIR, exist_ok=True)

# =============================
# 3. Process PDFs category-wise
# =============================
text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)

for category in os.listdir(DOCS_FOLDER):
    category_path = os.path.join(DOCS_FOLDER, category)
    if not os.path.isdir(category_path):
        continue

    print(f"\n=== Processing category: {category} ===")
    all_docs = []

    # Recursively load PDFs
    for root, dirs, files in os.walk(category_path):
        for filename in files:
            if filename.endswith(".pdf"):
                filepath = os.path.join(root, filename)
                print(f"Loading {filepath}...")
                loader = PyPDFLoader(filepath)
                docs = loader.load()
                all_docs.extend(docs)

    if not all_docs:
        print(f"No PDFs found in {category}")
        continue

    print(f"Total documents loaded for {category}: {len(all_docs)}")

    # =============================
    # 4. Split documents into chunks
    # =============================
    split_docs = text_splitter.split_documents(all_docs)
    print(f"Total document chunks for {category}: {len(split_docs)}")

    # =============================
    # 5. Save embeddings per category
    # =============================
    category_db_path = os.path.join(DB_DIR, category)
    os.makedirs(category_db_path, exist_ok=True)

    print(f"Generating embeddings and saving to {category_db_path}...")
    vectorstore = Chroma.from_documents(
        split_docs,
        embedding_model,
        persist_directory=category_db_path
    )
    vectorstore.persist()

    print(f"✅ Embeddings saved for {category} in '{category_db_path}'")

print("\nAll categories processed successfully!")
