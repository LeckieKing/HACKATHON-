"""
SuggestionEngine Walker - Generates activity suggestions based on patterns
"""

import:jac from graph.emotions, MoodEntry, Activity;
import:jac from graph.emotions, helped_by;

walker SuggestionEngine {
    has user_id: str;
    has current_emotion: str;
    
    can generate_suggestions with `root entry {
        all_entries = [-->(`?MoodEntry)(?user_id==self.user_id)];
        recent_entries = all_entries[-20:] if len(all_entries) >= 20 else all_entries;
        
        helpful_activities = {};
        
        for entry in recent_entries {
            if entry.emotion_id == self.current_emotion {
                visit [-->helped_by] else {
                    activity_node = here;
                    activity_id = activity_node.id;
                    
                    if activity_id not in helpful_activities {
                        helpful_activities[activity_id] = {
                            "id": activity_id,
                            "label": activity_node.label,
                            "type": activity_node.type,
                            "icon": activity_node.icon,
                            "count": 0
                        };
                    }
                    helpful_activities[activity_id]["count"] += 1;
                }
            }
        }
        
        sorted_activities = sorted(
            helpful_activities.values(),
            key=lambda x: x["count"],
            reverse=True
        );
        
        general_suggestions = [];
        
        if self.current_emotion in ['anxious', 'stressed'] {
            general_suggestions = [
                {"title": "Deep Breathing", "description": "Try 4-7-8 breathing", "icon": "🌬️"},
                {"title": "Progressive Relaxation", "description": "Tense and release muscles", "icon": "🧘"},
                {"title": "Grounding", "description": "5-4-3-2-1 sensory awareness", "icon": "🌿"}
            ];
        } elif self.current_emotion in ['sad', 'down'] {
            general_suggestions = [
                {"title": "Gratitude Journal", "description": "Write three things you're grateful for", "icon": "✍️"},
                {"title": "Reach Out", "description": "Connect with a friend", "icon": "💬"},
                {"title": "Gentle Movement", "description": "Take a short walk", "icon": "🚶"}
            ];
        } else {
            general_suggestions = [
                {"title": "Mindfulness", "description": "5-minute meditation", "icon": "🧘"},
                {"title": "Self-Care", "description": "Do something nice for yourself", "icon": "💆"},
                {"title": "Reflect", "description": "Journal about your day", "icon": "📝"}
            ];
        }
        
        report {
            "personalized_activities": sorted_activities[:5],
            "general_suggestions": general_suggestions,
            "total_history": len(recent_entries)
        };
    }
}
