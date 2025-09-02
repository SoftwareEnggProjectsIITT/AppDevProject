from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
import time
from bs4 import BeautifulSoup
import regex as re
from modules.constants import PIB_CATEGORIES


def get_ids_by_categories(day_value: str) -> dict[str, list[int]]:
    # Launch browser
    driver = webdriver.Chrome()

    driver.get("https://www.pib.gov.in/allRel.aspx")

    # Find the <select> element (by ID in your screenshot)
    dropdown = Select(driver.find_element(By.ID, "ContentPlaceHolder1_ddlday"))

    # Change the value to whatever date you want to retrieve
    dropdown.select_by_value(day_value)

    # Wait a bit for page to reload after onchange
    time.sleep(2)

    #extracting all the links that we found on the webpage
    soup = BeautifulSoup(driver.page_source[:], "html.parser")

    #dictionary ans
    ans = {}

    #soup is given
    for category in PIB_CATEGORIES:
        header = soup.find("h3", class_="font104", string=category)
    
        ids = []    
        if header:
            ul = header.find_next("ul", class_="num")
            if ul:
                for a in ul.find_all("a", href=True):
                    link_text = str(a['href'])
                    id = re.search(r'PRID=(\d+)', link_text).group(1)
                    ids.append(int(id))
                
        ans[category] = ids


    driver.quit()
        
    return ans