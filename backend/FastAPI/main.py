from fastapi import FastAPI
from routes import chat_routes

app = FastAPI(title="Chatbot Firebase API")

app.include_router(chat_routes.router)


@app.get("/")
def root():
    return {"message": "Welcome to Chatbot API with Firebase"}
