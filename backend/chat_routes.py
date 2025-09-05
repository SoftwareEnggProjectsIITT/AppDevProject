from fastapi import APIRouter
from models import ChatRequest, ChatResponse, ChatListResponse, StatusResponse
from modules.model_1 import ask_question
from modules.generate_feed import generate_feed

router = APIRouter(prefix="/chats", tags=["Chats"])




@router.post("/ask_question", response_model=StatusResponse)
def ask_question_route(query: str, category:int):
    """
    Ask a question about the Constitution using the RAG model.
    """
    
    answer = ask_question(query, category)
    return {
        "status": "success",
        "message": answer
    }


@router.get("/feed/{user_id}")
def get_feed(user_id: str):
    feed = generate_feed(user_id)
    return {"user_id": user_id, "feed": feed}
