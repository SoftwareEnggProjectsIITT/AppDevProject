# LegalEase  

## 🌍 SDG Goal 16 — Peace, Justice and Strong Institutions  

### 📖 Overview  
LegalEase is a Flutter-based mobile application designed to promote awareness of constitutional laws and provide citizens with the latest policy information. Leveraging a Retrieval-Augmented Generation (RAG) pipeline, the app enables users to ask queries about laws while staying updated on policy changes.  

### 🎯 Objectives  
- Educate people about laws of the constitution.  
- Provide up-to-date information on policies and governance.  
- Encourage civic participation by making policy knowledge accessible to everyone.  
### 📂 Project Structure  

#### Frontend (`Coding/appDev/flutter/AppDevProject/frontend/lib`)  
```
├── firebase_options.dart
├── main.dart
├── models
│   ├── auth.dart
│   ├── chat.dart
│   ├── color_scheme.dart
│   ├── feed_entry.dart
│   ├── post_data.dart
│   └── tts.dart
├── providers
│   ├── bookmarks_provider.dart
│   ├── dark_mode_provider.dart
│   ├── notifiers.dart
│   └── post_categories.dart
├── screens
│   ├── all_chats.dart
│   ├── bookmarks_page.dart
│   ├── chat_screen.dart
│   ├── home_page.dart
│   ├── login.dart
│   └── post_page.dart
├── services
│   ├── get_reply.dart
│   ├── manage_messages.dart
│   ├── post_service.dart
│   └── reply_service.dart
├── widgets
│   ├── bookmark_button.dart
│   ├── bottom_navbar.dart
│   ├── conv_card.dart
│   ├── like_button.dart
│   ├── login_page_builder.dart
│   ├── main_drawer.dart
│   ├── message_box.dart
│   ├── new_chat.dart
│   ├── post_card.dart
│   ├── post_image.dart
│   ├── reply.dart
│   └── reply_loader.dart
└── widget_tree.dart
```
### ✨ Core Features  
- 🔑 User Verification with Google — Secure login for all users.  
- 🌓 Light & Dark Mode — Personalized user experience.  
- 🤖 Chatbot — Ask questions about laws and policies using RAG-powered responses.  
- 💬 Multiple Chats — Maintain separate conversations within the same chat window to ask different questions.  
- 📌 Bookmark — Save important queries or policies for quick access.  
- ❤ Like — Mark policies or law explanations you find useful.  
- 📰 Personalized Feed — Content recommendations based on user activity such as likes, bookmarks, and watch history.  
- 🎙 Speech-to-Text — Ask questions using your voice.  
- 🔊 Text-to-Speech — Listen to law explanations and policy answers.  

### 📱 Screens/Pages  
- [Login Page](images/login_page.jpg) — Secure Google authentication for users.  
- [Home Page](images/home_page.jpg) — Displays personalized feed and navigation to other features.  
- [Chatbot Page](images/chatbot_page.jpg) — Interact with the RAG-powered chatbot to ask queries about laws and policies.  
- [Detailed View Page](images/detailed_view.jpg) — View full details of policies, laws, or bookmarked content.   
- [Bookmark Page](images/bookmark_page.jpg) — Access saved queries and policy information for quick reference.  

### 🛠 Tech Stack  
- Frontend: Flutter  
- Middleware: FastAPI  
- Backend: Firebase, LangChain  
- CI/CD: GitHub  
- Deployment: Render  

---

### 📌 Contributions  
- Nillanjan: Added splash screen on first start, login screen, storing user messages and conversations, creating backup mechanisms in case of cold-start or backend data mismatch (directly calling LLM), and building the frontend for chatbot.  
- Sarang: Developed personalized feed for every user, integrated real-time news & posts on Firebase, prepared datasets for RAG chatbot, and handled model deployment.  
- Piyush: Designed explore page with interactive cards, color themes, day/night mode, implemented persistent bookmarks & likes storage for each user, and created a new table for every user in the database.  
- Prathamesh: Implemented RAG model logic, created vector embeddings of government data, experimented with multiple models/hyperparameters/query prompts, and optimized answer generation (selecting relevant PDFs, ensuring validity, and providing references).  
- Sabari: Built backend endpoints using FastAPI to handle chats and policy data, and integrated Firebase authentication.  

---

🚀 Building transparency and empowering citizens through technology with LegalEase.  
