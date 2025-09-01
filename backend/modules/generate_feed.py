import modules.firebase_config as firebase_config
import modules.datetime_util as datetime_util
import math

def generate_feed(user_id: str):
    

    posts_data = firebase_config.init_firebase().get()

    #extraction from user db of click_data
    users_ref = firebase_config.get_users_ref()
    click_data_ref = users_ref.child(user_id)
    click_data = click_data_ref.get()


    max_key = max(click_data, key=click_data.get)
    max_clicks = click_data[max_key]


    #generate a list where for each post where category_score, time_score & likes_score are stored as dicts
    list = {}

    for id in posts_data:
        post = posts_data[id]
        
        category = post['category']
        clicks = click_data[category]
        category_score = clicks/max_clicks
        
        MAX_DAYS = 5
        MIN_SCORE = 0.1  # score at 5 days
        LAMBDA = -math.log(MIN_SCORE) / MAX_DAYS  # decay rate

        datetime_string = post['date']
        dt = datetime_util.string_to_datetime(datetime_string)
        time_in_seconds = datetime_util.get_delta_in_seconds(dt)
        time_in_days = time_in_seconds / 86400

        # Exponential decay
        time_score = math.exp(-LAMBDA * time_in_days)
        
        max_likes = 10      #let's say out application is small scale that maximum likes that it would get is 10
        likes = post['likes']
        likes_score = likes / max_likes
        
        
        
        combined_score = 0.5*category_score + 0.3*time_score + 0.2*likes_score
        
        list[id] = combined_score
        
    sorted_posts = sorted(list.items(), key=lambda x: x[1], reverse=True)

    sorted_posts_dicts = [{post_id: score} for post_id, score in sorted_posts]


    return sorted_posts_dicts