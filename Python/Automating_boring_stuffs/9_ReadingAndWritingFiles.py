# -*- coding: utf-8 -*-
"""
Created on Wed Sep 23 14:46:48 2020

@author: murilomendel
"""
# Chapter 9: READING AND WRITING FILES
# Windows: paths are written using backslashes(\)
# Linux and MAC: paths are written using forwardslashes(/)

from pathlib import Path
import os
import shelve

# Example using Path
Path('spam', 'bacon', 'eggs')
str(Path('spam', 'bacon', 'eggs'))

myFiles = ['accounts.txt', 'details.txt', 'invite.docx']
for filename in myFiles:
    print(Path(r'C:\Users\muril', filename))

# Joining Paths
Path('spam') / 'bacon' / 'eggs'   
Path('spam') / Path('bacon/eggs')
Path('spam') / Path('bacon', 'eggs')


homeFolder = Path('C:/Users/muril')
subFolder = Path('spam')
homeFolder / subFolder
str(homeFolder / subFolder)

# The current working directory
Path.cwd() # Getting current Working Directory
os.chdir('C:/Users/muril/Documents/_projects/DataScience/Python/Automating_boring_stuffs') # Setting Working Directory
Path.cwd()

# The Home Directory
Path.home()

# Absolute Path: begins with the root folder
# Relative Path: relative to the program's current working directory
# .\ Means the current folder
# ..\ Means the parent folder

# Creating new folder
os.makedirs('./figs')
Path(r'./data').mkdir()

# Handling Absolute and Relative Paths
Path.cwd().is_absolute()

# Extra
# os.abspath(path): return a string for the absolute path of the argument.
# os.path.isabs(path): return True if the argument is an absolut path.
# os.path.relpath(path, start): return a relative path string from start path to path arguments.

os.path.relpath('C:\\Users', 'C://Users//muril//Documents')

# Parts of a file path
# Anchor: is the root folder of the filesystem
# Drive: On windows, it is the single letter which denotes the physical hard drive or other storage device
# Parent: it is the folder that contains the file
# Name: base name + sulfix

p = Path.cwd() / 'readme.txt'
p.anchor
p.parent
p.name
p.stem
p.suffix
p.drive

# Backward to parents folders
Path.cwd().parents[0]
Path.cwd().parents[1]

# Some tricks on os library
os.path.basename(p)
os.path.dirname(p)
os.path.split(p)

# Splitting folders
pa = str(Path.cwd() / 'readme.txt')
pa.split(os.sep)

# Finding File Sizes and Folder Contents
pa = str(Path.cwd() / '7_RegularExpressions.ipynb')
os.path.getsize(pa) # file size in bytes
os.listdir(str(Path.cwd())) # list directory folders and files

# Calculating the folder total size
totalSize = 0
for filename in os.listdir(str(Path.cwd())):
    totalSize += os.path.getsize(os.path.join(str(Path.cwd()), filename))
print(totalSize)

# Modifying a list of files using Glob Patterns
pat = Path.cwd()
pat.glob('*')
list(pat.glob('*.py'))
list(pat.glob('project?.docx')) # Only an example

# Checking Path Validity
p.exists()
p.is_file()
p.is_dir()

# File Reading and Writing Processes
p = Path('test.txt')
p.write_text('Hello,\n world!')
p.read_text()

# Openig Files
testFile = open(Path.cwd() / p)
testFile.read() # Read the contents of the file object
testFile.readlines() # Return a list of lines

# Writing content to a file
testFile = open('test.txt', 'w') # write or overwrite if the file already has a content
testFile.write('Bye Bye, World!\n')
testFile.close()
testFile = open('test.txt', 'a') # oppen in append mode
testFile.write('Bacon is not a Vegetable')
testFile.close()
testFile = open('test.txt')
content = testFile.read()
testFile.close()
print(content)
content

# Saving variable with the shelve module
shelfFile = shelve.open('myData') # binary shelf file
cats = ['Zophie', 'Pooka', 'Simon']
shelfFile['cats'] = cats
shelfFile.close()
