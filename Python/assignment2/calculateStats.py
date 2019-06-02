#!/usr/bin/python

import argparse
import numpy as np

# Get the input and output files from the user
parser = argparse.ArgumentParser()
parser.add_argument("file", help = "input filename")
parser.add_argument("column", help = "column to calculate the statistics on")
args = parser.parse_args()

input_file = args.input
column = args.column

col_val = []
nan_col_val = []

with open(input_file, "r") as f1:
    for line in f1:
        
        col = line.split('\t')[column]
        if col.lower() == "nan":
            nan_col_val.append(col)
            continue:
        else:
        col_value.append(int(col))

    print("Count:", len(col_val) + len(nan_col_val))
    print("Valid Numbers:", len(col_val))
    print("Average:", round((float(sum(col_val)))/len(col_val), 2))
    print("Maximum:", np.max(col_val))
    print("Minimum:", np.min(col_val))
    print("Variance:", round(np.var(col_val), 2))
    print("Std Dev:", round(np.std(col_val), 2))




