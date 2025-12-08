# 🌈 MindMate Harmony Space

<div align="center">

**Your Compassionate AI Companion for Mental Wellbeing**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![JacLang](https://img.shields.io/badge/JacLang-0.7+-blue.svg)](https://jaclang.org)
[![React](https://img.shields.io/badge/React-18.3+-61DAFB.svg)](https://reactjs.org)
[![Anthropic Claude](https://img.shields.io/badge/Powered%20by-Claude-5A67D8.svg)](https://anthropic.com)

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Architecture](#-architecture) • [Contributing](#-contributing)

</div>

---

## 📖 About

MindMate Harmony Space is an AI-powered mental wellbeing companion that helps you:
- 🎭 Track your emotional states and mood patterns
- 🔍 Identify triggers and correlations
- 💡 Receive personalized coping strategies
- 📊 Visualize your emotional journey
- 📝 Journal privately and securely
- 📅 Follow adaptive wellness plans

Built with **JacLang** (OSP Graph Architecture) and **React**, powered by **Anthropic's Claude AI**.

---

## ✨ Features

### 🎯 Core Capabilities

| Feature | Description |
|---------|-------------|
| **Mood Logging** | Express emotions through an intuitive emoji wheel with intensity tracking |
| **Trigger Identification** | Track what influences your emotional states |
| **Pattern Recognition** | AI-powered trend detection across your emotional data |
| **Personalized Suggestions** | Context-aware coping strategies, breathing exercises, and activities |
| **Secure Journaling** | Private space for thoughts and reflections |
| **Insights Dashboard** | Visual analytics showing your emotional patterns over time |
| **Weekly Wellness Plans** | Adaptive roadmaps tailored to your needs |

### 🧠 AI-Powered Intelligence

- **Emotion Analysis**: Natural language processing to understand your feelings
- **Pattern Detection**: Identifies correlations between triggers, activities, and emotions
- **Adaptive Learning**: Suggestions improve based on what works for you
- **Empathetic Responses**: Compassionate AI-generated support messages

---

## 🚀 Installation

### Prerequisites

Before you begin, ensure you have the following installed:

| Tool | Version | Installation |
|------|---------|--------------|
| **Python** | 3.11+ | [Download](https://www.python.org/downloads/) |
| **Node.js** | 18+ | [Download](https://nodejs.org/) |
| **JacLang** | 0.7+ | See below |
| **Git** | Latest | [Download](https://git-scm.com/) |

### Step 1: Install JacLang

```bash
# Install JacLang via official installer
curl -sSf https://raw.githubusercontent.com/Jaseci-Labs/jaclang/main/install.sh | bash

# Verify installation
jac --version
```

### Step 2: Clone the Repository

```bash
git clone https://github.com/yourusername/mindmate-harmony-space.git
cd mindmate-harmony-space
```

### Step 3: Backend Setup

```bash
# Navigate to backend directory
cd backend

# Create virtual environment (recommended)
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install Python dependencies
pip install -r requirements.txt

# Create environment file
cp .env.example .env

# Edit .env and add your Anthropic API key
nano .env  # or use your preferred editor
```

**Required Environment Variables** (`.env`):
```bash
# Anthropic API Key (Required)
ANTHROPIC_API_KEY=your_api_key_here

# Server Configuration
JAC_PORT=8000
JAC_HOST=0.0.0.0

# Graph Storage
GRAPH_STORAGE_PATH=./data/graph_storage

# Logging
LOG_LEVEL=INFO

# CORS (for frontend)
CORS_ORIGINS=http://localhost:3000,http://localhost:5173
```

### Step 4: Frontend Setup

```bash
# Open a new terminal and navigate to frontend
cd frontend

# Install Node.js dependencies
npm install

# Create environment file
cp .env.example .env.local

# Edit .env.local with backend URL
nano .env.local
```

**Required Environment Variables** (`.env.local`):
```bash
VITE_API_URL=http://localhost:8000
VITE_APP_NAME=MindMate Harmony Space
```

### Step 5: Get Your Anthropic API Key

1. Visit [Anthropic Console](https://console.anthropic.com/)
2. Sign up or log in
3. Navigate to API Keys section
4. Create a new API key
5. Copy and paste into your `.env` file

---

## 🎮 Usage

### Starting the Application

#### Option 1: Manual Start (Development)

**Terminal 1 - Backend:**
```bash
cd backend
source venv/bin/activate  # On Windows: venv\Scripts\activate
jac serve src/main.jac --port 8000
```

**Terminal 2 - Frontend:**
```bash
cd frontend
npm run dev
```

Open your browser to: `http://localhost:5173`

#### Option 2: Docker (Production)

```bash
# Build and start all services
docker-compose up --build

# Access the application
# Frontend: http://localhost:3000
# Backend API: http://localhost:8000
```

#### Option 3: Quick Start Script

```bash
# Make script executable
chmod +x scripts/setup.sh

# Run setup and start
./scripts/setup.sh
```

---

## 📱 Using MindMate

### 1. Log Your First Mood

1. Click **"Log Your Mood"** on the home screen
2. Select an emotion from the wheel (e.g., 😊 Happy, 😰 Anxious)
3. Adjust the intensity slider (1-10)
4. Optionally add a trigger (e.g., "work deadline")
5. Add journal notes if desired
6. Click **"Log Mood"**

You'll receive personalized suggestions immediately!

### 2. View Insights

1. Click **"Insights"** from the home screen
2. Explore:
   - Total check-ins
   - Most common emotions
   - Average intensity
   - Emotion breakdown chart
   - Common triggers

### 3. Access Your Weekly Plan

1. Click **"Weekly Plan"**
2. Review personalized daily activities
3. Check off completed activities
4. Track your wellness goals

### 4. Journal Privately

1. Click **"Journal"** from home
2. Write freely about your thoughts
3. Entries are stored securely and linked to emotions
4. Review past entries anytime

---

## 🏗️ Architecture

### Backend (JacLang OSP Graph)

```
┌─────────────────────────────────────────┐
│            User Node (Root)             │
└─────────────────────────────────────────┘
         │
         ├──→ Emotion Nodes (happy, sad, anxious...)
         │    │
         │    ├──→ Journal Entries
         │    └──→ Suggestions (via helps_with edge)
         │
         ├──→ Trigger Nodes (work, social, health...)
         │    │
         │    └──→ influences → Emotions
         │
         └──→ Activity Nodes (breathing, walking...)
              │
              └──→ helps_with → Emotions
```

### Walkers (Graph Agents)

- **MoodLogger**: Processes mood entries and updates graph
- **TrendDetector**: Analyzes patterns across time windows
- **SuggestionGenerator**: Creates personalized coping strategies
- **ActivityTracker**: Monitors effectiveness of interventions
- **WeeklyPlanGenerator**: Builds adaptive wellness roadmaps

### Frontend (React)

- **Component-based architecture**: Modular, reusable UI components
- **Custom hooks**: `useMoodLog`, `useTrends`, `useJournal`
- **Service layer**: API communication abstraction
- **Context providers**: Global state management

---

## 🧪 Testing

### Backend Tests

```bash
cd backend
jac test tests/
```

### Frontend Tests

```bash
cd frontend
npm test
```

### Run All Tests

```bash
./scripts/test.sh
```

---

## 🔧 Configuration

### Customizing Emotions

Edit `backend/src/config/emotions.jac`:
```jaclang
glob EMOTIONS = [
    ("joyful", "positive"),
    ("peaceful", "positive"),
    ("frustrated", "negative"),
    // Add your custom emotions
];
```

### Adjusting LLM Settings

Edit `backend/src/config/llm_config.jac`:
```jaclang
glob LLM_CONFIG = {
    "model": "claude-sonnet-4-20250514",
    "temperature": 0.7,
    "max_tokens": 1000
};
```

---

## 📊 Data Privacy & Security

MindMate takes your privacy seriously:

- ✅ **Local-first storage**: Your data stays on your device by default
- ✅ **Encrypted journal entries**: End-to-end encryption for sensitive content
- ✅ **No data selling**: Your emotional data is NEVER sold or shared
- ✅ **Open source**: Audit the code yourself
- ✅ **GDPR compliant**: Right to access, export, and delete your data

### Exporting Your Data

```bash
# Export all your data as JSON
jac run scripts/export_data.jac --user-id YOUR_ID --output my_data.json
```

---

## 🛠️ Troubleshooting

### Common Issues

#### 1. "Module not found" error
```bash
# Reinstall dependencies
cd backend && pip install -r requirements.txt
cd frontend && npm install
```

#### 2. "Port already in use"
```bash
# Find and kill process using port 8000
lsof -ti:8000 | xargs kill -9

# Or change port in .env
JAC_PORT=8001
```

#### 3. "Anthropic API Key Invalid"
- Verify your API key in `.env`
- Check for extra spaces or quotes
- Ensure key starts with `sk-ant-`

#### 4. Frontend can't connect to backend
- Verify backend is running: `curl http://localhost:8000/health`
- Check CORS settings in backend `.env`
- Ensure `VITE_API_URL` matches backend URL

---

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes**
4. **Run tests**: `./scripts/test.sh`
5. **Commit**: `git commit -m 'Add amazing feature'`
6. **Push**: `git push origin feature/amazing-feature`
7. **Open a Pull Request**

### Development Guidelines

- Follow the existing code style
- Add tests for new features
- Update documentation
- Keep commits atomic and descriptive

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Anthropic** - For Claude AI capabilities
- **JacLang Team** - For the innovative OSP graph framework
- **React Community** - For the excellent frontend framework
- **Mental Health Professionals** - For guidance on supportive design

---

## 📞 Support

- 📧 **Email**: support@mindmate-harmony.com
- 💬 **Discord**: [Join our community](https://discord.gg/mindmate)
- 🐛 **Issues**: [GitHub Issues](https://github.com/yourusername/mindmate-harmony-space/issues)
- 📖 **Docs**: [Full Documentation](https://docs.mindmate-harmony.com)

---

## 🗺️ Roadmap

### Version 1.0 (Current)
- [x] Mood logging with emotion wheel
- [x] Basic pattern recognition
- [x] Personalized suggestions
- [x] Insights dashboard

### Version 1.1 (Coming Soon)
- [ ] Voice input for mood logging
- [ ] Mobile app (iOS/Android)
- [ ] Meditation timer integration
- [ ] Export reports (PDF)

### Version 2.0 (Future)
- [ ] Social support circles
- [ ] Therapist collaboration features
- [ ] Advanced analytics with ML
- [ ] Wearable device integration

---

## ⚠️ Disclaimer

**MindMate is not a substitute for professional mental health care.** If you're experiencing a mental health crisis, please contact:

- 🇺🇸 **US**: 988 (Suicide & Crisis Lifeline)
- 🇬🇧 **UK**: 116 123 (Samaritans)
- 🌍 **International**: [Find a Helpline](https://findahelpline.com)

MindMate is designed as a complementary tool to support your wellbeing journey.

---

<div align="center">

**Made with ❤️ and 🧠 for mental wellness**

[⬆ Back to Top](#-mindmate-harmony-space)

</div>