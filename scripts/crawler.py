from time import sleep
import json
import threading
from pyvirtualdisplay import Display
from selenium import webdriver
from selenium.webdriver.common.by import By

class Crawler:

    def __init__(self, url, credentials):
        self.url = url
        self.credentials = credentials

    def run(self):
        threading.Thread(target=self.worker).start()

    def worker(self):
        options = webdriver.ChromeOptions()
        options.add_argument('user-data-dir=/var/lib/pimaster/scripts/chrome')
        options.add_argument('ignore-certificate-errors')
        options.add_argument('disable-restore-session-state')
        options.add_argument('disable-infobars')
        options.add_argument('disable-session-crashed-bubble')
        options.add_argument('kiosk')
        display = Display(visible=0, size=(800, 800))
        display.start()
        browser = webdriver.Chrome(chrome_options=options)
        browser.set_window_size(1920, 1080)
        try:
            self.sign_in(browser, self.url, self.credentials)
        finally:
            browser.quit()
            display.stop()

    def sign_in(self, browser, url):
        browser.get(url)
        browser.find_element(By.CLASS_NAME, 'btn').click()
        browser.find_element_by_id('identifierId').send_keys(credentials['email'])
        browser.find_element_by_id('identifierNext').click()
        sleep(5)
        browser.find_element_by_name('password').send_keys(credentials['password'])
        browser.find_element_by_id('passwordNext').click()
        sleep(5)
        cookies = browser.get_cookies()

if __name__ == '__main__':
    with open('credentials.json', 'r') as f:
        credentials = json.loads(f.read(f))
    Crawler(credentials['url'], credentials).run()
