import json
import pandas as pd

# Importing JSON to Excel
# load JSON file
file = 'scopus-BibExcel.json'
with open(file, 'r', encoding = 'utf8') as f:
    json_data = f.read()
    f.close()
json_data = json.loads(json_data)

# json_data is a list of dicts
# creating a dataframe from it
df = pd.DataFrame(json_data)
df.index += 1   # if you want to have the index starting in 1 instead of 0

# If you want to have the index displaying bc##
df = df.set_index('bc' + df.index.astype(str))
df.to_excel("sample.xlsx")