
#upload the post details to firebase when all of the data related to it is given
def upload_post(ref, id: int, title: str, body: str, date: str):
    new_post = {
            id: {
                "title": title,
                "body": body,
                "date": date
            }
        }
        
    ref.update(new_post)