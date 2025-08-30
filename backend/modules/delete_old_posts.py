from datetime import datetime
import modules.firebase_config as firebase_config
MAX_DAYS = 5    #number of days for which the posts have to be retained

def delete_old_posts():
    current = datetime.now()
    ref = firebase_config.init_firebase()

    data = ref.get()
        
    for id, info in data.items():
        date_time_string = info.get('date')
        date_time = datetime.strptime(date_time_string, "%d %b %Y %I:%M%p")
        
        delta_days = (current-date_time).days
        
        if delta_days >= MAX_DAYS:
            ref.child(id).delete()