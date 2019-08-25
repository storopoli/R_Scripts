import pandas as pd

# Import Adjacency Matrix
df = pd.read_csv('/Users/storopoli/Google Drive/Artigos/Bibliométrico - Retenção/pareamento/adjacency_matrix.csv', sep=',', 
                 index_col=0)
df.shape

# get indexes and strip "bc###" to number ###
var_names = df.index.tolist()
var_ids = list(map(lambda sub:int(''.join( [ele for ele in sub if ele.isnumeric()])), var_names))

# get the list of dict from WoS-BibExcel-JSON.py or scopus-BibExcel-JSON.py
# get a list of dict only for the indexes desired as IDs in var_ids
result = [result[i] for i in var_ids]

# Check Length
len(result)