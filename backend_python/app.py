from langchain_ollama import OllamaEmbeddings, ChatOllama
from langchain_chroma import Chroma
from langchain_core.documents import Document
import re

# -----------------------------
# STEP 1: Read & Clean File
# -----------------------------

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

# -----------------------------
# STEP 2: Embeddings + Chroma
# -----------------------------

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
    print(f"DB already contains {vector_store._collection.count()} documents ✅")

# -----------------------------
# STEP 3: Load Qwen Model
# -----------------------------

llm = ChatOllama(
    model="qwen2.5:3b-instruct-q4_K_M",
    temperature=0
)

# -----------------------------
# STEP 4: Ask Function
# -----------------------------

def ask_question(question: str):

    # Always get most similar document
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


# -----------------------------
# STEP 5: CLI Loop
# -----------------------------

while True:
    user_input = input("\nAsk Question (type 'exit' to quit): ")

    if user_input.lower() == "exit":
        break

    answer = ask_question(user_input)
    print("\nAnswer:\n")
    print(answer)
