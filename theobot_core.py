# theobot_core.py
import os
import json
import requests
from pathlib import Path
from langchain_community.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings
from openai import OpenAI

# === CONFIG ===
VECTORSTORE_PATH = "bible_verse_embeddings"
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

# === SETUP ===
embedding_model = OpenAIEmbeddings(openai_api_key=OPENAI_API_KEY)
db = FAISS.load_local(VECTORSTORE_PATH, embedding_model)
client = OpenAI(api_key=OPENAI_API_KEY)

# === CORE FUNCTIONS ===
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

def get_best_verse(query: str, k: int = 1):
    results = db.similarity_search(query, k=k)
    return results[0] if results else None

def generate_reflection(verse: str, tags: dict, user_input: str, mode="pastoral"):
    base_prompt = {
        "pastoral": f"""
You are a compassionate, theologically grounded Christian spiritual guide.

A user has shared the following concern:
"{user_input}"

They’ve been given this Bible verse:
"{verse}"

Write a brief spiritual reflection (3–5 sentences) that:
- Connects the verse to their emotional and spiritual situation
- Offers biblical encouragement
- Reflects on the relevant doctrine (“{tags.get('doctrine', 'Unknown')}”)

Speak with warmth, insight, and Christian conviction.
""",
        "conversational": f"""
You’re a relatable Christian friend giving heartfelt encouragement in under 5 sentences.

Concern: "{user_input}"
Verse: "{verse}"
""",
        "theological": f"""
You are a theologian writing a concise but rich analysis of this verse in light of someone's emotional concern.

Concern: "{user_input}"
Verse: "{verse}"
"""
    }

    prompt = base_prompt.get(mode, base_prompt["pastoral"])
    response = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.7,
    )
    return response.choices[0].message.content.strip()
