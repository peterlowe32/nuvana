from fastapi import FastAPI, Query
from generate_verse_with_reflection import classify_user_input, get_best_verse, generate_reflection

app = FastAPI()

@app.get("/reflect")
def reflect(user_input: str = Query(..., description="What’s on your heart today?")):
    classification = classify_user_input(user_input)
    query = f"{classification['emotion']} {classification['theme']} {classification.get('doctrine', '')}"
    doc = get_best_verse(query)

    if not doc:
        return {"error": "No verse found."}

    verse = doc.page_content
    tags = doc.metadata
    reflection = generate_reflection(verse, tags, user_input)

    return {
        "reference": tags.get("reference", "Unknown"),
        "verse": verse,
        "reflection": reflection,
        "classification": classification
    }
