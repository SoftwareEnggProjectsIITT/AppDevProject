import modules.datetime_util as datetime_util
import modules.firebase_config as firebase_config
MAX_DAYS = 5    #number of days for which the posts have to be retained

def delete_old_posts():
    ref = firebase_config.init_firebase()

    data = ref.get()
        
    for id, info in data.items():
        date_time_string = info.get('date')
        date_time = datetime_util.string_to_datetime(date_time_string)
        
        delta_days = datetime_util.get_delta_in_days(date_time)
        
        if delta_days >= MAX_DAYS:
            ref.child(id).delete()