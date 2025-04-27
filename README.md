# Smart Tasker

A next-generation task manager with built-in AI capabilities.

## Features

### Core Task Features
- ✅ Add, edit, delete tasks
- 📅 Set deadlines
- 📍 Assign priorities (Low/Medium/High)
- 🏷️ Tagging (e.g., "Work", "Home", "Urgent")
- 📤 Cloud Sync (MongoDB backend)
- 🔔 Notifications (due dates)

### AI Features (LLM-Driven)
- 💡 **Prioritization Advice**: AI analyzes your tasks and suggests which ones to focus on based on deadlines, tags, and priorities.
- 🕒 **Time Estimate Suggestions**: AI suggests time estimates for tasks based on the description and similar past tasks.
- ✍️ **Task Rewriting**: AI improves vague task descriptions to make them more specific and actionable.

## Tech Stack

### Backend
- Node.js + Express
- MongoDB for task data
- Gemini AI integration for AI features

### Frontend
- Flutter for cross-platform mobile app
- Provider for state management
- Material Design 3 UI

## Project Structure

### Backend
```
backend/
├── config/         # Database configuration
├── controllers/    # Request handlers
├── middleware/     # Error handling middleware
├── models/         # MongoDB schemas
├── routes/         # API routes
└── utils/          # Utility functions (Gemini AI)
```

### Frontend
```
frontend/
├── lib/
│   ├── config/     # API configuration
│   ├── models/     # Data models
│   ├── providers/  # State management
│   ├── screens/    # UI screens
│   ├── services/   # API services
│   ├── theme/      # App theme
│   └── widgets/    # Reusable UI components
└── test/           # Unit tests
```

## Getting Started

### Prerequisites
- Node.js (v14+)
- MongoDB
- Flutter (latest stable)
- Gemini API key

### Backend Setup
1. Navigate to the backend directory:
   ```
   cd backend
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Create a `.env` file with the following variables:
   ```
   PORT=5000
   MONGO_URI=mongodb://localhost:27017/smart_tasker
   GEMINI_API_KEY=your_gemini_api_key_here
   GEMINI_API_URL=https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent
   ```

4. Start the server:
   ```
   npm run dev
   ```

### Frontend Setup
1. Navigate to the frontend directory:
   ```
   cd frontend
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Update the API endpoint in `lib/config/api_config.dart` if needed.

4. Run the app:
   ```
   flutter run
   ```

## API Endpoints

### Tasks
- `GET /api/tasks` - Get all tasks
- `POST /api/tasks` - Create a new task
- `GET /api/tasks/:id` - Get a single task
- `PUT /api/tasks/:id` - Update a task
- `DELETE /api/tasks/:id` - Delete a task
- `PUT /api/tasks/:id/toggle` - Toggle task completion

### AI Features
- `GET /api/ai/prioritize` - Get AI prioritization advice
- `POST /api/ai/suggest-time` - Get AI time estimate suggestion
- `POST /api/ai/rewrite-task` - Get AI task rewrite suggestion

## License
MIT
