import modules.firebase_config as firebase_config
import modules.parser_utils as parser_utils
import modules.get_ids as get_ids
import modules.scraper as scraper
import modules.uploader as uploader

#getting all the links for the specified date
date = "27"
category_ids_dict = get_ids.get_ids_by_categories(date)

ref = firebase_config.init_firebase()

base_url = 'https://www.pib.gov.in/PressReleasePage.aspx?PRID='

for category in category_ids_dict:
    list = category_ids_dict[category]
    
    for id in list:
        html = scraper.fetch_page(id)   #here html is of type BeautifulSoup and not string
        
        title = parser_utils.parse_title(html)
        body = parser_utils.parse_body(html)
        date = parser_utils.parse_date(html)
        image_link = parser_utils.parse_image(html, category)
        
        uploader.upload_post(ref, id, category, title, body, date, image_link)