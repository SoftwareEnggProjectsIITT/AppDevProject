this backend is deployed on: https://appdevproject-39ac.onrender.com (base url)

📖 Chats API Documentation

Base URL prefix: /chats
All endpoints are grouped under the "Chats" tag.

1. Save a Chat

Endpoint:
POST /chats/save

Description:
Saves a single chat (question-answer pair) to Firebase for a specific user.

Request Body:
{
"user_id": "string", // ID of the user
"question": "string", // The question asked by the user
"answer": "string" // The answer to the question
}

Response (200 OK):
{
"status": "success",
"message": "Chat saved to Firebase",
"chat_id": "string" // Firebase document ID
}

2. Get All Chats

Endpoint:
GET /chats/{user_id}

Description:
Fetch all saved chats for a specific user.

Path Parameters:
Name Type Description
user_id string The user's unique ID.
Response (200 OK):
{
"user_id": "string",
"chats": [
{
"id": "string", // Chat document ID
"question": "string", // Saved question
"answer": "string" // Saved answer
}
]
}

3. Delete All Chats

Endpoint:
DELETE /chats/delete_all/{user_id}

Description:
Deletes all chats for a specific user.

Path Parameters:
Name Type Description
user_id string The user's unique ID.
Response (200 OK):
{
"status": "success",
"message": "Deleted X chats for user_id"
}

4. Delete a Single Chat

Endpoint:
DELETE /chats/delete_one/{user_id}/{chat_id}

Description:
Deletes a specific chat for a user by chat ID.

Path Parameters:
Name Type Description
user_id string The user's unique ID.
chat_id string The chat's document ID.
Response (200 OK):

If found:

{
"status": "success",
"message": "Deleted chat chat_id for user_id"
}

If not found:

{
"status": "error",
"message": "Chat chat_id not found for user_id"
}

5. Ask Constitution

Endpoint:
POST /chats/ask_constitution

Description:
Asks a legal/constitutional question using an RAG (Retrieval-Augmented Generation) model.

Query Parameter:
Name Type Required Description
query string Yes The user's question about the Constitution.
Response (200 OK):
{
"status": "success",
"message": "Model-generated answer"
}

Error Response:

{
"status": "error",
"message": "Error message here"
}

6. Get Feed

Endpoint:
GET /chats/feed/{user_id}

Description:
Generates a personalized feed for a user based on their chat history.

Path Parameters:
Name Type Description
user_id string The user's unique ID.
Response (200 OK):
{
"user_id": "string",
"feed": [ ... ] // Array of feed items
}
