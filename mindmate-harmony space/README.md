# MindMate Harmony Space 

A compassionate AI-powered mental wellbeing companion built with Jaclang OSP graphs, byLLM agents, and Jac-Client for the frontend.

## Features

- **Mood Tracking**: Log emotions with intensity, triggers, and activities
-  **Pattern Analysis**: AI-powered detection of emotional trends via graph walkers
- **Smart Suggestions**: Personalized coping strategies from byLLM agents
- **Secure Journaling**: Private journal entries with emotion tracking
- **Visual Insights**: Interactive charts and timelines
- **Wellness Tools**: Breathing exercises and mindfulness prompts

## Tech Stack

- **Backend**: Jaclang with OSP graphs, byLLM agents, FastAPI
- **Frontend**: Jac-Client (Jaclang for web UI)
- **AI**: Anthropic Claude via byLLM
- **Styling**: Tailwind CSS via CDN

## Prerequisites

- Python 3.10+
- Jaclang (`pip install jaclang`)
- Anthropic API Key

## Quick Start

### 1. Install Jaclang
```bash
pip install jaclang
pip install jaclang[web]  # Includes Jac-Client support
```

### 2. Setup Backend
```bash
cd backend

# Create .env file
cat > .env << EOF
ANTHROPIC_API_KEY=your_api_key_here
CORS_ORIGINS=http://localhost:8080
EOF

# Run backend server
jac run main.jac
```

Backend runs at `http://localhost:8000`

### 3. Setup Frontend (Jac-Client)
```bash
cd frontend

# Run Jac-Client dev server
jac serve app.jac --port 8080
```

Frontend runs at `http://localhost:8080`

## Architecture

### OSP Graph (Backend)
Root Node
├── Emotion Nodes → happiness, sadness, anxiety, etc.
├── Trigger Nodes → work, social, health, finance
├── Activity Nodes → exercise, meditation, reading
└── MoodEntry Nodes
├──[influences]→ Emotion
├──[triggered_by]→ Trigger
└──[helped_by]→ Activity

### Jac-Client (Frontend)
- Declarative UI components in Jaclang
- Direct `Spawn()` calls to backend walkers
- Reactive state management
- Component-based architecture

### Walkers
- **MoodLogger**: Logs mood entries, updates graph
- **PatternAnalyzer**: Detects emotional patterns
- **SuggestionEngine**: Generates activity recommendations
- **GenerateAISuggestions**: byLLM-powered empathetic responses

## Development

### Run Backend
```bash
cd backend
jac run main.jac
```

### Run Frontend
```bash
cd frontend
jac serve app.jac --port 8080
```

### API Documentation
Visit `http://localhost:8000/docs`

## Key Concepts

### Spawn() in Jac-Client
```jac
# Direct walker invocation from frontend
result = spawn backend_url walker MoodLogger(
    emotion_id=emotion,
    intensity=intensity,
    user_id=user_id
);
```

### byLLM Integration
```jac
can generate_response(...) -> dict by llm(
    method="Reason",
    system=system_prompt,
    incl_info=(emotion, patterns)
);
```

### Component Structure
```jac
node MoodLoggerComponent {
    has emotions: list;
    has selected_emotion: str;
    
    can render -> html {
        # Component logic and HTML generation
    }
}
```

## Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push and open Pull Request

## License

MIT License

## Disclaimer


MindMate is a wellbeing tool, not a replacement for professional mental health care.
