#!/usr/bin/python

#######################################################################################
# File 		  : categories.py

# Description : This program counts how many genes are in each category (1.1, 1.2, 2.1 etc.) 
# based on data from the chr21_genes.txt file. The program prints the results such that 
# categories are arranged in ascending order to an output file (categories.txt).  
#######################################################################################

import sys
import argparse

parser = argparse.ArgumentParser()
parser.add_argument ("-file", help = "Give the file to be parsed")
parser.add_argument ("-outfile", help = "Give the file to write the output to")
args = vars(parser.parse_args())

ifile = args["file"]
ofile = args["outfile"]

categ_Numgene = {}
categ_Desc = {}

with open(ifile, "r") as fh:
    next(fh)
    for line in fh:
        line = line.rstrip()
        line = line.split("\t")
        gene_sym = line[0]
        gene_desc = line[1]
        if len(line) == 3:
            categ = line[2]
            categ = float(categ)
            categ_Desc[categ] = gene_desc
            if categ in categ_Numgene:
                categ_Numgene[categ] += 1
            else:
                categ_Numgene[categ] = 1


with open(ofile, "w") as f:
    f.write("\t".join(("Category", "Occurence", "Definition","\n")))
    for k in sorted(categ_Numgene.keys()):
        if k in categ_Desc.keys():
            f.write("\t".join((str(k), str(categ_Numgene[k]), categ_Desc[k],"\n")))
