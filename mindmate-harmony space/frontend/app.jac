"""
Main Application Entry Point - Jac-Client
"""

import:jac from components.mood_logger, MoodLoggerComponent;
import:jac from components.insights, InsightsComponent;
import:jac from components.suggestions, SuggestionsComponent;

obj AppState {
    has active_tab: str = "log";
    has mood_logger: MoodLoggerComponent;
    has insights: InsightsComponent;
    has suggestions: SuggestionsComponent;
    
    can init {
        self.mood_logger = MoodLoggerComponent();
        self.insights = InsightsComponent();
        self.suggestions = SuggestionsComponent();
    }
    
    can set_tab(tab: str) {
        self.active_tab = tab;
        
        # Reload data when switching tabs
        if tab == "insights" {
            self.insights.load_patterns();
        }
    }
}

obj MindMateApp {
    has state: AppState;
    
    can init {
        self.state = AppState();
    }
    
    can render_header() -> str {
        return '''
        <header class="text-center mb-8">
            <div class="flex items-center justify-center gap-3 mb-3">
                <span class="text-pink-500 text-5xl">❤️</span>
                <h1 class="text-4xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
                    MindMate Harmony
                </h1>
            </div>
            <p class="text-gray-600">Your compassionate AI companion for emotional wellbeing</p>
        </header>
        ''';
    }
    
    can render_tabs() -> str {
        tabs = [
            {"id": "log", "label": "Log Mood", "icon": "📝"},
            {"id": "insights", "label": "Insights", "icon": "📊"},
            {"id": "suggestions", "label": "Suggestions", "icon": "💡"}
        ];
        
        tabs_html = '<div class="flex gap-2 mb-6 overflow-x-auto">';
        
        for tab in tabs {
            active = self.state.active_tab == tab["id"];
            classes = 'bg-gradient-to-r from-purple-500 to-pink-500 text-white shadow-lg' if active else 'bg-white text-gray-700';
            
            tabs_html += f'''
            <button class="tab-btn {classes}" data-tab="{tab['id']}">
                <span>{tab["icon"]}</span>
                {tab["label"]}
            </button>
            ''';
        }
        
        tabs_html += '</div>';
        return tabs_html;
    }
    
    can render_content() -> str {
        if self.state.active_tab == "log" {
            return self.state.mood_logger.render();
        } elif self.state.active_tab == "insights" {
            return self.state.insights.render();
        } elif self.state.active_tab == "suggestions" {
            return self.state.suggestions.render();
        }
        return "";
    }
    
    can render() -> str {
        return f'''
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>MindMate Harmony - AI Wellbeing Companion</title>
            <script src="https://cdn.tailwindcss.com"></script>
            <link rel="stylesheet" href="/static/style.css">
        </head>
        <body class="min-h-screen bg-gradient-to-br from-purple-50 via-pink-50 to-blue-50">
            <div class="max-w-6xl mx-auto p-6">
                {self.render_header()}
                {self.render_tabs()}
                
                <div id="content">
                    {self.render_content()}
                </div>
                
                <footer class="mt-8 text-center text-sm text-gray-600">
                    <p class="flex items-center justify-center gap-2 mb-2">
                        <span class="text-pink-500">❤️</span>
                        Your mental health journey is unique. These insights are guides, not diagnoses.
                    </p>
                    <p>If struggling, please reach out to a mental health professional.</p>
                </footer>
            </div>
            
            <script src="/static/app.js"></script>
        </body>
        </html>
        ''';
    }
}

# Application entry point
with entry {
    app = MindMateApp();
    print(app.render());
}