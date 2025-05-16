import requests
from pathlib import Path
import os
import json
from langchain_community.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings
from openai import OpenAI

# === CONFIG ===
VECTORSTORE_PATH = VECTORSTORE_PATH = "bible_verse_embeddings"
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

# === SETUP ===
import requests
from pathlib import Path

download_embeddings_if_needed()
embedding_model = OpenAIEmbeddings(openai_api_key=OPENAI_API_KEY)
db = FAISS.load_local("bible_verse_embeddings", embedding_model, allow_dangerous_deserialization=True)

    faiss_path = folder / "index.faiss"
    pkl_path = folder / "index.pkl"

    if not faiss_path.exists():
        print("⬇️ Downloading index.faiss from Dropbox...")
        r = requests.get("https://www.dropbox.com/scl/fi/xe97xksd5kulpncoo0idu/index.faiss?rlkey=l7tn3jyf6jv5ymlrcfctovax9&st=2ix2d6cx&dl=1")
        r.raise_for_status()
        faiss_path.write_bytes(r.content)

    if not pkl_path.exists():
        print("⬇️ Downloading index.pkl from Dropbox...")
        r = requests.get("https://www.dropbox.com/scl/fi/w13ty9x10v5rgoytavo3s/index.pkl?rlkey=yd2264yjysva3mifoz9yzhwfl&st=un7a79tq&dl=1")
        r.raise_for_status()
        pkl_path.write_bytes(r.content)

db = FAISS.load_local(VECTORSTORE_PATH, embedding_model, allow_dangerous_deserialization=True)
client = OpenAI(api_key=OPENAI_API_KEY)

# === 1. Classify user state ===
def classify_user_input(user_input: str) -> dict:
    prompt = f"""
You are a spiritual AI assistant. Given the following user input, return a JSON object categorizing their:

- emotional state
- thematic focus
- relevant doctrinal concern (if any)

Respond ONLY in JSON format like:
{{
  "emotion": "anxiety",
  "theme": "trust",
  "doctrine": "sanctification"
}}

User input:
"{user_input}"
"""
    response = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.3,
    )
    return json.loads(response.choices[0].message.content)

# === 2. Retrieve best verse ===
def get_best_verse(query: str, k: int = 1):
    results = db.similarity_search(query, k=k)
    return results[0] if results else None

# === 3. Generate spiritual reflection ===
def generate_reflection(verse: str, tags: dict, user_input: str):
    prompt = f"""
You are a compassionate, theologically grounded Christian spiritual guide.

A user has shared the following concern:
"{user_input}"

They’ve been given this Bible verse:
"{verse}"

Write a brief spiritual reflection (4–6 sentences) that:
- Connects the verse to their emotional and spiritual situation
- Offers biblical encouragement
- Reflects on the relevant doctrine (“{tags.get('doctrine', 'Unknown')}”)

Speak with warmth, insight, and Christian conviction.
"""
    response = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.7,
    )
    return response.choices[0].message.content.strip()

# === 4. Format TheoBot-friendly output ===
def format_theobot_block(verse_ref: str, verse: str, reflection: str) -> str:
    return f"""📖 *Verse of the Day: {verse_ref}*\n“{verse}”\n\n🧠 *Reflection*: {reflection}"""

# === MAIN USAGE ===
if __name__ == "__main__":
    user_input = input("🗣️ What’s on your heart today?\n> ")

    # 1. Classify input
    classification = classify_user_input(user_input)
    print(f"\n🔎 Classified as: {classification}")

    # 2. Retrieve verse
    search_query = f"{classification['emotion']} {classification['theme']} {classification.get('doctrine', '')}"
    doc = get_best_verse(search_query)

    if not doc:
        print("❌ No verse found for that query.")
        exit()

    verse = doc.page_content
    tags = doc.metadata
    verse_ref = tags.get("reference", "Unknown Reference")

    # 3. Generate reflection
    reflection = generate_reflection(verse, tags, user_input)

    # 4. Display output
    final_block = format_theobot_block(verse_ref, verse, reflection)
    print("\n" + final_block)
