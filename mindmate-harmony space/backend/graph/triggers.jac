"""Trigger nodes for MindMate"""

import:jac from emotions, Trigger;

walker init_triggers {
    can create_triggers with `root entry {
        triggers = [
            Trigger(id='work', label='Work Stress', category='professional', icon='💼'),
            Trigger(id='social', label='Social Interaction', category='social', icon='👥'),
            Trigger(id='family', label='Family', category='personal', icon='👨‍👩‍👧'),
            Trigger(id='health', label='Health Concerns', category='health', icon='🏥'),
            Trigger(id='finance', label='Financial Worry', category='financial', icon='💰'),
            Trigger(id='sleep', label='Sleep Issues', category='health', icon='😴'),
            Trigger(id='news', label='News/Media', category='external', icon='📰'),
            Trigger(id='weather', label='Weather', category='external', icon='🌤️')
        ];
        
        for trigger in triggers {
            here ++> trigger;
        }
    }
}