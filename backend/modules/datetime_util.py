# 2 functions will come here:
#1. get datetime object from string
#2. calculate delta from current time and return as date-time object

from datetime import datetime

def string_to_datetime(date_string: str):
    date_time = datetime.strptime(date_string, "%d %b %Y %I:%M%p")
    
    return date_time


#input is datetime object
def get_delta_in_seconds(date_time: datetime):
    current = datetime.now()
    delta = current - date_time
    
    return delta.total_seconds()

def get_delta_in_days(date_time: datetime):
    current = datetime.now()
    delta = current - date_time
    
    return delta.days