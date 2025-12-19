"""
AI Suggestions Component - Uses byLLM agent
"""

import:jac from api, api_client;

obj SuggestionsComponent {
    has suggestions: dict = {};
    has is_loading: bool = False;
    has current_emotion: str = "";
    
    can load_suggestions(emotion_id: str, intensity: int) {
        """Spawn GenerateAISuggestions walker with byLLM"""
        self.is_loading = True;
        self.current_emotion = emotion_id;
        
        result = api_client.get_ai_suggestions(
            emotion_id=emotion_id,
            intensity=intensity
        );
        
        if result.get("success") {
            data = result.get("data", []);
            self.suggestions = data[0] if len(data) > 0 else {};
        }
        
        self.is_loading = False;
    }
    
    can render() -> str {
        if self.is_loading {
            return '''
            <div class="bg-white rounded-2xl shadow-xl p-8 text-center">
                <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-purple-600 mx-auto mb-4"></div>
                <p class="text-gray-600">AI is generating suggestions...</p>
            </div>
            ''';
        }
        
        if not self.suggestions {
            return '''
            <div class="bg-white rounded-2xl shadow-xl p-8 text-center">
                <div class="text-5xl mb-4">💡</div>
                <p class="text-gray-600">Log a mood to get personalized AI suggestions</p>
            </div>
            ''';
        }
        
        # Extract suggestions from byLLM response
        journal_prompt = self.suggestions.get("journal_prompt", "");
        coping = self.suggestions.get("coping_strategies", {});
        breathing = self.suggestions.get("breathing_exercise", {});
        
        return f'''
        <div class="space-y-6">
            <div class="bg-white rounded-2xl shadow-xl p-8">
                <h2 class="text-2xl font-bold text-gray-800 mb-6">
                    ✨ AI-Powered Suggestions
                </h2>
                
                {self.render_journal_prompt(journal_prompt)}
                {self.render_coping_strategies(coping)}
                {self.render_breathing(breathing)}
            </div>
        </div>
        ''';
    }
    
    can render_journal_prompt(prompt: str) -> str {
        if not prompt {
            return "";
        }
        
        return f'''
        <div class="p-6 bg-purple-50 rounded-xl mb-4">
            <h3 class="text-lg font-bold text-purple-900 mb-2">📝 Journal Prompt</h3>
            <p class="text-gray-700">{prompt}</p>
        </div>
        ''';
    }
    
    can render_coping_strategies(strategies: dict) -> str {
        if not strategies {
            return "";
        }
        
        # byLLM returns structured data - extract strategies
        strategy_text = str(strategies);  # Simplified - parse JSON in production
        
        return f'''
        <div class="p-6 bg-blue-50 rounded-xl mb-4">
            <h3 class="text-lg font-bold text-blue-900 mb-2">🎯 Coping Strategies</h3>
            <p class="text-gray-700">{strategy_text}</p>
        </div>
        ''';
    }
    
    can render_breathing(exercise: dict) -> str {
        return '''
        <div class="p-6 bg-gradient-to-r from-teal-50 to-blue-50 rounded-xl">
            <h3 class="text-lg font-bold text-teal-900 mb-4">🌬️ Breathing Exercise</h3>
            <ol class="space-y-2 text-gray-700">
                <li>1. Breathe in slowly for 4 seconds</li>
                <li>2. Hold your breath for 7 seconds</li>
                <li>3. Exhale completely for 8 seconds</li>
                <li>4. Repeat 4 times</li>
            </ol>
        </div>
        ''';
    }
}