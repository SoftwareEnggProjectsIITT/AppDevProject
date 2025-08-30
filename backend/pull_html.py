import requests
from bs4 import BeautifulSoup


response = requests.get('https://www.pib.gov.in/PressReleasePage.aspx?PRID=2161649')    
soup = BeautifulSoup(response.text, 'html.parser')

with open('output.txt', 'w', encoding='utf-8') as f:
    f.write(str(soup))