#!/usr/bin/python

import argparse
import sys

parser = argparse.ArgumentParser()
parser.add_argument ("-file", help = "Give the file to be parsed")
args = vars(parser.parse_args())

ifile = args["file"]

geneSymboltoDesc = {}

with open (ifile, "r") as fh:
    next(fh)
    for line in fh:
        line = line.split("\t")
        gene_sym = line[0]
        gene_sym = gene_sym.upper()
        gene_desc = line[1]
        geneSymboltoDesc[gene_sym] = gene_desc

while True:
    gene_input = input("Please enter the gene symbol to retrieve it's description: ")
    gene_input = gene_input.upper()
    if gene_input in geneSymboltoDesc:
        print(gene_input)
        print(geneSymboltoDesc[gene_input])
        continue
    elif gene_input == "QUIT":
        break
    else:
        print("Given gene symbol not found in file")

