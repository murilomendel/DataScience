# -*- coding: utf-8 -*-
"""
Created on Tue Sep 22 15:14:05 2020

@author: murilomendel
"""

# INPUT VALIDATION
# https://pyinputplus.readthedocs.io/
import pyinputplus as pyip

response = pyip.inputNum()

response = input('Enter a number:') # Response is a String
response = pyip.inputInt(prompt='Enter a number:') # Response is a Integer

# min, max, lessThan, greaterThan Keyword Arguments
response = pyip.inputNum('Enter a number:', min = 4)
response = pyip.inputNum('Enter a number:', greaterThan=4)
response = pyip.inputNum('>', min=4, lessThan=6)

# Blank Keyword Argument
response = pyip.inputNum('Enter a number: ', blank=True) # Make Input Optional

# limit, timeout, default Keyword Arguments
response = pyip.inputNum(limit=2) # Maximum two input tries
response = pyip.inputNum(timeout=10) # Maximum 10 seconds to input
response = pyip.inputNum(limit=2, default='N/A') # Default input value

# allowRegexes, blockRegexes Keyword Arguments
response = pyip.inputNum(allowRegexes=[r'(I|V|X|L|C|D|M)+', r'zero']) # Romans numbers
response = pyip.inputNum(blockRegexes=[r'[02468]$']) # odd numbers
# alloRegexes overrides blockRegexes
response = pyip.inputStr(allowRegexes=[r'caterpillar', 'category'], blockRegexes=[r'cat'])

# Passing a custom validation function to inputCustom()
# We want the user to pass a series of digits that adds up to 10.
def addsUpToTen(numbers):
    numberList = list(numbers)
    for i, digit in enumerate(numberList):
        numberList[i] = int(digit)
    if sum(numberList) != 10:
        raise Exception('The digits must add up to 10, not %s.' %(sum(numberList)))
    return int(numbers)

response = pyip.inputCustom(addsUpToTen)
