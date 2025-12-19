"""
Insights Dashboard Component - Shows pattern analysis
"""

import:jac from api, api_client;

obj InsightsComponent {
    has patterns: dict = {};
    has emotions: list = [];
    has is_loading: bool = True;
    
    can init {
        self.emotions = api_client.get_emotions();
        self.load_patterns();
    }
    
    can load_patterns() {
        """Spawn PatternAnalyzer walker to get insights"""
        self.is_loading = True;
        
        result = api_client.get_patterns();
        
        if result.get("success") {
            data = result.get("data", []);
            self.patterns = data[0] if len(data) > 0 else {};
        }
        
        self.is_loading = False;
    }
    
    can render() -> str {
        if self.is_loading {
            return '''
            <div class="bg-white rounded-2xl shadow-xl p-8 text-center">
                <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-purple-600 mx-auto mb-4"></div>
                <p class="text-gray-600">Analyzing patterns...</p>
            </div>
            ''';
        }
        
        patterns_data = self.patterns.get("patterns", {});
        total = patterns_data.get("total_entries", 0);
        
        if total == 0 {
            return '''
            <div class="bg-white rounded-2xl shadow-xl p-8 text-center">
                <div class="text-5xl mb-4">📊</div>
                <p class="text-gray-600">Start logging moods to see insights</p>
            </div>
            ''';
        }
        
        # Build insights HTML
        insights_html = self.render_insights_cards(patterns_data);
        chart_html = self.render_chart(patterns_data);
        
        return f'''
        <div class="space-y-6">
            <div class="bg-white rounded-2xl shadow-xl p-8">
                <h2 class="text-2xl font-bold text-gray-800 mb-6">
                    🧠 Your Emotional Patterns
                </h2>
                {insights_html}
            </div>
            
            <div class="bg-white rounded-2xl shadow-xl p-8">
                <h3 class="text-xl font-bold text-gray-800 mb-4">
                    📊 Emotion Distribution
                </h3>
                {chart_html}
            </div>
        </div>
        ''';
    }
    
    can render_insights_cards(patterns: dict) -> str {
        cards = "";
        
        # Most common emotion
        most_common = patterns.get("most_common_emotion");
        if most_common {
            cards += f'''
            <div class="p-6 bg-gradient-to-r from-purple-50 to-pink-50 rounded-xl border-l-4 border-purple-500 mb-4">
                <div class="flex gap-4">
                    <div class="text-4xl">📊</div>
                    <div>
                        <h3 class="text-lg font-bold text-gray-800 mb-2">Emotional Trend</h3>
                        <p class="text-gray-700">Your most common emotion: <strong>{most_common}</strong></p>
                    </div>
                </div>
            </div>
            ''';
        }
        
        # Wellness score
        wellness = patterns.get("wellness_score", 0);
        message = "Great balance!" if wellness > 60 else "Try positive activities";
        cards += f'''
        <div class="p-6 bg-gradient-to-r from-green-50 to-blue-50 rounded-xl border-l-4 border-green-500">
            <div class="flex gap-4">
                <div class="text-4xl">💚</div>
                <div>
                    <h3 class="text-lg font-bold text-gray-800 mb-2">Wellbeing Score</h3>
                    <p class="text-gray-700">{round(wellness)}% positive moods. {message}</p>
                </div>
            </div>
        </div>
        ''';
        
        return cards;
    }
    
    can render_chart(patterns: dict) -> str {
        emotion_freq = patterns.get("emotion_frequency", {});
        total = patterns.get("total_entries", 1);
        
        chart = '<div class="space-y-3">';
        
        for emotion_id, count in emotion_freq.items() {
            emotion = next((e for e in self.emotions if e["id"] == emotion_id), None);
            if emotion {
                percentage = (count / total) * 100;
                
                chart += f'''
                <div class="flex items-center gap-3">
                    <span class="text-2xl">{emotion["icon"]}</span>
                    <div class="flex-1">
                        <div class="flex justify-between mb-1">
                            <span class="text-sm font-medium">{emotion["label"]}</span>
                            <span class="text-sm text-gray-600">{count} times</span>
                        </div>
                        <div class="w-full bg-gray-200 rounded-full h-3">
                            <div class="h-3 rounded-full" 
                                 style="width: {percentage}%; background-color: {emotion['color']}"></div>
                        </div>
                    </div>
                </div>
                ''';
            }
        }
        
        chart += '</div>';
        return chart;
    }
}