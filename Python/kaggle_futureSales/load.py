# -*- coding: utf-8 -*-
"""
Editor Spyder

This script was developed to load csv files, create the properly data frames
for future feature engineering and data wrangling
"""

import pandas as pd
import numpy as np
import os
from googletrans import Translator
import seaborn as sns
import matplotlib as mtp
import sklearn
# Setting data path
dir_path = os.getcwd()
train_path = dir_path + '\data\\sales_train.csv'
test_path = dir_path + '\data\\test.csv'
item_path = dir_path + '\data\\items.csv'
shop_path = dir_path + '\data\\shops.csv'
itemCTG_path = dir_path + '\data\\item_categories.csv'


# Reading Data
train_df = pd.read_csv(train_path)
test_df = pd.read_csv(test_path)
item = pd.read_csv(item_path)
shop = pd.read_csv(shop_path)
itemCategory = pd.read_csv(itemCTG_path)


# Studying data frames
# Item Category Data Frame
itemCategory.head()
translator = Translator()

itemCategory_en = itemCategory.copy() #Deep copy of the data frame

trs = translator.translate(itemCategory['item_category_name'][1], dest = 'en', src = 'auto')
itemCategory['item_category_name_en'] = translator.translate(itemCategory['item_category_name'], dest = 'en', src = 'auto').text
trs.text
a = trs.text


print(pd.__version__)
print(np.__version__)
print(sns.__version__)
print(mtp.__version__)
print(sklearn.__version__)
