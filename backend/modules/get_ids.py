from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
import time
from bs4 import BeautifulSoup
import regex as re


def get_ids(day_value: str) -> list[int]:
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

    list = []
        

    for link in soup.find_all("a"):
        href = link.get('href')
        if href.startswith("/PressReleasePage.aspx?PRID="):
            id = re.search(r'PRID=(\d+)', href).group(1)    #catching from the first group
            list.append(int(id))    #we have to return list of integers


    driver.quit()
        
    return list