from langchain_community.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings

# Path to uploaded files
VECTORSTORE_PATH = r"C:\Users\peter\Documents\AI\Flutter\nuvana\embeddings\bible_verse_embeddings"

# Load the vectorstore
embedding_model = OpenAIEmbeddings()
db = FAISS.load_local(VECTORSTORE_PATH, embedding_model, allow_dangerous_deserialization=True)

# Perform a test query
query = "What does the Bible say about anxiety?"
results = db.similarity_search(query, k=3)

# Display the top 3 matching verses
for i, doc in enumerate(results, 1):
    ref = doc.metadata.get("reference", "Unknown Reference")
    print(f"{i}. {ref} - {doc.page_content}")
    print(f"   Tags: Genre={doc.metadata.get('genre')}, Theme={doc.metadata.get('theme')}, Emotion={doc.metadata.get('emotion')}, Doctrine={doc.metadata.get('doctrine')}")
    print()
