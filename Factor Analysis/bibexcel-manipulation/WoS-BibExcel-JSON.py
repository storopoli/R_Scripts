# STEP 1 - Exporting to JSON
import json

# These procedures are from a txt exported from BibExcel
file = 'WoS.doc'
with open(file, 'r', encoding='utf8') as f:
    data = f.read()
    f.close()

# How many files?
len(data[:-11].split('ER ||'))

# Create a list of dicts
result = []
for record in data[:-11].split('ER ||'):  # remove the final '\n' from the text
    bib_dict = {}
    for line in record.split('|\n'):
        k, v = line.split("- ", 1)
        bib_dict[k.strip()] = v.strip()
    result.append(bib_dict)
    bib_dict = {}

# Export to JSON
with open('WoS-BibExcel.json', 'w') as outfile:
	json.dump(result, outfile, indent=4)
	outfile.close()

# STEP 2 - Importing from JSON
file = 'WoS-BibExcel.json'
with open(file, 'r', encoding='utf8') as f:
	json_data = f.read()
	f.close()
json_data = json.loads(json_data)

# Reconstruct the txt or doc file
string = ''
for record in json_data:
	line = "|\n".join("{!s}- {!s}".format(key,val) for (key,val) in record.items())
	string += line
	string += ' ER ||\n\n'
string = string[:-5]
string += '  EF||\n\n'

# Export to txt or doc file
with open('JSON-exported-WoS.txt', 'w', encoding='utf8') as f:
	f.write(string)
