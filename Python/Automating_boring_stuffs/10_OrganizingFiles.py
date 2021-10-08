# -*- coding: utf-8 -*-
"""
Created on Thu Sep 24 18:06:37 2020

@author: murilomendel
"""

# Chapter 10: ORGANIZING FILES
# The shutil module provides functions for copy, move, rename and delete files in the Python program.

import shutil, os
import send2trash
import zipfile
from pathlib import Path

p = Path

# Copying files and folders
# shutil.copy(source, destination) # copy file to another path
# shutil.copytree(source, detination) # copy an entire folder and every folder and file contained in it


# Moving and Renaming Files and Folder
# shutil.move(source, destination) # Move the file or folder

# Permanently Deleting Files and Folders
# os.unlink(path) # Delete the file path
# os.rmdir(path) # Delete the folder at path. This folder must be empty of any files or folders
# os.rmtree(path) # Remove the folder and all files inside it

# send2trash.send2trash(path) # Send folder and file to recycle bin


# Reading zip files
exampleZip = zipfile.ZipFile(Path.cwd() / 'example.zip') # create a zip file

exampleZip.namelist()

readmeInfo = exampleZip.getinfo('readme.txt')
readmeInfo.file_size
readmeInfo.compress_size

exampleZip.close()

# Extracting from zip files
exampleZip = zipfile.ZipFile(Path.cwd() / 'example.zip')
exampleZip.extractall() # Extract all files and folders  into the current folder
exampleZip.extract('example.zip', 'Z:\\some\\new\\folder') # extract to another folder
exampleZip.close()

#Creating and Adding to Zip File
newZip = zipfile.ZipFile(Path.cwd() / 'new.zip', 'w')
newZip.write('readme.txt', compress_type = zipfile.ZIP_DEFLATED)
newZip.close()
