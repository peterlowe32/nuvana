import pandas as pd
from langchain_openai import OpenAIEmbeddings
from langchain_community.vectorstores import FAISS
from langchain.docstore.document import Document
import os

# === FILE CONFIG ===
CSV_PATH = r"C:\Users\peter\Documents\AI\Christian_AI_MVP\resources\Bible_ASV\Bible_ASV_CSV.csv"  # Your file should have columns: book, chapter, verse, text

# === MAPPINGS ===

# Literary genre mapping
genre_map = {
    "Genesis": "Law", "Exodus": "Law", "Leviticus": "Law", "Numbers": "Law", "Deuteronomy": "Law",
    "Joshua": "History", "Judges": "History", "Ruth": "History", "1 Samuel": "History", "2 Samuel": "History",
    "1 Kings": "History", "2 Kings": "History", "1 Chronicles": "History", "2 Chronicles": "History",
    "Ezra": "History", "Nehemiah": "History", "Esther": "History",
    "Job": "Wisdom", "Psalms": "Wisdom", "Proverbs": "Wisdom", "Ecclesiastes": "Wisdom", "Song of Solomon": "Wisdom",
    "Isaiah": "Prophecy", "Jeremiah": "Prophecy", "Lamentations": "Prophecy", "Ezekiel": "Prophecy", "Daniel": "Prophecy",
    "Hosea": "Prophecy", "Joel": "Prophecy", "Amos": "Prophecy", "Obadiah": "Prophecy", "Jonah": "Prophecy",
    "Micah": "Prophecy", "Nahum": "Prophecy", "Habakkuk": "Prophecy", "Zephaniah": "Prophecy",
    "Haggai": "Prophecy", "Zechariah": "Prophecy", "Malachi": "Prophecy",
    "Matthew": "Gospel", "Mark": "Gospel", "Luke": "Gospel", "John": "Gospel",
    "Acts": "History",
    "Romans": "Epistle", "1 Corinthians": "Epistle", "2 Corinthians": "Epistle", "Galatians": "Epistle",
    "Ephesians": "Epistle", "Philippians": "Epistle", "Colossians": "Epistle", "1 Thessalonians": "Epistle",
    "2 Thessalonians": "Epistle", "1 Timothy": "Epistle", "2 Timothy": "Epistle", "Titus": "Epistle",
    "Philemon": "Epistle", "Hebrews": "Epistle", "James": "Epistle", "1 Peter": "Epistle", "2 Peter": "Epistle",
    "1 John": "Epistle", "2 John": "Epistle", "3 John": "Epistle", "Jude": "Epistle",
    "Revelation": "Apocalyptic"
}

# Thematic focus keywords
theme_keywords = {
    "faith": "Faith", "hope": "Hope", "love": "Love", "grace": "Grace", "mercy": "Mercy", "salvation": "Salvation",
    "truth": "Wisdom", "fear": "Fear", "peace": "Peace", "strength": "Perseverance", "sin": "Sin", "repent": "Repentance"
}

# Emotional state keywords (expandable)
emotion_keywords = {
    "anxious": "Anxiety", "afraid": "Fear", "lonely": "Loneliness", "weary": "Exhaustion",
    "shame": "Shame", "guilt": "Guilt", "joy": "Joy", "delight": "Joy", "troubled": "Distress"
}

# Doctrinal tags by rough heuristic (could eventually come from your database)
doctrine_keywords = {
    "justified": "Justification", "predestined": "Election", "spirit": "Pneumatology",
    "cross": "Christology", "church": "Ecclesiology", "resurrection": "Eschatology",
    "created": "Anthropology", "redeemed": "Soteriology"
}

# === HELPERS ===

def detect_tag(text, keyword_map, default="General"):
    for keyword, tag in keyword_map.items():
        if keyword.lower() in text.lower():
            return tag
    return default

# === LOAD VERSES ===
df = pd.read_csv(CSV_PATH)
df = df.dropna(subset=["text"])
df["reference"] = df["book"] + " " + df["chapter"].astype(str) + ":" + df["verse"].astype(str)

# === TAGGING ===
df["genre"] = df["book"].map(genre_map).fillna("General")
df["theme"] = df["text"].apply(lambda x: detect_tag(x, theme_keywords))
df["emotion"] = df["text"].apply(lambda x: detect_tag(x, emotion_keywords, default="Unknown"))
df["doctrine"] = df["text"].apply(lambda x: detect_tag(x, doctrine_keywords, default="Unknown"))

# === CREATE DOCUMENTS ===
documents = []
for _, row in df.iterrows():
    metadata = {
        "reference": row["reference"],
        "book": row["book"],
        "chapter": int(row["chapter"]),
        "verse": int(row["verse"]),
        "genre": row["genre"],
        "theme": row["theme"],
        "emotion": row["emotion"],
        "doctrine": row["doctrine"]
    }
    documents.append(Document(page_content=row["text"], metadata=metadata))

# === EMBED ===
embedding_model = OpenAIEmbeddings()
vectorstore = FAISS.from_documents(documents, embedding_model)

# === SAVE VECTORSTORE ===
VECTORSTORE_PATH = "bible_verse_embeddings"
if not os.path.exists(VECTORSTORE_PATH):
    os.makedirs(VECTORSTORE_PATH)

vectorstore.save_local(VECTORSTORE_PATH)
print(f"✅ Embedding complete. Saved to: {VECTORSTORE_PATH}")
