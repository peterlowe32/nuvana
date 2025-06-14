import json
import base64
import os
import requests

API_URL = "https://b23b-103-196-86-59.ngrok-free.app/sdapi/v1/txt2img"
PRESETS_FILE = "verse_image_metadatav2.json"
OUTPUT_FOLDER = "generated_images"
IMAGE_WIDTH = 1004
IMAGE_HEIGHT = 583

# Ensure output folder exists
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

# Utility to get a unique filename
def get_unique_filename(base_name, ext=".png"):
    counter = 1
    filename = f"{base_name}{ext}"
    while os.path.exists(os.path.join(OUTPUT_FOLDER, filename)):
        filename = f"{base_name}_{counter}{ext}"
        counter += 1
    return filename

# Load the preset prompts
with open(PRESETS_FILE, "r") as f:
    presets = json.load(f)

for preset in presets:
    theme = preset["theme"]
    style = preset["style"]
    prompt = f"{style} style, {theme} background with biblical symbolism"

    base_name = f"{theme}_{style}".replace(" ", "_").lower()
    unique_file_name = get_unique_filename(base_name)
    file_path = os.path.join(OUTPUT_FOLDER, unique_file_name)

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

        print(f"✅ Saved: {unique_file_name}")

    except Exception as e:
        print(f"❌ Error generating image for {theme} [{style}]: {e}")
