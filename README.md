# 📝 Flutter To-Do App

A simple **Flutter To-Do application** built with **BLoC state management** and **SQLite (sqflite)** for local storage.  
This project was created as part of a **Flutter Machine Test** to demonstrate app architecture, state management, and persistent storage.

---

## 🚀 Features
- **Splash Screen** → Shows app logo/name briefly.
- **Login Screen** → Hardcoded email & password validation (`ivory@gmail.com / password123`).
- **Home Screen (Dashboard)**
    - Displays a list of tasks.
    - Mark tasks as **Pending / Done** with a checkbox.
    - Delete tasks by swipe or delete button.
    - Tap task to edit.
- **Add/Edit Task Screen**
    - Create a new task (title + description).
    - Update existing tasks.
- **Fetched Todolist**
    - Fetched to do list from dummyjson/todos.
    - Using http package.
- **Persistent Storage**
    - Tasks are saved in **SQLite** (`sqflite` package).
    - Status (Pending/Done) is preserved even after restart.
- **State Management**
    - Powered by **flutter_bloc** (`Bloc`, `Events`, `States`).

---

## 🛠️ Tech Stack
- **Flutter** (Dart)
- **flutter_bloc** → State Management
- **equatable** → Value equality in BLoC
- **http** → Fetched todo list 
- **sqflite** → SQLite database
- **path** → To manage database path

---


## ▶️ How to Run
1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/flutter_todo_app.git
   cd flutter_todo_app
2. Install dependencies:
   ````
   flutter pub get
3. Run on emulator/device:
   ````
   flutter run 



## 🔑 Login Credentials
```
    Email: ivory@gmail.com
    Password: 12345678 
```

## 👨‍💻 Author
````   
Risala KM
