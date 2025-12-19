"""Backend entry point"""

import:py import uvicorn;
import:jac from graph.emotions, init_emotion_graph;
import:jac from graph.triggers, init_triggers;
import:jac from graph.activities, init_activities;
import:jac from server, app;

with entry {
    print("Initializing MindMate Backend...");
    spawn root walker init_emotion_graph();
    spawn root walker init_triggers();
    spawn root walker init_activities();
    print("Graph initialized!");
    
    uvicorn.run(app, host="0.0.0.0", port=8000);
}