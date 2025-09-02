import requests
from bs4 import BeautifulSoup
from playwright.sync_api import sync_playwright


def get_tweet_image_from_pib(id: int) -> str | None:
    """
    Given a PIB press release URL, extract the first image URL from an embedded Twitter post.
    Returns:
        - str: Direct image URL if found
        - None: If no tweet or image is found
    """
    # Step 1: Fetch PIB page
    base_url = 'https://www.pib.gov.in/PressReleasePage.aspx?PRID='
    pib_url = base_url + str(id)
    
    try:
        res = requests.get(pib_url, timeout=15)
        res.raise_for_status()
    except requests.RequestException:
        return None

    soup = BeautifulSoup(res.text, "html.parser")

    # Step 2: Extract tweet links
    all_links = [a.get("href") for a in soup.select("blockquote.twitter-tweet a[href]")]
    tweet_links = [link for link in all_links if link and "status" in link]

    if not tweet_links:
        return None  # No Twitter post found

    tweet_url = tweet_links[0]

    # Step 3: Use Playwright to load tweet and extract image
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        try:
            page.goto(tweet_url, timeout=60000)
            page.wait_for_selector("img", timeout=15000)
        except Exception:
            browser.close()
            return None

        # Get all image URLs
        image_urls = page.evaluate(
            "() => Array.from(document.querySelectorAll('img')).map(img => img.src)"
        )
        browser.close()

    # Step 4: Filter out profile pictures/icons
    filtered_images = [url for url in image_urls if not "profile_images" in url]

    if not filtered_images:
        return None

    return filtered_images[0]



