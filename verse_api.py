from fastapi import FastAPI, Request, HTTPException, Query
from pydantic import BaseModel
from generate_verse_with_reflection import classify_user_input, get_best_verse, generate_reflection
import os

app = FastAPI()

# Load API key from Render or local env
NUVANA_API_KEY = os.getenv("NUVANA_API_KEY", "test-key")

# === GET /reflect for testing in browser ===
@app.get("/reflect")
def reflect(user_input: str = Query(..., description="Bible verse or emotional topic")):
    classification = classify_user_input(user_input)
    query = f"{classification['emotion']} {classification['theme']} {classification.get('doctrine', '')}"
    doc = get_best_verse(query)

    if not doc:
        raise HTTPException(status_code=404, detail="No verse found.")

    verse = doc.page_content
    tags = doc.metadata
    reflection = generate_reflection(verse, tags, user_input)

    return {
        "reference": tags.get("reference", "Unknown"),
        "verse": verse,
        "reflection": reflection,
        "classification": classification
    }

# === POST /verse for production use ===
class VerseRequest(BaseModel):
    user_id: str
    message: str

@app.post("/verse")
async def get_daily_verse(req: VerseRequest, request: Request):
    # Simple API key header check
    auth_header = request.headers.get("Authorization")
    if auth_header != f"Bearer {NUVANA_API_KEY}":
        raise HTTPException(status_code=401, detail="Invalid or missing API key.")

    classification = classify_user_input(req.message)
    search_query = f"{classification['emotion']} {classification['theme']} {classification.get('doctrine', '')}"
    doc = get_best_verse(search_query)

    if not doc:
        raise HTTPException(status_code=404, detail="No verse found for that topic.")

    verse = doc.page_content
    tags = doc.metadata
    verse_ref = tags.get("reference", "Unknown Reference")
    reflection = generate_reflection(verse, tags, req.message)

    return {
        "user_id": req.user_id,
        "reference": verse_ref,
        "verse": verse,
        "reflection": reflection,
        "tags": tags,
        "classification": classification
    }
