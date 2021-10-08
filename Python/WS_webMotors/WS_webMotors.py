# -*- coding: utf-8 -*-
"""
Created on Sat Sep 26 17:47:41 2020

@author: murilomendel
"""
import requests
import bs4 as BeautifulSoup

# Project: Webmotors web scrapping

carMake = 'honda'
carModel = 'civic'
# check your User-Agent information: https://www.whatsmyua.info/
headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36'}
url = 'https://www.webmotors.com.br/carros/estoque/' + carMake + '/' + carModel

req = requests.get(url, headers=headers)
req.raise_for_status()

soup = BeautifulSoup(req.text, 'html.parser')
print(soup.prettify())

list(soup.children)
[type(item) for item in list(soup.children)]

# getting html tag
html = list(soup.children)[2]
[type(item) for item in list(html.children)]
print(html.prettify())

# getting body tag
body = list(html.children)[3]
[type(item) for item in list(body.children)]
list(body.children)

# getting div tag
div = list(body.children)[1]
list(div.children)

# MAYBE THE PAGE IS JAVASCRIPT RENDERED: NEED TO USE SELENIUM



soup.find_all('div', class_="Found")
print(soup)
print(soup.prettify())
divs = soup.select('div ', class_="FoundCars")

len(divs)
print(divs[0])
foundCars = soup.select('.title-search .FoundCars')

print(foundCars)
req.headers