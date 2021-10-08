# -*- coding: utf-8 -*-
"""
Created on Mon Sep 21 22:08:52 2020

@author: murilomendel
"""
# phoneAndEmail.py - Finds phone numbers and e-mail adresses on the clipboard

# PROJECT: Phone Number and Email Address Extractor

import pyperclip, re

phoneRegex = re.compile(r'''(
    \(?(\+\d?-?\d{2,3})\)? # Country Code
    (\s|-|\.)?             # Separator
    ([0]?\d{2})?           # Area Code
    (\s|-|\.)?             # Separator
    (\d{4,5})                # First four phone digits
    (-)?                   # Separator
    (\d{4})                # Fina four phone digits
    )''', re.VERBOSE)
phoneRegex.search('+55 011 4544-4852').group()

emailRegex = re.compile(r'''(
    ([a-zA-Z0-9._%+-])+ # username
    (@)                 # @ symbol
    ([a-zA-Z0-9.-])+    # domain
    (\.com)             # .com
    )''', re.VERBOSE)
emailRegex.search('murilomendel@hotmail.com').group(1)
