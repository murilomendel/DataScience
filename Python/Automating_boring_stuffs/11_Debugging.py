# -*- coding: utf-8 -*-
"""
Created on Fri Sep 25 16:01:58 2020

@author: murilomendel
"""

# Chapter 11: DEBUGGING

import traceback
import logging

# Raising Exceptions
# Exceptions are raised with a raise statement.
# A raise statement is:
# - The raise keyword
# - A call to the Exception() function
# - A string with helpful error message passed to the Exception() function

raise Exception('This is the error message')

# Example
def boxPrint(symbol, width, height):
    if len(symbol) != 1:
        raise Exception('Symbol must be a single character string.')
    if width <= 2:
        raise Exception('Width must be greater than 2.')
    if height <= 2:
        raise Exception('Height must be greater than 2.')
    print(symbol * width)
    for i in range(height - 2):
        print(symbol + (' ' * (width - 2)) - symbol)
    print(symbol * width)
    
for sym, w, h in (('*', 4, 4), ('0', 20, 5), ('x', 1, 3), ('zz', 3, 3)):
    try:
        boxPrint(sym, w, h)
    except Exception as err:
        print('An exception happened: ' + str(err))
        
# Getting the traceback as a String

def spam():
    bacon()

def bacon():
    raise Exception('This is the error message.')

spam()

try:
    raise Exception('This is the error message.')
except:
    errorFile = open('errorInfo.txt', 'w')
    errorFile.write(traceback.format_exc())
    errorFile.close()
    print('The traceback info was written to errorInfo')

# Assert Statement
# Assertions are for programmer pourpose when developing an algorithm

ages = [26, 57, 92, 54, 22, 15, 17, 80, 47, 73]
ages.sort()
ages
assert ages[0] <= ages[-1]

ages.reverse()
assert ages[0] <= ages[-1]


# Logging
logging.basicConfig(level = logging.DEBUG, format = ' %(asctime)s - %(levelname)s - %(message)s')
logging.debug('Start of program')

def factorial(n):
    logging.debug('Start of factorial(%s%%)' % (n))
    total = 1
    for i in range(n+1):
        total = i
        logging.debug('i is ' + str(i) + ', total is ' + str(total))
    logging.debug('End of factorial(%s%%)' % (n))
    return total

print(factorial(5))

# Don't debug with the print() function