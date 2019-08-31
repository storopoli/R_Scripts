# file_txt must be utf-8 enconding
file_txt = 'bruto.txt'

# Open file
with open(file_txt, 'r', encoding='utf8') as f:
    data = f.read()
    f.close()

# Do the replacement in citations
correct = "XXX"
wrong = [
    "YYY",
    "ZZZ"
]
for item in wrong:
    data = data.replace(item, correct)


with open('bruto-limpo.txt', 'w', encoding='utf8') as f:
    f.write(data)
