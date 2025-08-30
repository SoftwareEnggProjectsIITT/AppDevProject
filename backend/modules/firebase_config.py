import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
from pathlib import Path


#return root reference of the firebase database upon verifying the credentials for admin
def init_firebase():
    key_path = Path(__file__).resolve().parent.parent/"data"/"serviceAccountKey.json"
    cred = credentials.Certificate(key_path)

    firebase_admin.initialize_app(cred, {
        "databaseURL": "https://se-app-dev-9e20f-default-rtdb.asia-southeast1.firebasedatabase.app/"
    })

    return db.reference('/posts/')