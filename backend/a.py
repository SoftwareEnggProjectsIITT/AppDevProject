import base64

# Path to your Firebase service account key
file_path = "serviceAccountKey.json"

with open('key.txt', "rb") as f:
    encoded = base64.b64encode(f.read()).decode("utf-8")

print(encoded)
