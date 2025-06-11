import requests
import json
import base64
import os

# Ensure the output folder exists
os.makedirs("generated_images", exist_ok=True)

# Load metadata list (array of objects)
with open("verse_image_metadata.json", "r") as f:
    metadata = json.load(f)

# Loop through each image definition
for entry in metadata:
    prompt = entry["prompt"]
    image_id = entry["image_id"]

    print(f"🔹 Generating image {image_id} with prompt: {prompt}")

    payload = {
        "prompt": prompt,
        "steps": 20,
        "width": 1024,
        "height": 576
    }

    try:
        response = requests.post(
            "https://329a12bccbb4c8c279.gradio.live/sdapi/v1/txt2img",  # Your public SD endpoint
            headers={"Content-Type": "application/json"},
            json=payload
        )
        response.raise_for_status()

        image_base64 = response.json()["images"][0]
        image_bytes = base64.b64decode(image_base64)

        with open(f"generated_images/{image_id}.png", "wb") as f:
            f.write(image_bytes)

        print(f"✅ Saved {image_id}.png")
    except Exception as e:
        print(f"❌ Failed to generate {image_id}: {e}")
