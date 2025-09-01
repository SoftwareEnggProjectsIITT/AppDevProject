from modules.generate_feed import generate_feed
from fastapi import FastAPI

app = FastAPI()

@app.get("/feed/{user_id}")
def get_feed(user_id: str):
    feed = generate_feed(user_id)
    return {"user_id": user_id, "feed": feed}
