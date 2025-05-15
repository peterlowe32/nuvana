from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional
import os
import json

from generate_verse_with_reflection import (
    classify_user_input,
    get_best_verse,
    generate_reflection
)

# === SETUP ===
app = FastAPI()

# === INPUT SCHEMA ===
class VerseRequest(BaseModel):
    user_id: str
    message: str  # This is the emotional/spiritual check-in from the user

# === API ROUTE ===
@app.post("/verse")
def get_personalized_verse(request: VerseRequest):
    # 1. Use GPT to classify user input
    classification = classify_user_input(request.message)

    # 2. Use the classification to search FAISS index
    query = f"{classification['emotion']} {classification['theme']} {classification.get('doctrine', '')}"
    doc = get_best_verse(query)

    if not doc:
        return {"error": "No matching verse found."}

    verse_text = doc.page_content
    tags = doc.metadata
    verse_ref = tags.get("reference", "Unknown Reference")

    # 3. Generate the reflection
    reflection = generate_reflection(verse_text, tags, request.message)

    # 4. Return structured response
    return {
        "user_id": request.user_id,
        "reference": verse_ref,
        "verse": verse_text,
        "reflection": reflection,
        "tags": tags,
        "classification": classification
    }
