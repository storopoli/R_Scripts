#!/usr/bin/env python


def bibexceltojson(input_name=None, type=None, encoding='utf8', output_name=None):
    """
    This function will import a BibExcel generated .doc or .txt file
    and will return a JSON file
    """

    import json
    with open(input_name, 'r', encoding=encoding) as f:
        data = f.read()
        f.close()
    # Create a list of dicts
    result = []
    # Scopus
    if type == 'scopus':
        # remove the final '\n' from the text
        for record in data[:-2].split("||"):
            bib_dict = {}
            for line in record.split('|\n'):
                k, v = line.split("- ", 1)
                bib_dict[k.strip()] = v.strip()
            result.append(bib_dict)
            bib_dict = {}
    # WoS
    if type == 'wos':
        # remove the final '\n' from the text
        for record in data[:-11].split('ER ||'):
            bib_dict = {}
            for line in record.split('|\n'):
                k, v = line.split("- ", 1)
                bib_dict[k.strip()] = v.strip()
            result.append(bib_dict)
            bib_dict = {}
    with open(output_name, 'w') as outfile:
        json.dump(result, outfile, indent=4)
        outfile.close()
    print('Export to JSON complete.')


def jsontobibexcel(input_name=None, type=None, encoding='utf8', output_name=None):
    """
    This function will import a BibExcel generated .doc or .txt file
    and will return a JSON file
    """

    import json
    with open(input_name, 'r', encoding=encoding) as f:
        json_data = f.read()
        f.close()
    json_data = json.loads(json_data)
    # Reconstruct the txt or doc file
    string = ''
    # Scopus
    if type == 'scopus':
        for record in json_data:
            line = "|\n".join("{!s}- {!s}".format(key, val) for (key, val) in record.items())
            string += line
            string += '||'
        string = string[:-1]
        string += '\n'
    if type == 'wos':
        for record in json_data:
            line = "|\n".join("{!s}- {!s}".format(key, val) for (key, val) in record.items())
            string += line
            string += ' ER ||\n\n'
        string = string[:-5]
        string += '  EF||\n\n'

    # Export to txt or doc file
    with open(output_name, 'w', encoding='utf8') as f:
        f.write(string)
    print('Export to BibExcel complete.')


def filtercoupling(input_matrix=None, input_json=None, type=None, encoding='utf8', output_name=None):
    """
    This function will filter a JSON file exported from BibExcel and
    filter the desired list of articles from an adjacency matrix generated
    from R or Python igraph package.
    The CSV file must be with separator as commas (,)
    The output is a filtered JSON file
    """
    import pandas as pd
    import json

    # Import Adjacency Matrix
    df = pd.read_csv(input_matrix, sep=',', index_col=0)

    # get indexes and strip "bc###" to number ###
    var_names = df.index.tolist()
    var_ids = list(map(lambda sub: int(''.join([ele for ele in sub if ele.isnumeric()])), var_names))

    # load JSON file
    with open(input_json, 'r', encoding=encoding) as f:
        json_data = f.read()
        f.close()
    json_data = json.loads(json_data)
    result = [json_data[i - 1] for i in var_ids]

    # Reconstruct the txt or doc file
    string = ''
    # Scopus
    if type == 'scopus':
        for record in result:
            line = "|\n".join("{!s}- {!s}".format(key, val) for (key, val) in record.items())
            string += line
            string += '||'
        string = string[:-1]
        string += '\n'
    if type == 'wos':
        for record in result:
            line = "|\n".join("{!s}- {!s}".format(key, val) for (key, val) in record.items())
            string += line
            string += ' ER ||\n\n'
        string = string[:-5]
        string += '  EF||\n\n'

    # Export to txt or doc file
    with open(output_name, 'w', encoding='utf8') as f:
        f.write(string)
    print('Export to BibExcel complete.')


def jsontoexcel(input_json, encoding='utf8'):
    """
    This function will export a JSON to Excel file as sample.xlsx
    """
    import pandas as pd
    import json

    # load JSON file
    with open(input_json, 'r', encoding=encoding) as f:
        json_data = f.read()
        f.close()
    json_data = json.loads(json_data)

    # json_data is a list of dicts
    # creating a dataframe from it
    df = pd.DataFrame(json_data)
    df.index += 1   # if you want to have the index starting in 1 instead of 0

    # If you want to have the index displaying bc##
    df = df.set_index('bc' + df.index.astype(str))
    # export sample.xlsx
    df.to_excel("sample.xlsx")
    print('JSON exported to Excel at sample.xlsx')


def parse_arguments():
    import argparse
    # Description
    parser = argparse.ArgumentParser(description='Tools to Wrangle data to and from BibExcel')
    # input
    parser.add_argument('-i', '--input', help='input filename')
    # input_matrix
    parser.add_argument('-m', '--input_matrix', default='adjacency_matrix.csv', help='input adjacency matrix')
    # encoding
    # parser.add_argument('-e', '--encoding', default='utf8', help="desired enco=ding (default 'utf8')")
    # type
    parser.add_argument('-t', '--type', help="either 'scopus' or 'wos'")
    # functionality
    parser.add_argument('-f', '--function', help="either 'bibexceltojson', 'jsontobibexcel', 'jsontoexcel', 'filtercoupling'")
    # output
    parser.add_argument('-o', '--output', help='output filename')
    # defaults
    arguments = vars(parser.parse_args())
    return(arguments)


def main(input=None, input_matrix=None, type=None, function=None, output=None):
    import bibexcel
    if function == 'bibexceltojson':
        bibexcel.bibexceltojson(input_name=input, type=type, encoding='utf8', output_name=output)
    if function == 'jsontobibexcel':
        bibexcel.jsontobibexcel(input_name=input, type=type, encoding='utf8', output_name=output)
    if function == 'jsontoexcel':
        bibexcel.jsontoexcel(input_json=input, encoding='utf8')
    if function == 'filtercoupling':
        bibexcel.filtercoupling(input_matrix=input_matrix, input_json=input, type=type, encoding='utf8', output_name=output)


if __name__ == '__main__':
    arguments = parse_arguments()
    main(**arguments)
