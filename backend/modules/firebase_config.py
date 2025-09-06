import firebase_admin
from firebase_admin import credentials, db
import base64
import json
import os

# Initialize only once when this file is imported
if not firebase_admin._apps:
    encoded = os.getenv("FIREBASE_SERVICE_KEY")
    key_dict = json.loads(base64.b64decode(encoded))
    cred = credentials.Certificate(key_dict)
    firebase_admin.initialize_app(cred, {
        "databaseURL": "https://se-app-dev-9e20f-default-rtdb.asia-southeast1.firebasedatabase.app/"
    })


def init_firebase():
    return db.reference('/posts/')


def get_users_ref():
    return db.reference('/users/')