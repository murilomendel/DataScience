# -*- coding: utf-8 -*-
"""
Created on Sat Sep 26 17:00:55 2020

@author: murilomendel
"""
# Openning All Search Results

# This is whats the program does:
# 1. Gets search keywords from the command line arguments
# 2. Retrieves the search results page
# 3. Opens the browser tab for each result

# The code will need to do the following
# 1. Read the command line arguments from sys.argv
# 2. Fetch the search result page with the requests module
# 3. Find the links to each search result
# 4. Call the webbbrowser.open() function to open the web browser

import requests
import sys
import webbrowser
import bs4

print('Searching...') # Text displayed while downloading the search result page
res = requests.get('https://google.com/search?q=' 'https://pypi.org/search/?q=' + ' '.join(sys.argv[1:]))
res.raise_for_status()

# Retrieve top search result links.
soup = bs4.BeautifulSoup(res.text, 'html.parser')

# Open a browser tab for each result.
linkElements = soup.select('.package-snippet')
numOpen = min(5, len(linkElements))
for i in range(numOpen):
    urlToOpen = 'https://pypy.org' + linkElements[i].get('href')
    print('Opening', urlToOpen)
    webbrowser.open(urlToOpen)
