# -*- coding: utf-8 -*-
"""
Created on Fri Jul  3 18:59:06 2020

@author: muril
"""


import sklearn.datasets as datasets
import pandas as pd
from sklearn.tree import DecisionTreeClassifier
from sklearn.externals.six import StringIO  
from IPython.display import Image  
from sklearn.tree import export_graphviz 
import pydotplus

# Loading Data
iris = datasets.load_iris()
df = pd.DataFrame(iris.data, columns=iris.feature_names)
y = iris.target


# Fitting a Decision Tree Classifier
dtree = DecisionTreeClassifier()
dtree.fit(df, y) 

# Creating a Decision Tree Vizualization

dot_data = StringIO()

export_graphviz(dtree, out_file=dot_data,
                filled=True, rounded = True,
                special_characters=True)

graph = pydotplus.graph_from_dot_data(dot_data.getvalue())
Image(graph.create_png())
