from fastapi import FastAPI, Request, HTTPException
from pydantic import BaseModel
from generate_verse_with_reflection import classify_user_input, get_best_verse, generate_reflection
import os

app = FastAPI()

# Load API key from Render or local env
NUVANA_API_KEY = os.getenv("NUVANA_API_KEY", "test-key")

class VerseRequest(BaseModel):
    user_id: str
    message: str

@app.post("/verse")
async def get_daily_verse(req: VerseRequest, request: Request):
    # Simple API key header check
    auth_header = request.headers.get("Authorization")
    if auth_header != f"Bearer {NUVANA_API_KEY}":
        raise HTTPException(status_code=401, detail="Invalid or missing API key.")

    # 1. Classify user input
    classification = classify_user_input(req.message)

    # 2. Search vector DB
    search_query = f"{classification['emotion']} {classification['theme']} {classification.get('doctrine', '')}"
    doc = get_best_verse(search_query)

    if not doc:
        raise HTTPException(status_code=404, detail="No verse found for that topic.")

    verse = doc.page_content
    tags = doc.metadata
    verse_ref = tags.get("reference", "Unknown Reference")

    # 3. Generate reflection
    reflection = generate_reflection(verse, tags, req.message)

    # 4. Return full response
    return {
        "user_id": req.user_id,
        "reference": verse_ref,
        "verse": verse,
        "reflection": reflection,
        "tags": tags,
        "classification": classification
    }
