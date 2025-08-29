import re

#inputs for all below definitions is the html of the webpage
#the html is in string format

# getting body for the post
def parse_body(html: str) -> str:
    main_div = html.find('div', {'id': 'PdfDiv'})
    body = ""
    for para in main_div.find_all('p'):
        body += para.getText() + '\n\n'
        
    return body


#getting title 
def parse_title(html: str) -> str:
    title = html.find(id='Titleh2').getText()
    return title

#getting the time of posting
def parse_date(html: str) -> str:
    date_string_raw = html.find(id='PrDateTime').getText();
    regex_pattern = r'(\d{1,2} [A-Z]{3} \d{4} \d{1,2}:\d{2}[AP]M)'
    date_string = re.search(regex_pattern, date_string_raw).group(0)
    
    return date_string

#get the main image of the post
#standard form of image is: https://static.pib.gov.in/WriteReadData/userfiles/image/

def parse_image(html: str) -> str:
    regex_pattern = r'(https://static\.pib\.gov\.in/WriteReadData/userfiles/image/[A-Za-z0-9_]+\.(?:jpg|jpeg|png))'
    match = re.search(regex_pattern, str(html))     #html was BeautifulSoup type object, converted to string type
    
    if(match):
        image_link = match.group(0)
    else:
        return ""
    
    return image_link