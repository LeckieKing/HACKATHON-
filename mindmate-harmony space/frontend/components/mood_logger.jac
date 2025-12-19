"""Mood Logger Component - Jac-Client"""

import:jac from services.api, api;

node MoodLoggerComponent {
    has emotions: list = [];
    has triggers: list = [];
    has activities: list = [];
    has selected_emotion: dict = {};
    has intensity: int = 5;
    has selected_triggers: list = [];
    has selected_activities: list = [];
    has journal_text: str = "";
    has is_loading: bool = False;
    has success_message: str = "";
    
    can init {
        # Load data from backend
        self.emotions = api.get_emotions();
        self.triggers = api.get_triggers();
        self.activities = api.get_activities();
    }
    
    can select_emotion(emotion: dict) {
        self.selected_emotion = emotion;
    }
    
    can set_intensity(value: int) {
        self.intensity = value;
    }
    
    can toggle_trigger(trigger_id: str) {
        if trigger_id in self.selected_triggers {
            self.selected_triggers.remove(trigger_id);
        } else {
            self.selected_triggers.append(trigger_id);
        }
    }
    
    can toggle_activity(activity_id: str) {
        if activity_id in self.selected_activities {
            self.selected_activities.remove(activity_id);
        } else {
            self.selected_activities.append(activity_id);
        }
    }
    
    can submit_mood() {
        if not self.selected_emotion {
            return;
        }
        
        self.is_loading = True;
        
        # Spawn MoodLogger walker on backend
        result = api.log_mood(
            emotion_id=self.selected_emotion["id"],
            intensity=self.intensity,
            triggers=self.selected_triggers,
            activities=self.selected_activities,
            journal_text=self.journal_text,
            user_id="user_123"
        );
        
        if result.get("success") {
            self.success_message = "Mood logged successfully! 🎉";
            
            # Reset form
            self.selected_emotion = {};
            self.intensity = 5;
            self.selected_triggers = [];
            self.selected_activities = [];
            self.journal_text = "";
        }
        
        self.is_loading = False;
    }
    
    can render() -> str {
        html = f'''
        <div class="bg-white rounded-2xl shadow-xl p-8">
            <h2 class="text-2xl font-bold text-gray-800 mb-6 flex items-center gap-2">
                <span class="text-purple-500">😊</span>
                How are you feeling right now?
            </h2>
            
            {self.render_success_message()}
            {self.render_emotions()}
            
            {self.render_intensity() if self.selected_emotion else ""}
            {self.render_triggers() if self.selected_emotion else ""}
            {self.render_activities() if self.selected_emotion else ""}
            {self.render_journal() if self.selected_emotion else ""}
            {self.render_submit() if self.selected_emotion else ""}
        </div>
        ''';
        return html;
    }
    
    can render_success_message() -> str {
        if not self.success_message {
            return "";
        }
        return f'''
        <div class="mb-6 p-4 bg-green-50 border-2 border-green-300 rounded-xl text-green-700 font-medium">
            {self.success_message}
        </div>
        ''';
    }
    
    can render_emotions() -> str {
        emotion_buttons = "";
        for emotion in self.emotions {
            is_selected = self.selected_emotion.get("id") == emotion["id"];
            bg_color = f'{emotion["color"]}20' if is_selected else 'white';
            ring_class = 'ring-4 ring-purple-300 shadow-lg' if is_selected else 'hover:shadow-md';
            
            emotion_buttons += f'''
            <button 
                onclick="selectEmotion('{emotion["id"]}')"
                class="p-6 rounded-xl transition-all transform hover:scale-105 {ring_class}"
                style="background-color: {bg_color}; border: 2px solid {emotion['color']}">
                <div class="text-5xl mb-2">{emotion["icon"]}</div>
                <div class="font-semibold text-gray-700">{emotion["label"]}</div>
            </button>
            ''';
        }
        
        return f'''
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
            {emotion_buttons}
        </div>
        ''';
    }
    
    can render_intensity() -> str {
        return f'''
        <div class="mb-6">
            <label class="block text-lg font-semibold text-gray-700 mb-3">
                Intensity (1-10)
            </label>
            <input 
                type="range" 
                min="1" 
                max="10" 
                value="{self.intensity}"
                onchange="setIntensity(this.value)"
                class="w-full h-3 bg-gradient-to-r from-blue-200 to-purple-400 rounded-lg appearance-none cursor-pointer">
            <div class="flex justify-between text-sm text-gray-600 mt-2">
                <span>Mild</span>
                <span class="text-lg font-bold text-purple-600">{self.intensity}</span>
                <span>Intense</span>
            </div>
        </div>
        ''';
    }
    
    can render_triggers() -> str {
        trigger_buttons = "";
        for trigger in self.triggers {
            is_selected = trigger["id"] in self.selected_triggers;
            button_class = 'bg-gradient-to-r from-purple-500 to-pink-500 text-white shadow-md' if is_selected else 'bg-gray-100 text-gray-700 hover:bg-gray-200';
            
            trigger_buttons += f'''
            <button 
                onclick="toggleTrigger('{trigger["id"]}')"
                class="p-4 rounded-lg transition-all {button_class}">
                <div class="text-2xl mb-1">{trigger["icon"]}</div>
                <div class="text-sm font-medium">{trigger["label"]}</div>
            </button>
            ''';
        }
        
        return f'''
        <div class="mb-6">
            <label class="block text-lg font-semibold text-gray-700 mb-3">
                What might have triggered this? (Optional)
            </label>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
                {trigger_buttons}
            </div>
        </div>
        ''';
    }
    
    can render_activities() -> str {
        activity_buttons = "";
        for activity in self.activities {
            is_selected = activity["id"] in self.selected_activities;
            button_class = 'bg-gradient-to-r from-blue-500 to-teal-500 text-white shadow-md' if is_selected else 'bg-gray-100 text-gray-700 hover:bg-gray-200';
            
            activity_buttons += f'''
            <button 
                onclick="toggleActivity('{activity["id"]}')"
                class="p-4 rounded-lg transition-all {button_class}">
                <div class="text-2xl mb-1">{activity["icon"]}</div>
                <div class="text-sm font-medium">{activity["label"]}</div>
            </button>
            ''';
        }
        
        return f'''
        <div class="mb-6">
            <label class="block text-lg font-semibold text-gray-700 mb-3">
                What activities did you do? (Optional)
            </label>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
                {activity_buttons}
            </div>
        </div>
        ''';
    }
    
    can render_journal() -> str {
        return f'''
        <div class="mb-6">
            <label class="block text-lg font-semibold text-gray-700 mb-3 flex items-center gap-2">
                📖 Journal Entry (Optional)
            </label>
            <textarea 
                onchange="setJournalText(this.value)"
                placeholder="Write about your thoughts and feelings..."
                class="w-full p-4 border-2 border-purple-200 rounded-xl focus:border-purple-400 focus:outline-none resize-none"
                rows="4">{self.journal_text}</textarea>
        </div>
        ''';
    }
    
    can render_submit() -> str {
        button_content = '''
        <div class="animate-spin rounded-full h-6 w-6 border-b-2 border-white"></div>
        Processing with AI...
        ''' if self.is_loading else 'Save Mood Entry';
        
        disabled = 'disabled opacity-50 cursor-not-allowed' if self.is_loading else '';
        
        return f'''
        <button 
            onclick="submitMood()"
            {disabled}
            class="w-full py-4 bg-gradient-to-r from-purple-600 to-pink-600 text-white rounded-xl font-bold text-lg hover:shadow-lg transition-all flex items-center justify-center gap-2">
            {button_content}
        </button>
        ''';
    }
}
