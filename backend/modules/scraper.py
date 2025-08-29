import requests
from bs4 import BeautifulSoup

#returns the html of the entire webpage when id of the post is given
def fetch_page(id: int):

    response = requests.get('https://www.pib.gov.in/PressReleasePage.aspx?PRID=' + str(id))    
    soup = BeautifulSoup(response.text, 'html.parser')
    
    return soup