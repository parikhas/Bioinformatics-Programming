#!/usr/bin/python

import os
import argparse
from collections import defaultdict

d = defaultdict(list)
with open("input.txt", "r") as f1:
    next(f1) 
    for line in f1:
        line = line.rstrip()
        line = line.split("\t")
        chrom = line[0]
        pos = line[2]
        if chrom in d:
            d[chrom].append(pos)
        else:
            d[chrom] = [pos]

d2 = defaultdict(list)
d3 = defaultdict(dict)

with open("affy6.dat", "r") as f2:
    next(f2)
    for line in f2:
        line = line.rstrip()
        line = line.split("\t")
        chrom_str = line[1]
        loc = line[3]
        sub_str = chrom_str.split(":")
        chrom = sub_str[2]
        pos = sub_str[3]
        if chrom in d2:
            d2[chrom].append(pos)
        else:
            d2[chrom] = [pos]
        d3[chrom][pos] = loc

diff = -1

with open("scan.txt", "w") as f3:
    print("#Site", "Distance", "eQTL", "[Gene:P-val:Population]",sep="\t", file = f3)
    for chrom,pos in d.items():
        for chrom1,pos1 in d2.items():
            if chrom == chrom1:
                for each_pos in pos:
                    diff = -1
                    each_pos = int(each_pos)
                    for each_pos1 in pos1:
                        each_pos1 = int(each_pos1)
                        if diff == -1:
                            diff = abs(each_pos - each_pos1)
                            final_pos = each_pos1
                        elif diff > abs(each_pos - each_pos1):
                            diff = abs(each_pos - each_pos1)
                            final_pos = each_pos1
                    #print(final_pos)
                    for chrom3, pos3 in d3.items():
                        chrom1 = str(chrom1)
                        final_pos = str(final_pos)
                        gene1 = d3[chrom1][final_pos]
                        #print(gene1)
                    print(chrom1, each_pos, diff, final_pos, gene1, sep="\t", file = f3)

