from pydantic import BaseModel
from typing import List, Optional


class ChatRequest(BaseModel):
    user_id: str
    question: str
    answer: str


class ChatResponse(BaseModel):
    chat_id: str
    question: str
    answer: str


class ChatListResponse(BaseModel):
    user_id: str
    chats: List[ChatResponse]


class StatusResponse(BaseModel):
    status: str
    message: str
    chat_id: Optional[str] = None
