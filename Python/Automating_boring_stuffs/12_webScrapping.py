# -*- coding: utf-8 -*-
"""
Created on Fri Sep 25 19:49:28 2020

@author: murilomendel
"""

# Chapter 12: Web Scraping
# Modules to scrape web pages in Python

import webbrowser
import requests
from pathlib import Path
import bs4
from selenium import webdriver
# webbrowser: opens a browser to a specific page.
# requests: download files and web pages from the internet.
# bs4: Parses HTML.
# selenium: Launches and controls a web browser. This module is able to fill in forms and simulate mouse clicks.


# Project with webbrowser module
webbrowser.open('https://inventwithpython.com/')
# This module do only this


# Downloading Files from web with the requests Module
res = requests.get('https://automatetheboringstuff.com/files/rj.txt')
type(res)
res.status_code == requests.codes.ok
len(res.text)
print(res.text[:250])

# List of HTTP status code
# http://en.wikipedia.org/wiki/List_of_HTTP_status_code

# Trying to open a page that does not exist
res = requests.get('https://inventwithpython.com/page_that_does_not_exist')
try:
    res.raise_for_status()
except Exception as exc:
    print('There was a problem: %s' % (exc))

# Saving Downloaded files to the Hard Drive
res = requests.get('https://automatetheboringstuff.com/files/rj.txt')
res.raise_for_status()
playFile = open(Path.cwd() / 'RomeoAndJuliet.txt', 'wb')
for chunk in res.iter_content(100000):
    playFile.write(chunk)

playFile.close()

# UNICODE ENCODINGS
# https://www.joelonsoftware.com/articles/Unicode.html
# https://nedbatchelder.com/text/unipain.html

# More about request module: https://requests.readthedocs.org/

# HTML (Hypertext Markup Language)

# HTML beginner tutorials:
webbrowser.open('https://developer.mozzilla.org/en-US/learn/html')
webbrowser.open('https://htmldog.com/guides/html/beginner')
webbrowser.open('http://www.codeacademy.com/learn/learn-html')

# BeautifulSoup Module to deal with html pages
res = requests.get('https://nostarch.com')
res.raise_for_status()
noStarchSoup = bs4.BeautifulSoup(res.text, 'html.parser')
type(noStarchSoup)

# CSS selector syntax could be find in the url below
webbrowser.open('https://nostarch.com/automatestuff2/')

exampleFile = open('example.html')
exampleSoup = bs4.BeautifulSoup(exampleFile.read(), 'html.parser')
elems = exampleSoup.select('#author')
type(elems)
len(elems)
type(elems[0])
str(elems[0])
elems[0].getText()
elems[0].attrs

pElems = exampleSoup.select('p')
len(pElems)
str(pElems[0])
pElems[0].getText()
str(pElems[1])
pElems[1].getText()
str(pElems[2])
pElems[2].getText()

# Getting Data from an Element's Attributes
soup = bs4.BeautifulSoup(open('example.html'), 'html.parser')
spanElem = soup.select('span')[0]
str(spanElem)
spanElem.get('id')
spanElem.get('some_nonexistent)addr') == None
spanElem.attrs

# Controlling the Browser with the selenium Module
browser = webdriver.FireFox()
