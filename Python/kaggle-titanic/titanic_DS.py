import numpy as np
import pandas as pd
import os
pd.plotting.register_matplotlib_converters()
pd.set_option('display.max_columns', None)
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.linear_model import LinearRegression
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC, LinearSVC
from sklearn.ensemble import RandomForestClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.linear_model import Perceptron
from sklearn.linear_model import SGDClassifier
from sklearn.tree import DecisionTreeClassifier

dir_path = os.getcwd()
train_path = dir_path + "\\train.csv"
test_path = dir_path + "\\test.csv"


# Reading Data
train_df = pd.read_csv(train_path) # Load Train DataFrame
test_df = pd.read_csv(test_path) # Load Testing DataFrame
combine = [train_df, test_df] # Variable to manipulate both DataFrames


# Commands to examine Data Frame
train_df.head() # Vizualização dos 5 primeiros arquivos do DataFrame
train_df.tail() # Vizualização dos 5 últimos arquivos do DataFrame
train_df.info() # Informações sobre colunas, Quantidade de valores não nulos e tipo de dado de cada coluna
test_df.info() # Informações sobre colunas, Quantidade de valores não nulos e tipo de dado de cada coluna
train_df.describe() # Descrições estatísticas das variáveis contínuas
train_df.describe(include = ['O']) # Descrição de variaveis do tipo Objeto


# Get list of categorical variables
s = (train_df.dtypes == 'object')
object_cols = list(s[s].index)
print("Categorical variables:", object_cols)


#Checking number of Null entries
missing_val_count_by_column = (train_df.isnull().sum())
print(missing_val_count_by_column[missing_val_count_by_column > 0])


# Ditribution of Survivers by features
train_df[['Sex','Survived']].groupby(['Sex'], as_index = False).mean().sort_values(by='Survived', ascending = False)
train_df[['Pclass','Survived']].groupby(['Pclass'], as_index = False).mean().sort_values(by='Survived', ascending = False)
train_df[['Pclass','Survived']].groupby(['Pclass'], as_index = False).count()#.sort_values(by='Survived', ascending = False)
train_df[['SibSp','Survived']].groupby(['SibSp'], as_index = False).mean().sort_values(by='Survived', ascending = False)
train_df[['Parch','Survived']].groupby(['Parch'], as_index = False).mean().sort_values(by='Survived', ascending = False)
train_df[['Embarked','Survived']].groupby(['Embarked'], as_index = False).mean().sort_values(by='Survived', ascending = False)


# Plotting
sns.distplot(train_df['Age']) # Age Distribution
#sns.distplot(test_df['Age']) # Age Distribution

plt.title("Age Distribution") # Chart Title
plt.axvline(x = 30, color = "purple") # Chart Vertical line at x = 30
plt.xlabel('Age') # X Axis Title
plt.ylabel('Density') # Y Axis Title


# Studying Age Ditribution over Pclass and Sex
g = sns.FacetGrid(train_df, row = "Pclass", col = "Sex", size = 2.2 ,aspect = 1.6)
g.map(plt.hist, 'Age', alpha = .5, bins = 20) # Plotting histogram
g.add_legend() # Adicionar Legenda (3 variáveis)


# Filling missing Ages
# Checking Passengers with Null Age values before completing
Passengers_ID = train_df[(train_df["Age"].isnull())]["PassengerId"]
Age_Null_rows = train_df[(train_df["Age"].isnull())][["PassengerId","Age"]]
Age_Null_rows


#Defining Median Vector
age_median_tr = np.zeros((2,3))
age_median_te = np.zeros((2,3))


# Getting Median for Sex and PClass Combination
for i in ['male', 'female']:
    for j in range(1,4):
        #List of Ages for i and j
        guess_train = train_df[(train_df["Sex"] == i) & (train_df["Pclass"] == j)]["Age"].dropna()
        guess_test = test_df[(test_df["Sex"] == i) & (test_df["Pclass"] == j)]["Age"].dropna()
        
        #Saving median
        if i == 'male':
            age_median_tr[0,j-1] = int(round(guess_train.median()))
            age_median_te[0,j-1] = int(round(guess_test.median()))
        else:
            age_median_tr[1,j-1] = int(round(guess_train.median()))
            age_median_te[1,j-1] = int(round(guess_train.median()))
            
#age_median_tr
#age_median_te

# Replacing values
for i in ['male', 'female']:
    for j in range(1,4):
        if i == 'male':
            train_df.loc[(train_df['Age'].isnull()) & (train_df['Sex'] == i) & (train_df["Pclass"] == j), 'Age'] = age_median_tr[0,j-1]
            test_df.loc[(test_df['Age'].isnull()) & (test_df['Sex'] == i) & (test_df["Pclass"] == j), 'Age'] = age_median_te[0,j-1]
        else:
            train_df.loc[(train_df['Age'].isnull()) & (train_df['Sex'] == i) & (train_df["Pclass"] == j), 'Age'] = age_median_tr[1,j-1]
            test_df.loc[(test_df['Age'].isnull()) & (test_df['Sex'] == i) & (test_df["Pclass"] == j), 'Age'] = age_median_te[1,j-1]
            
train_df['Age'] = train_df['Age'].astype(int)
test_df['Age'] = test_df['Age'].astype(int)


# Checking Passengers with Null Age completed
train_df.loc[Passengers_ID, "Age"]


# Converting Age feature from categorical to numerical
for dataset in combine:
    dataset['Sex'] = dataset['Sex'].map( {'female': 1, 'male': 0} ).astype(int)


# Studyin [Pclass, Sex] distribution over Survivals
sMan_3 = train_df[(train_df["Pclass"] == 3) & (train_df["Sex"] == 'male')]["Survived"].sum()
sMan_2 = train_df[(train_df["Pclass"] == 2) & (train_df["Sex"] == 'male')]["Survived"].sum()
sMan_1 = train_df[(train_df["Pclass"] == 1) & (train_df["Sex"] == 'male')]["Survived"].sum()
sWoman_1 = train_df[(train_df["Pclass"] == 1) & (train_df["Sex"] == 'female')]["Survived"].sum()
sWoman_2 = train_df[(train_df["Pclass"] == 2) & (train_df["Sex"] == 'female')]["Survived"].sum()
sWoman_3 = train_df[(train_df["Pclass"] == 3) & (train_df["Sex"] == 'female')]["Survived"].sum()
tMan_3 = train_df[(train_df["Pclass"] == 3) & (train_df["Sex"] == 'male')]["Survived"].count()
tMan_2 = train_df[(train_df["Pclass"] == 2) & (train_df["Sex"] == 'male')]["Survived"].count()
tMan_1 = train_df[(train_df["Pclass"] == 1) & (train_df["Sex"] == 'male')]["Survived"].count()
tWoman_1 = train_df[(train_df["Pclass"] == 1) & (train_df["Sex"] == 'female')]["Survived"].count()
tWoman_2 = train_df[(train_df["Pclass"] == 2) & (train_df["Sex"] == 'female')]["Survived"].count()
tWoman_3 = train_df[(train_df["Pclass"] == 3) & (train_df["Sex"] == 'female')]["Survived"].count()

sv = pd.DataFrame([[sMan_1, tMan_1, (sMan_1/tMan_1), sWoman_1, tWoman_1, (sWoman_1/tWoman_1)],[sMan_2, tMan_2, (sMan_2/tMan_2), sWoman_2, tWoman_2, (sWoman_2/tWoman_2)],[sMan_3, tMan_3, (sMan_3/tMan_3), sWoman_3, tWoman_3, (sWoman_3/tWoman_3)]],
                  index = ['1st Class', '2nd Class', '3rd Class'],
                  columns = ['Man Survived', 'Total Man', 'Survival Rate', 'Woman Survived', 'Total Woman','Survival Rate'])


# Studying Parch data over survivals
f = train_df[['Parch', 'Survived']].groupby(['Parch'], as_index = False).mean().sort_values(by = 'Survived', ascending = False)
ch = pd.Series(f.Parch)
sns.barplot(x = 'Parch', y = 'Survived', data = train_df, order = ch)

 
# Creating new feature called shortFamily to substitute Parch AND SibSp
for df in [train_df, test_df]:
    df['shortFamily'] = 0
    df.loc[((df['Parch'] <= 3) & (df['SibSp'] <= 2)), 'shortFamily'] = 1
    
sns.barplot(x = 'shortFamily', y = 'Survived', data = train_df)


# Survivals over Embarked place
train_df[['Embarked', 'Survived']].groupby(['Embarked'], as_index = False).mean().sort_values(by = 'Survived', ascending = False)

# Plotting
f = train_df[['Embarked', 'Survived']].groupby(['Embarked'], as_index = False).mean().sort_values(by = 'Survived', ascending = False)
ch = pd.Series(f.Embarked)
sns.barplot(x = 'Embarked', y = 'Survived', data = train_df, order = ch)

grid = sns.FacetGrid(train_df, col='Embarked')
grid.map(sns.pointplot, 'Pclass', 'Survived', 'Sex', palette='deep')
grid.add_legend()

# Filling NA Embarked Feature
train_df.loc[train_df['Embarked'].isnull(), 'Embarked'] = 'Q'
    
train_df[['Embarked', 'Survived']].groupby(['Embarked'], as_index=False).mean().sort_values(by='Survived', ascending=False)

# Converting Embarked Feature to numerical variable
for dataset in combine:
    dataset['Embarked'] = dataset['Embarked'].map( {'S': 0, 'C': 1, 'Q': 2} ).astype(int)

sns.barplot(x = 'Survived', y = 'Fare', data = train_df)


# Classify Passenger Fare band
train_df['FareBand'] = pd.qcut(train_df['Fare'], 4)
train_df[['FareBand', 'Survived']].groupby(['FareBand'], as_index=False).mean().sort_values(by='FareBand', ascending=True)


# Checking passenger wich fare information is missing
test_df.loc[test_df['Fare'].isnull(), 'Fare'] = 12.5 

grid = sns.FacetGrid(train_df, row='Embarked', col='Pclass', size=2.2, aspect=1.6)
grid.map(sns.barplot, 'Sex', 'Fare', alpha=.5, ci=None)
grid.add_legend()


# Creating categories from fare bands
test_df.loc[test_df['Fare'].isnull(), 'Fare'] = 12.5 
for df in [train_df, test_df]:
    df.loc[df['Fare'] <= 7.91, 'Fare'] = 0
    df.loc[(df['Fare'] > 7.91) & (df['Fare'] <= 14.454), 'Fare'] = 1
    df.loc[(df['Fare'] > 14.454) & (df['Fare'] <= 31), 'Fare']   = 2
    df.loc[ df['Fare'] > 31, 'Fare'] = 3
    df['Fare'] = df['Fare'].astype(int)
 
# 
sns.barplot(x = 'Embarked', y = 'Fare', data = train_df[(train_df['Sex'] == 1) & (train_df['Pclass'] == 1) & (train_df['shortFamily'] == 1)& (train_df['Survived'] == 1)])

test_df['Fare'].fillna(test_df['Fare'].dropna().median(), inplace=True)


# Drop Unuseful features
train_df = train_df.drop(['Name','Ticket','Cabin', 'Parch', 'SibSp', 'FareBand'], axis = 1)
test_df = test_df.drop(['Name', 'Ticket','Cabin', 'Parch', 'SibSp'], axis = 1)
test_df.head()
train_df.head()


# MODELLING
# Subsetting train and test data
X_train = train_df.drop(["Survived", "PassengerId"], axis = 1)
Y_train = train_df["Survived"]
X_test = test_df.drop("PassengerId", axis = 1)
X_train.shape, Y_train.shape, X_test.shape
X_train.head()
X_test.head()

# Linear Regression
linreg = LinearRegression()
linreg.fit(X_train, Y_train)
Y_pred = linreg.predict(X_test)
acc_log = round(linreg.score(X_train, Y_train) * 100, 2)
acc_log


# Logistic Regression
logreg = LogisticRegression()
logreg.fit(X_train, Y_train)
Y_pred = logreg.predict(X_test)
acc_log = round(logreg.score(X_train, Y_train) * 100, 2)
acc_log

# Support Vector Machine
svc = SVC()
svc.fit(X_train, Y_train)
Y_pred = svc.predict(X_test)
acc_svc = round(svc.score(X_train, Y_train) * 100, 2)
acc_svc

# KNN
knn = KNeighborsClassifier(n_neighbors = 3)
knn.fit(X_train, Y_train)
Y_pred = knn.predict(X_test)
acc_knn = round(knn.score(X_train, Y_train) * 100, 2)
acc_knn

# Gaussian
gaussian = GaussianNB()
gaussian.fit(X_train, Y_train)
Y_pred = gaussian.predict(X_test)
acc_gaussian = round(gaussian.score(X_train, Y_train) * 100, 2)
acc_gaussian

# Perceptron
perceptron = Perceptron()
perceptron.fit(X_train, Y_train)
Y_pred = perceptron.predict(X_test)
acc_perceptron = round(perceptron.score(X_train, Y_train) * 100, 2)
acc_perceptron

# Linear SVC
linear_svc = LinearSVC()
linear_svc.fit(X_train, Y_train)
Y_pred = linear_svc.predict(X_test)
acc_linear_svc = round(linear_svc.score(X_train, Y_train) * 100, 2)
acc_linear_svc

# Stochastic Gradient Descent