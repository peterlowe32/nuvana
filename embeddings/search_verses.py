import os
from langchain_community.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings

# === CONFIG ===
VECTORSTORE_PATH = "bible_verse_embeddings"  # use relative path for cloud compatibility
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

# === LOAD VECTORSTORE ===
embedding_model = OpenAIEmbeddings(openai_api_key=OPENAI_API_KEY)
db = FAISS.load_local(VECTORSTORE_PATH, embedding_model, allow_dangerous_deserialization=True)

# === SEARCH FUNCTION ===
def search_verses(query, k=3):
    results = db.similarity_search(query, k=k)
    for i, result in enumerate(results, 1):
        metadata = result.metadata
        print(f"{i}. {metadata.get('reference', 'Unknown')} - {result.page_content}")
        print(f"   Tags: Genre={metadata.get('genre')}, Theme={metadata.get('theme')}, Emotion={metadata.get('emotion')}, Doctrine={metadata.get('doctrine')}\n")

# === RUN INTERACTIVELY ===
if __name__ == "__main__":
    while True:
        user_input = input("Enter a spiritual/emotional need (or 'q' to quit): ")
        if user_input.lower() == "q":
            break
        search_verses(user_input)
