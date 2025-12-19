"""Emotion nodes and graph structure for MindMate"""

node Emotion {
    has id: str;
    has label: str;
    has sentiment: str;
    has color: str;
    has icon: str;
}

node Trigger {
    has id: str;
    has label: str;
    has category: str;
    has icon: str;
}

node Activity {
    has id: str;
    has label: str;
    has type: str;
    has icon: str;
}

node MoodEntry {
    has timestamp: str;
    has emotion_id: str;
    has intensity: int;
    has journal_text: str;
    has user_id: str;
}

edge influences;
edge triggered_by;
edge helped_by;
edge correlates_with;

walker init_emotion_graph {
    can create_emotions with `root entry {
        emotions = [
            Emotion(id='happy', label='Happy', sentiment='positive', color='#FFD700', icon='😊'),
            Emotion(id='calm', label='Calm', sentiment='positive', color='#87CEEB', icon='😌'),
            Emotion(id='anxious', label='Anxious', sentiment='negative', color='#DDA0DD', icon='😰'),
            Emotion(id='sad', label='Sad', sentiment='negative', color='#4682B4', icon='😢'),
            Emotion(id='angry', label='Angry', sentiment='negative', color='#DC143C', icon='😠'),
            Emotion(id='neutral', label='Neutral', sentiment='neutral', color='#A9A9A9', icon='😐'),
            Emotion(id='energetic', label='Energetic', sentiment='positive', color='#FF6347', icon='⚡'),
            Emotion(id='excited', label='Excited', sentiment='positive', color='#FF69B4', icon='🤩')
        ];
        
        for emotion in emotions {
            here ++> emotion;
        }
    }
}