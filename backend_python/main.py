from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware

from langchain_ollama import OllamaEmbeddings, ChatOllama
from langchain_chroma import Chroma
from langchain_core.documents import Document

import re

# =========================================================
# FASTAPI APP
# =========================================================

app = FastAPI()

# Enable CORS (important for Flutter Web)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# =========================================================
# STEP 1: Read & Clean File (UNCHANGED LOGIC)
# =========================================================

with open("data_doc(1).csv", "r", encoding="utf-8") as f:
    raw_text = f.read()

raw_text = raw_text.replace('""', '').replace('"', '')

documents_split = re.split(r'\n\d+\.\s', raw_text)

documents = []

for doc in documents_split:
    clean_doc = doc.strip()
    if len(clean_doc) > 200:
        documents.append(Document(page_content=clean_doc))

print(f"Prepared {len(documents)} documents")

# =========================================================
# STEP 2: Embeddings + Chroma (UNCHANGED)
# =========================================================

embeddings = OllamaEmbeddings(model="mxbai-embed-large")

db_location = "./chroma_langchain_db"

vector_store = Chroma(
    collection_name="data_doc",
    persist_directory=db_location,
    embedding_function=embeddings
)

if vector_store._collection.count() == 0:
    vector_store.add_documents(documents)
    print(f"Added {len(documents)} documents ✅")
else:
    print(f"DB already contains {vector_store._collection.count()} documents [OK]")

# =========================================================
# STEP 3: Load Qwen Model (UNCHANGED)
# =========================================================

llm = ChatOllama(
    model="qwen2.5:3b-instruct-q4_K_M",
    temperature=0
)

# =========================================================
# STEP 4: Ask Function (UNCHANGED LOGIC)
# =========================================================

def ask_question(question: str):

    docs = vector_store.similarity_search(question, k=1)

    if not docs:
        return "Information not found in database"

    context = docs[0].page_content

    prompt = f"""
You are a strict document assistant.

Answer ONLY using the given context.
Do NOT add extra information.

Return EXACTLY in this format:

"Title"
"Description"
"Full Description Text"
"Usages"
"* bullet"
"* bullet"
"Documents Required"
"* bullet"
"* bullet"
"Approximate Renewal/Update Time"
"Time Value"
"Information Mentioned"
"* bullet"
"* bullet"

Context:
{context}

Question:
{question}
"""

    response = llm.invoke(prompt)
    return response.content

# =========================================================
# REQUEST MODEL
# =========================================================

class QuestionRequest(BaseModel):
    question: str

# =========================================================
# API ROUTE
# =========================================================

@app.post("/process-ai")
async def ask_ai(request: QuestionRequest):
    try:
        answer = ask_question(request.question)

        return {
            "success": True,
            "answer": answer
        }

    except Exception as e:
        return {
            "success": False,
            "answer": f"Error: {str(e)}"
        }

# =========================================================
# ROOT ROUTE (Optional)
# =========================================================

@app.get("/")
def root():
    return {"message": "AI Service Running"}
