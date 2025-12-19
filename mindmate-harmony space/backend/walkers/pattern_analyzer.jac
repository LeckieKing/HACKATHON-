"""Walker for pattern detection"""

import:jac from graph.emotions, MoodEntry, Emotion;
import:jac from graph.emotions, influences, triggered_by;

walker PatternAnalyzer {
    has user_id: str;
    has time_range: int = 7;
    
    can analyze_patterns with `root entry {
        all_entries = [-->(`?MoodEntry)(?user_id==self.user_id)];
        recent_entries = all_entries[-self.time_range:] if len(all_entries) >= self.time_range else all_entries;
        
        if len(recent_entries) == 0 {
            report {"patterns": {"total_entries": 0}};
            disengage;
        }
        
        emotion_counts = {};
        trigger_counts = {};
        positive_count = 0;
        total_intensity = 0;
        
        for entry in recent_entries {
            emotion_counts[entry.emotion_id] = emotion_counts.get(entry.emotion_id, 0) + 1;
            total_intensity += entry.intensity;
            
            visit [-->influences] else {
                if here.sentiment == 'positive' {
                    positive_count += 1;
                }
            }
            
            visit [-->triggered_by] else {
                trigger_counts[here.id] = trigger_counts.get(here.id, 0) + 1;
            }
        }
        
        most_common = max(emotion_counts, key=emotion_counts.get) if emotion_counts else None;
        top_trigger = max(trigger_counts, key=trigger_counts.get) if trigger_counts else None;
        wellness = (positive_count / len(recent_entries) * 100) if recent_entries else 0;
        avg_intensity = total_intensity / len(recent_entries) if recent_entries else 0;
        
        report {
            "patterns": {
                "most_common_emotion": most_common,
                "emotion_frequency": emotion_counts,
                "top_trigger": top_trigger,
                "trigger_frequency": trigger_counts,
                "wellness_score": round(wellness, 2),
                "total_entries": len(recent_entries),
                "average_intensity": round(avg_intensity, 2)
            }
        };
    }
}