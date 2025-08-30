
#upload the post details to firebase when all of the data related to it is given
def upload_post(ref, id: int, category: str, title: str, body: str, date: str, image_link: str):
    new_post = {
            id: {
                "category": category,
                "title": title,
                "body": body,
                "date": date,
                "image_link": image_link,
                "likes": 0
            }
        }
        
    ref.update(new_post)