## frontend/main.jac
```jac
"""Frontend entry point using Jac-Client"""

import:jac from app, MindMateApp;

with entry {
    app = MindMateApp();
    app.run();
}