"""Activity nodes for MindMate"""

import:jac from emotions, Activity;

walker init_activities {
    can create_activities with `root entry {
        activities = [
            Activity(id='exercise', label='Exercise', type='physical', icon='🏃'),
            Activity(id='meditation', label='Meditation', type='mental', icon='🧘'),
            Activity(id='reading', label='Reading', type='mental', icon='📚'),
            Activity(id='music', label='Music', type='creative', icon='🎵'),
            Activity(id='socializing', label='Socializing', type='social', icon='🎉'),
            Activity(id='nature', label='Nature Walk', type='physical', icon='🌳'),
            Activity(id='creative', label='Creative Work', type='creative', icon='🎨'),
            Activity(id='rest', label='Resting', type='physical', icon='🛋️')
        ];
        
        for activity in activities {
            here ++> activity;
        }
    }
}