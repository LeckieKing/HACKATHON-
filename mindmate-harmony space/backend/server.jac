"""FastAPI server for MindMate backend with Jac-Client support"""

import:py from fastapi, FastAPI, HTTPException;
import:py from fastapi.middleware.cors, CORSMiddleware;
import:py from pydantic, BaseModel;
import:py from typing, List;
import:py from dotenv, load_dotenv;
import:py import os;

import:jac from walkers.mood_logger, MoodLogger;
import:jac from walkers.pattern_analyzer, PatternAnalyzer;
import:jac from walkers.suggestion_engine, SuggestionEngine;
import:jac from agents.empathy_agent, GenerateAISuggestions;

load_dotenv();

glob app = FastAPI(
    title="MindMate Harmony API",
    description="AI-powered mental wellbeing companion with Jac-Client support",
    version="1.0.0"
);

# Enable CORS for Jac-Client
allowed_origins = os.getenv("CORS_ORIGINS", "http://localhost:8080").split(",");

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
);

# Request Models
class MoodLogRequest(BaseModel) {
    emotion_id: str;
    intensity: int;
    triggers: List[str] = [];
    activities: List[str] = [];
    journal_text: str = "";
    user_id: str;
}

# Walker Spawn Endpoint - Used by Jac-Client
@app.post("/api/walker/spawn")
can spawn_walker(walker_name: str, params: dict) {
    """
    Universal walker spawning endpoint for Jac-Client
    Allows frontend to spawn any walker with parameters
    """
    try {
        if walker_name == "MoodLogger" {
            walker = MoodLogger(**params);
        } elif walker_name == "PatternAnalyzer" {
            walker = PatternAnalyzer(**params);
        } elif walker_name == "SuggestionEngine" {
            walker = SuggestionEngine(**params);
        } elif walker_name == "GenerateAISuggestions" {
            walker = GenerateAISuggestions(**params);
        } else {
            raise HTTPException(status_code=400, detail=f"Unknown walker: {walker_name}");
        }
        
        result = spawn root walker walker;
        return {"success": True, "data": result};
    } except Exception as e {
        raise HTTPException(status_code=500, detail=str(e));
    }
}

# Traditional REST endpoints (backward compatible)
@app.post("/api/mood/log")
can log_mood(request: MoodLogRequest) {
    try {
        walker = MoodLogger(
            emotion_id=request.emotion_id,
            intensity=request.intensity,
            triggers=request.triggers,
            activities=request.activities,
            journal_text=request.journal_text,
            user_id=request.user_id
        );
        result = spawn root walker walker;
        return result[0] if len(result) > 0 else {"success": False};
    } except Exception as e {
        raise HTTPException(status_code=500, detail=str(e));
    }
}

@app.get("/api/patterns/{user_id}")
can get_patterns(user_id: str, time_range: int = 7) {
    try {
        walker = PatternAnalyzer(user_id=user_id, time_range=time_range);
        result = spawn root walker walker;
        return result[0] if len(result) > 0 else {"patterns": {}};
    } except Exception as e {
        raise HTTPException(status_code=500, detail=str(e));
    }
}

@app.post("/api/suggestions/ai")
can get_ai_suggestions(request: MoodLogRequest) {
    try {
        walker = GenerateAISuggestions(
            emotion_id=request.emotion_id,
            intensity=request.intensity,
            user_id=request.user_id,
            triggers=request.triggers,
            journal_text=request.journal_text
        );
        result = spawn root walker walker;
        return result[0] if len(result) > 0 else {};
    } except Exception as e {
        raise HTTPException(status_code=500, detail=str(e));
    }
}

@app.get("/api/emotions")
can get_emotions() {
    emotions = [
        {"id": "happy", "label": "Happy", "icon": "😊", "color": "#FFD700", "sentiment": "positive"},
        {"id": "calm", "label": "Calm", "icon": "😌", "color": "#87CEEB", "sentiment": "positive"},
        {"id": "anxious", "label": "Anxious", "icon": "😰", "color": "#DDA0DD", "sentiment": "negative"},
        {"id": "sad", "label": "Sad", "icon": "😢", "color": "#4682B4", "sentiment": "negative"},
        {"id": "angry", "label": "Angry", "icon": "😠", "color": "#DC143C", "sentiment": "negative"},
        {"id": "neutral", "label": "Neutral", "icon": "😐", "color": "#A9A9A9", "sentiment": "neutral"},
        {"id": "energetic", "label": "Energetic", "icon": "⚡", "color": "#FF6347", "sentiment": "positive"},
        {"id": "excited", "label": "Excited", "icon": "🤩", "color": "#FF69B4", "sentiment": "positive"}
    ];
    return {"emotions": emotions};
}

@app.get("/api/triggers")
can get_triggers() {
    triggers = [
        {"id": "work", "label": "Work Stress", "icon": "💼"},
        {"id": "social", "label": "Social", "icon": "👥"},
        {"id": "family", "label": "Family", "icon": "👨‍👩‍👧"},
        {"id": "health", "label": "Health", "icon": "🏥"},
        {"id": "finance", "label": "Finance", "icon": "💰"},
        {"id": "sleep", "label": "Sleep", "icon": "😴"}
    ];
    return {"triggers": triggers};
}

@app.get("/api/activities")
can get_activities() {
    activities = [
        {"id": "exercise", "label": "Exercise", "icon": "🏃"},
        {"id": "meditation", "label": "Meditation", "icon": "🧘"},
        {"id": "reading", "label": "Reading", "icon": "📚"},
        {"id": "music", "label": "Music", "icon": "🎵"},
        {"id": "socializing", "label": "Socializing", "icon": "🎉"},
        {"id": "nature", "label": "Nature", "icon": "🌳"}
    ];
    return {"activities": activities};
}

@app.get("/health")
can health_check() {
    return {"status": "healthy", "service": "MindMate Harmony"};
}