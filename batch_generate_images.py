import json
import base64
import os
import requests

API_URL = "https://796cc7eb6dfd9218ed.gradio.live/sdapi/v1/txt2img"
PRESETS_FILE = "verse_image_metadata.json"
OUTPUT_FOLDER = "generated_images"
IMAGE_WIDTH = 1004
IMAGE_HEIGHT = 583

# Ensure output folder exists
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

# Load the preset prompts
with open(PRESETS_FILE, "r") as f:
    presets = json.load(f)

for preset in presets:
    theme = preset["theme"]
    style = preset["style"]
    prompt = f"{style} style, {theme} background with biblical symbolism"

    file_name = f"{theme}_{style}.png".replace(" ", "_").lower()
    file_path = os.path.join(OUTPUT_FOLDER, file_name)

    if os.path.exists(file_path):
        print(f"✅ Already exists: {file_name} — skipping.")
        continue

    print(f"🔹 Generating image for: {theme} [{style}]")

    try:
        response = requests.post(
            API_URL,
            headers={"Content-Type": "application/json"},
            json={
                "prompt": prompt,
                "steps": 25,
                "width": IMAGE_WIDTH,
                "height": IMAGE_HEIGHT,
                "sampler_index": "Euler a"
            },
            timeout=60
        )
        response.raise_for_status()

        image_data = response.json()["images"][0]
        image_bytes = base64.b64decode(image_data)

        with open(file_path, "wb") as f:
            f.write(image_bytes)

        print(f"✅ Saved: {file_name}")

    except Exception as e:
        print(f"❌ Error generating image for {theme} [{style}]: {e}")
