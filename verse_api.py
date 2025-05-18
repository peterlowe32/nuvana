from fastapi import FastAPI, Request, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from generate_verse_with_reflection import classify_user_input, get_best_verse, generate_reflection
from datetime import datetime
import os
import csv

app = FastAPI()

# === Enable CORS ===
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Replace with specific frontend URL for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# === Config ===
NUVANA_API_KEY = os.getenv("NUVANA_API_KEY", "test-key")
LOG_DIR = "logs"
REFLECTION_LOG = os.path.join(LOG_DIR, "reflections.csv")
FEEDBACK_LOG = os.path.join(LOG_DIR, "feedback.csv")

# Ensure log directory exists
os.makedirs(LOG_DIR, exist_ok=True)

# === Helpers ===
def log_reflection(user_input, classification, tags, verse, reflection, user_id="anonymous"):
    with open(REFLECTION_LOG, mode='a', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow([
            datetime.utcnow().isoformat(),
            user_id,
            user_input,
            classification.get("emotion"),
            classification.get("theme"),
            classification.get("doctrine"),
            tags.get("reference"),
            verse,
            reflection
        ])

def log_feedback(user_id, reference, helpful: bool):
    with open(FEEDBACK_LOG, mode='a', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow([
            datetime.utcnow().isoformat(),
            user_id,
            reference,
            "helpful" if helpful else "not_helpful"
        ])

# === Models ===
class VerseRequest(BaseModel):
    user_id: str
    message: str

class FeedbackRequest(BaseModel):
    user_id: str
    reference: str
    helpful: bool

# === GET /reflect ===
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

    log_reflection(user_input, classification, tags, verse, reflection)

    return {
        "reference": tags.get("reference", "Unknown"),
        "verse": verse,
        "reflection": reflection,
        "classification": classification
    }

# === POST /verse (secure API) ===
@app.post("/verse")
async def get_daily_verse(req: VerseRequest, request: Request):
    auth_header = request.headers.get("Authorization")
    if auth_header != f"Bearer {NUVANA_API_KEY}":
        raise HTTPException(status_code=401, detail="Invalid or missing API key.")

    classification = classify_user_input(req.message)
    query = f"{classification['emotion']} {classification['theme']} {classification.get('doctrine', '')}"
    doc = get_best_verse(query)

    if not doc:
        raise HTTPException(status_code=404, detail="No verse found.")

    verse = doc.page_content
    tags = doc.metadata
    verse_ref = tags.get("reference", "Unknown Reference")
    reflection = generate_reflection(verse, tags, req.message)

    log_reflection(req.message, classification, tags, verse, reflection, req.user_id)

    return {
        "user_id": req.user_id,
        "reference": verse_ref,
        "verse": verse,
        "reflection": reflection,
        "tags": tags,
        "classification": classification
    }

# === POST /feedback ===
@app.post("/feedback")
async def feedback(feedback: FeedbackRequest):
    log_feedback(feedback.user_id, feedback.reference, feedback.helpful)
    return {"message": "Feedback recorded successfully"}

# === GET /test ===
@app.get("/test")
def test_reflect():
    return reflect(user_input="I'm feeling discouraged and tired")

# === GET / (root health check) ===
@app.get("/")
def root():
    return {"message": "Nuvana Reflection API is running."}
