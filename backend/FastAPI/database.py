import firebase_admin
from firebase_admin import credentials, firestore
from pathlib import Path


key_path = Path(__file__).resolve().parent.parent / "data" / "serviceAccountKey.json"

cred = credentials.Certificate(key_path)
firebase_admin.initialize_app(cred)

db = firestore.client()
