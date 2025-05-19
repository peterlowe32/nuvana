import pandas as pd
import os
from langchain.docstore.document import Document
from langchain_community.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings

# === CONFIG ===
CSV_PATH = "Bible_ASV_CSV.csv"  # Update if needed
SAVE_DIR = "bible_verse_embeddings"
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

# === Book to Genre Mapping ===
GENRE_MAP = {
    # Old Testament
    "Genesis": "Law", "Exodus": "Law", "Leviticus": "Law", "Numbers": "Law", "Deuteronomy": "Law",
    "Joshua": "History", "Judges": "History", "Ruth": "History",
    "1 Samuel": "History", "2 Samuel": "History", "1 Kings": "History", "2 Kings": "History",
    "1 Chronicles": "History", "2 Chronicles": "History", "Ezra": "History", "Nehemiah": "History", "Esther": "History",
    "Job": "Wisdom", "Psalms": "Wisdom", "Proverbs": "Wisdom", "Ecclesiastes": "Wisdom", "Song of Solomon": "Wisdom",
    "Isaiah": "Prophecy", "Jeremiah": "Prophecy", "Lamentations": "Prophecy", "Ezekiel": "Prophecy", "Daniel": "Prophecy",
    "Hosea": "Prophecy", "Joel": "Prophecy", "Amos": "Prophecy", "Obadiah": "Prophecy", "Jonah": "Prophecy",
    "Micah": "Prophecy", "Nahum": "Prophecy", "Habakkuk": "Prophecy", "Zephaniah": "Prophecy", "Haggai": "Prophecy",
    "Zechariah": "Prophecy", "Malachi": "Prophecy",

    # New Testament
    "Matthew": "Gospel", "Mark": "Gospel", "Luke": "Gospel", "John": "Gospel",
    "Acts": "History",
    "Romans": "Epistle", "1 Corinthians": "Epistle", "2 Corinthians": "Epistle", "Galatians": "Epistle",
    "Ephesians": "Epistle", "Philippians": "Epistle", "Colossians": "Epistle", "1 Thessalonians": "Epistle",
    "2 Thessalonians": "Epistle", "1 Timothy": "Epistle", "2 Timothy": "Epistle", "Titus": "Epistle",
    "Philemon": "Epistle", "Hebrews": "Epistle", "James": "Epistle", "1 Peter": "Epistle", "2 Peter": "Epistle",
    "1 John": "Epistle", "2 John": "Epistle", "3 John": "Epistle", "Jude": "Epistle",
    "Revelation": "Prophecy"
}

# === LOAD CSV ===
df = pd.read_csv(CSV_PATH)

# === Build LangChain documents ===
docs = []
for _, row in df.iterrows():
    book = row['book']
    genre = GENRE_MAP.get(book, "General")
    metadata = {
        "reference": f"{book} {row['chapter']}:{row['verse']}",
        "book": book,
        "chapter": row['chapter'],
        "verse": row['verse'],
        "genre": genre,
        "theme": "General",
        "emotion": "Unknown",
        "doctrine": "Unknown"
    }
    docs.append(Document(page_content=row['text'], metadata=metadata))

# === Embed and save vector store ===
embedding_model = OpenAIEmbeddings(openai_api_key=OPENAI_API_KEY)
vectorstore = FAISS.from_documents(docs, embedding_model)
vectorstore.save_local(SAVE_DIR)

print("✅ Bible verses embedded and saved with full genre mapping.")
