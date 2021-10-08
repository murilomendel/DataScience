# -*- coding: utf-8 -*-
"""
Created on Sun Sep 27 20:12:53 2020

@author: muril
"""


import requests
from bs4 import BeautifulSoup

page = requests.get('http://dataquestio.github.io/web-scraping-pages/simple.html')
page # Request Response status
page.content # Page content

soup = BeautifulSoup(page.content, 'html.parser')
print(soup.prettify())

list(soup.children)
[type(item) for item in list(soup.children)] # Check lis item types
# Tag object is the most important which one we will work the most
# Tag object permits us to navigate over HTML document
html = list(soup.children)[2] # Selecting Tag object


