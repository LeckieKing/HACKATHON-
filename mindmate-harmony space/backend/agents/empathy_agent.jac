"""byLLM-powered empathy agent"""

import:py from mtllm.llms, Anthropic;
import:jac from walkers.pattern_analyzer, PatternAnalyzer;

glob llm = Anthropic(model_name="claude-sonnet-4-20250514");

node EmpathyAgent {
    has system_prompt: str = """You are MindMate, a compassionate mental health companion.
    Provide empathetic, supportive responses that validate emotions and offer gentle coping strategies.
    Keep responses concise (2-3 sentences). Never diagnose. Encourage professional help when needed.""";
    
    can generate_response(emotion: str, intensity: int, journal: str, patterns: dict) -> dict 
        by llm(method="Reason", system=self.system_prompt, incl_info=(emotion, intensity, journal, patterns));
    
    can suggest_coping(emotion: str, intensity: int, triggers: list) -> dict 
        by llm(method="Reason", system=self.system_prompt, incl_info=(emotion, intensity, triggers));
    
    can create_journal_prompt(mood: str, patterns: dict) -> str 
        by llm(method="Reason", system=self.system_prompt, incl_info=(mood, patterns));
}

walker GenerateAISuggestions {
    has emotion_id: str;
    has intensity: int;
    has user_id: str;
    has triggers: list = [];
    has journal_text: str = "";
    
    can generate with `root entry {
        pattern_walker = PatternAnalyzer(user_id=self.user_id);
        patterns_result = spawn here walker pattern_walker;
        patterns = patterns_result[0]["patterns"] if patterns_result else {};
        
        agent = EmpathyAgent();
        
        empathetic_response = agent.generate_response(
            emotion=self.emotion_id,
            intensity=self.intensity,
            journal=self.journal_text,
            patterns=patterns
        );
        
        coping_strategies = agent.suggest_coping(
            emotion=self.emotion_id,
            intensity=self.intensity,
            triggers=self.triggers
        );
        
        journal_prompt = agent.create_journal_prompt(
            mood=self.emotion_id,
            patterns=patterns
        );
        
        report {
            "empathetic_response": empathetic_response,
            "coping_strategies": coping_strategies,
            "journal_prompt": journal_prompt,
            "patterns": patterns
        };
    }
}