import firebase_admin
from firebase_admin import credentials, db
from pathlib import Path
import json
import os

# Initialize only once when this file is imported
if not firebase_admin._apps:
    service_account_info = json.loads(os.environ["FIREBASE_SERVICE_KEY"])
    cred = credentials.Certificate(service_account_info)
    firebase_admin.initialize_app(cred, {
        "databaseURL": "https://se-app-dev-9e20f-default-rtdb.asia-southeast1.firebasedatabase.app/"
    })


def init_firebase():
    return db.reference('/posts/')


def get_users_ref():
    return db.reference('/users/')