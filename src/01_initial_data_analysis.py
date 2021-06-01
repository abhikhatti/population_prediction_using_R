import pandas as pd
import numpy as np
import os
import matplotlib.pyplot as plt
import sklearn

pd.options.display.max_columns = 30
pd.options.display.max_rows = 100
pd.options.display.width = 2000
pd.options.display.float_format = '{:.5f}'.format

# Import data

dir_path = os.path.join(os.path.pardir, "data", "interim")
train_file = os.path.join(dir_path, "population.csv")

train_df = pd.read_csv(train_file)

# print(train_df[train_df.isnull()])
# print(train_df.iloc[:-6, :].describe())
# train_df.set_index("Geographic Area")

# print(train_df.info())
# print(train_df[train_df["Geographic Area"] == "Alabama"])

# plt.show(train_df.iloc[:-6, :].groupby("Geographic Area").median().nlargest(5, "Y2016").plot(kind="bar"))
# print(train_df.head())

########## Feature Engineering - Part 1 ##########

# Change Feature name to smaller name
train_df["Area"] = train_df["Geographic Area"]
plt.show(train_df.groupby("Area").boxplot())
from sklearn.preprocessing import StandardScaler

scalar = StandardScaler()



