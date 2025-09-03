from fastapi import APIRouter
from database import db
from models import ChatRequest, ChatResponse, ChatListResponse, StatusResponse
from modules.model_1 import ask_constitution
from modules.generate_feed import generate_feed

router = APIRouter(prefix="/chats", tags=["Chats"])


@router.post("/save", response_model=StatusResponse)
def save_chat(chat: ChatRequest):
    chat_ref = (
        db.collection("chats").document(chat.user_id).collection("messages").document()
    )
    chat_ref.set({"question": chat.question, "answer": chat.answer})
    return {
        "status": "success",
        "message": "Chat saved to Firebase",
        "chat_id": chat_ref.id,
    }


@router.get("/{user_id}", response_model=ChatListResponse)
def get_chats(user_id: str):
    messages_ref = db.collection("chats").document(user_id).collection("messages")
    docs = messages_ref.stream()
    chats = [{"id": doc.id, **doc.to_dict()} for doc in docs]
    return {"user_id": user_id, "chats": chats}


@router.delete("/delete_all/{user_id}", response_model=StatusResponse)
def delete_all_chats(user_id: str):
    messages_ref = db.collection("chats").document(user_id).collection("messages")
    docs = messages_ref.stream()
    deleted_count = 0
    for doc in docs:
        doc.reference.delete()
        deleted_count += 1
    return {
        "status": "success",
        "message": f"Deleted {deleted_count} chats for {user_id}",
    }


@router.delete("/delete_one/{user_id}/{chat_id}", response_model=StatusResponse)
def delete_single_chat(user_id: str, chat_id: str):
    chat_ref = (
        db.collection("chats")
        .document(user_id)
        .collection("messages")
        .document(chat_id)
    )
    if chat_ref.get().exists:
        chat_ref.delete()
        return {"status": "success", "message": f"Deleted chat {chat_id} for {user_id}"}
    return {"status": "error", "message": f"Chat {chat_id} not found for {user_id}"}


@router.post("/ask_constitution", response_model=StatusResponse)
def ask_constitution_route(query: str):
    """
    Ask a question about the Constitution using the RAG model.
    """
    try:
        answer = ask_constitution(query)
        return {
            "status": "success",
            "message": answer
        }
    except Exception as e:
        return {
            "status": "error",
            "message": str(e)
        }


@router.get("/feed/{user_id}")
def get_feed(user_id: str):
    feed = generate_feed(user_id)
    return {"user_id": user_id, "feed": feed}
