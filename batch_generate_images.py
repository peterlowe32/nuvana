import json
import os
import base64
import requests

# Load metadata
with open("verse_image_metadata.json", "r") as f:
    metadata = json.load(f)

# Output directory
output_dir = "generated_images"
os.makedirs(output_dir, exist_ok=True)

# RunPod API endpoint
endpoint = " https://3128d98fa8a9e038c3.gradio.live/sdapi/txt2img"
headers = {"Content-Type": "application/json"}

# Generate images
for item in metadata:
    prompt = f"{item['style']} style, {item['prompt']}"
    image_id = item["image_id"]
    print(f"🔹 Generating image {image_id} with prompt: {prompt}")

    payload = {
        "prompt": prompt,
        "steps": 25,
        "width": 512,
        "height": 320,
        "sampler_index": "Euler a"
    }

    try:
        response = requests.post(endpoint, headers=headers, json=payload)
        response.raise_for_status()
        image_data = response.json()["images"][0]
        image_bytes = base64.b64decode(image_data)

        with open(os.path.join(output_dir, f"{image_id}.png"), "wb") as img_file:
            img_file.write(image_bytes)

    except Exception as e:
        print(f"❌ Failed to generate image {image_id}: {e}")
