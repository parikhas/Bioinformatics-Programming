#!/usr/bin/python

import sys

chr21_genes = []
common_genes = []

with open("chr21_genes.txt", "r") as f1:
    next(f1)
    for line in f1:
        line = line.rstrip()
        line = line.split("\t")
        gene = line[0]
        chr21_genes.append(gene)

with open("HUGO_genes.txt", "r") as f2:
    next(f2)
    for line in f2:
        line = line.rstrip()
        line = line.split("\t")
        gene = line[0]
        if gene in chr21_genes:
            common_genes.append(gene)
        common_genes.sort()

print(len(common_genes), "common genes were found")

with open("intersectionOutput.txt", "w") as f0:
    for each_gene in common_genes:
        print(each_gene,"\n", file=f0)

