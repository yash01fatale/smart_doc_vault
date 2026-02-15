# 📄 Smart Document Vault — AI Powered Document Management System

Smart Document Vault is a full-stack AI-powered application designed to help users securely manage personal and business documents, track expiry dates, receive smart notifications, and get guided renewal assistance using intelligent automation.

The platform combines a modern Flutter frontend, Node.js backend, and an AI engine powered by FastAPI, LangChain, ChromaDB, and Ollama to deliver a smart document management experience.

---

## 🌟 Overview

Managing important documents like Aadhaar, PAN, Passport, Driving License, and Business Certificates can be stressful due to expiry tracking, compliance requirements, and renewal procedures.

Smart Document Vault simplifies this by providing:

✅ Secure document management
✅ AI-powered assistance
✅ Expiry tracking & reminders
✅ Renewal guidance
✅ Intelligent search
✅ Role-based dashboards

---

## 🚀 Key Features

### 🔐 Authentication & Security

* Login & Signup with validation
* Role-based access (Personal / Business)
* OTP verification flow
* Secure token storage
* Session management

---

### 📊 Smart Dashboard

* Modern overview UI
* Quick actions navigation
* Expiry insights
* Recent documents preview
* Notification access

---

### 📂 Document Management

* Add and manage documents
* Category-based organization
* Expiry status indicators
* Document search and filters
* Document detail screen
* Renewal guide integration

---

### 🤖 AI Assistant

* Chat-style interface
* Document insights
* Compliance guidance
* Context-aware responses
* Vector search powered answers

---

### 🔔 Notifications System

* Expiry alerts
* Upload confirmations
* AI insights
* Notification management
* Direct navigation to document

---

### 📘 Renewal Guidance

* Step-by-step instructions
* Required documents checklist
* Estimated processing time
* Fee estimation
* Multi-document support

---

### 👤 Profile & Settings

* Profile management
* Editable user info
* Role switching
* Security settings
* Preferences

---

## 🧠 AI Capabilities

✔ Vector database search using ChromaDB
✔ Context-aware responses with LangChain
✔ Local LLM processing using Ollama
✔ Knowledge-based document guidance
✔ Smart prompt system

---

## 🏗️ System Architecture

```
Flutter UI → Node.js API → FastAPI AI Engine → Ollama LLM → ChromaDB
                         ↓
                      MongoDB
```

---

## 🧰 Tech Stack

### 🎨 Frontend

* Flutter (Dart)
* Material 3 UI
* Provider State Management

### 🟢 Backend API

* Node.js
* Express.js
* MongoDB
* JWT Authentication

### 🧠 AI Backend

* FastAPI
* LangChain
* ChromaDB
* Ollama (Llama3)
* Vector embeddings

### 🗄 Database

* MongoDB
* Local Vector DB

---

## 📁 Project Structure

```
smart_doc_vault/
│
├── backend/              → Node.js API
├── backend_python/       → FastAPI AI engine
├── lib/                  → Flutter UI
├── chroma/               → Vector database (ignored)
├── package.json
├── .gitignore
└── README.md
```

---

## ⚙️ Setup Guide

### 🔧 Prerequisites

Install the following:

* Node.js
* Flutter SDK
* Python 3.10+
* MongoDB
* Ollama

---

### 📦 Clone Repository

```bash
git clone <repo-url>
cd smart_doc_vault
```

---

### 🟢 Install Backend Dependencies

```bash
cd backend
npm install
cd ..
```

---

### 🧠 Setup AI Backend

```bash
cd backend_python
python -m venv venv
.\venv\Scripts\activate
pip install -r requirements.txt
cd ..
```

---

### 🎨 Install Flutter Dependencies

```bash
flutter pub get
```

---

## ▶️ Run Entire Project

```bash
npm run dev
```

Starts:

* Node API → http://localhost:8000
* AI Backend → http://127.0.0.1:8001
* Flutter → Chrome

---

## 🌐 API Docs

AI API Swagger:

```
http://127.0.0.1:8001/docs
```

---

## 🧪 Testing Status

✔ UI tested
✔ Navigation tested
✔ Backend APIs tested
✔ AI integration tested
✔ Vector database loading tested

---

## 🎯 Use Cases

✔ Personal document management
✔ Business compliance tracking
✔ Expiry reminder system
✔ AI document assistant
✔ Hackathon prototype
✔ Startup MVP

---

## 🔮 Future Enhancements

* OCR document scanning
* Cloud deployment
* Push notifications
* Email reminders
* Document analytics
* Hybrid search
* Mobile builds
* Encryption layer
* Biometric authentication

---

## 👥 Team Collaboration

Developed collaboratively by:

👨‍💻 **Yash Fatale** — Full Stack & AI Integration
👨‍💻 **Abhishek Gilbile** — AI Backend & Vector Search
👨‍💻 **Karan Kundale** — Backend & System Design

---

## 🏆 Project Highlights

⭐ Full-stack AI architecture
⭐ Local LLM integration
⭐ Vector database search
⭐ Microservices design
⭐ Production-style setup
⭐ Real-world use case

---

## 📊 Demo Flow

1️⃣ Upload document
2️⃣ Show expiry detection
3️⃣ Ask AI question
4️⃣ View renewal guide
5️⃣ Show dashboard insights

---

## 🤝 Contribution

Contributions are welcome.

Steps:

1. Fork repository
2. Create feature branch
3. Commit changes
4. Open Pull Request

---

## 📌 Project Status

🚧 Active Development

Frontend completed
Backend stable
AI integration ongoing

---

## 📜 License

This project is developed for educational, hackathon, and prototype purposes.

---

## 💡 Inspiration

Built to simplify document compliance and demonstrate real-world AI integration using modern full-stack architecture.

---

⭐ If you like this project, consider giving it a star!
