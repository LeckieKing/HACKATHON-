"""Walker for logging mood entries"""

import:py from datetime, datetime;
import:jac from graph.emotions, MoodEntry, Emotion, Trigger, Activity;
import:jac from graph.emotions, influences, triggered_by, helped_by;

walker MoodLogger {
    has emotion_id: str;
    has intensity: int;
    has triggers: list = [];
    has activities: list = [];
    has journal_text: str = "";
    has user_id: str;
    
    can log_mood with `root entry {
        entry_node = MoodEntry(
            timestamp=datetime.now().isoformat(),
            emotion_id=self.emotion_id,
            intensity=self.intensity,
            journal_text=self.journal_text,
            user_id=self.user_id
        );
        
        here ++> entry_node;
        
        emotion_nodes = [-->(`?Emotion)(?id==self.emotion_id)];
        if len(emotion_nodes) > 0 {
            entry_node ++> emotion_nodes[0] via influences;
        }
        
        for trigger_id in self.triggers {
            trigger_nodes = [-->(`?Trigger)(?id==trigger_id)];
            if len(trigger_nodes) > 0 {
                entry_node ++> trigger_nodes[0] via triggered_by;
            }
        }
        
        for activity_id in self.activities {
            activity_nodes = [-->(`?Activity)(?id==activity_id)];
            if len(activity_nodes) > 0 {
                entry_node ++> activity_nodes[0] via helped_by;
            }
        }
        
        report {
            "success": True,
            "timestamp": entry_node.timestamp,
            "message": "Mood logged successfully"
        };
    }
}