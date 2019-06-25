#!/usr/bin/python

import argparse
import os

parser = argparse.ArgumentParser()
parser.add_argument('host', help = "Please give the host mammal to query the information")
parser.add_argument('gene', help = "Please enter the gene whose information is required")

args = vars(parser.parse_args())

host_folder = args["host"]
gene_file = args["gene"]
gene = " ".join(gene_file.split(".")[:1])

host_dict = {
        "Horse" : "Equus_caballus",
        "horses" : "Equus_caballus",
        "horse" : "Equus_caballus",
        "Equus caballus" : "Equus_caballus",
        "Equus_caballus" : "Equus_caballus"
        }

host_name = host_dict[host_folder]
host_fname = host_name.replace("_", " ")

#directory = os.fsencode(host_folder)
directory = os.fsencode(host_name)

gfile = os.fsencode(gene_file)

for files in os.listdir(directory):
    #print(files)
    if files == gfile:
        with open(gfile, "r") as f1:
            for line in f1:
                if line.startswith("EXPRESS"):
                    #print(line)
                    line = " ".join(line.split()[1:])
                    tissues = line.split("|")
                    tissues = [x.strip(' ') for x in tissues]
                    print("\nFound Gene", gene, "for", host_fname)
                    print("In",host_fname,"there are", len(tissues), "tissues that", gene ,"is expressed in:\n")
                    for i in tissues:
                        print(tissues.index(i)+1, i.capitalize())


