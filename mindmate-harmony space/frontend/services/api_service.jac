"""API service layer for Jac-Client frontend"""

import:py from urllib.request, urlopen, Request;
import:py import json;

glob BACKEND_URL = "http://localhost:8000";

"""
Jac-Client API Client
Provides methods to spawn walkers on backend via HTTP
"""
node APIClient {
    has base_url: str = BACKEND_URL;
    
    can spawn_walker(walker_name: str, params: dict) -> dict {
        """
        Spawn a walker on the backend
        This is the core Jac-Client pattern - direct walker invocation
        """
        url = f"{self.base_url}/api/walker/spawn?walker_name={walker_name}";
        data = json.dumps(params).encode('utf-8');
        
        request = Request(
            url,
            data=data,
            headers={'Content-Type': 'application/json'},
            method='POST'
        );
        
        try {
            response = urlopen(request);
            result = json.loads(response.read().decode('utf-8'));
            return result;
        } except Exception as e {
            print(f"Error spawning walker: {e}");
            return {"success": False, "error": str(e)};
        }
    }
    
    can log_mood(
        emotion_id: str,
        intensity: int,
        triggers: list,
        activities: list,
        journal_text: str,
        user_id: str
    ) -> dict {
        """Spawn MoodLogger walker"""
        return self.spawn_walker("MoodLogger", {
            "emotion_id": emotion_id,
            "intensity": intensity,
            "triggers": triggers,
            "activities": activities,
            "journal_text": journal_text,
            "user_id": user_id
        });
    }
    
    can get_patterns(user_id: str, time_range: int = 7) -> dict {
        """Spawn PatternAnalyzer walker"""
        return self.spawn_walker("PatternAnalyzer", {
            "user_id": user_id,
            "time_range": time_range
        });
    }
    
    can get_suggestions(user_id: str, emotion_id: str) -> dict {
        """Spawn SuggestionEngine walker"""
        return self.spawn_walker("SuggestionEngine", {
            "user_id": user_id,
            "current_emotion": emotion_id
        });
    }
    
    can get_ai_suggestions(
        emotion_id: str,
        intensity: int,
        user_id: str,
        triggers: list = [],
        journal_text: str = ""
    ) -> dict {
        """Spawn AI-powered suggestions walker with byLLM"""
        return self.spawn_walker("GenerateAISuggestions", {
            "emotion_id": emotion_id,
            "intensity": intensity,
            "user_id": user_id,
            "triggers": triggers,
            "journal_text": journal_text
        });
    }
    
    can fetch_json(endpoint: str) -> dict {
        """Fetch JSON data from endpoint"""
        url = f"{self.base_url}{endpoint}";
        try {
            response = urlopen(url);
            return json.loads(response.read().decode('utf-8'));
        } except Exception as e {
            print(f"Error fetching {endpoint}: {e}");
            return {};
        }
    }
    
    can get_emotions() -> list {
        """Get available emotions"""
        result = self.fetch_json("/api/emotions");
        return result.get("emotions", []);
    }
    
    can get_triggers() -> list {
        """Get available triggers"""
        result = self.fetch_json("/api/triggers");
        return result.get("triggers", []);
    }
    
    can get_activities() -> list {
        """Get available activities"""
        result = self.fetch_json("/api/activities");
        return result.get("activities", []);
    }
}

# Global API client instance
glob api = APIClient();