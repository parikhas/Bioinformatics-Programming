#!/usr/bin/python
#This program opens a FASTA file containing sequences of nucleotides. For each sequence, it will calculate the number of A's, T's, G's, C's, and N's along with the length of the sequence and also the %GC content of the entire sequence.

import re
from collections import Counter
headers = []
seq = []
current_seq = ""

with open("test.fasta", "r") as f1:
    for line in f1:
        if line.startswith(">"):
            headers.append(line)
            if current_seq != "":
                seq.append(current_seq)
            current_seq = ""

        else:
            current_seq += line.strip()
    seq.append(current_seq)

#print(headers)
#print(seq)

if len(headers) == len(seq):
    print("Size of header and sequence lists is the same")
elif len(headers) != len(seq):
    print("Size of header and sequence lists is not the same")

for each_header in headers:
    acc_no = re.compile(r"([^\s]+)") 
    result = acc_no.match(each_header).group()
    #print(result)

for each_seq in seq:
    counter = Counter(each_seq)
    #print("A:", counter['A'],"T:", counter['T'], "G:", counter['G'], "C:", counter['C'])

print("Accession Number, A, T, G, C, CG%, Length")
for h,s in zip(headers,seq):
    acc_no = re.compile(r"([^\s]+)")
    result1 = acc_no.match(h).group()
    counter = Counter(s)
    ac = counter['A']
    tc = counter['T']
    gc = counter['G']
    cc = counter['C']
    gcp = round(((gc+cc)/(ac+tc+gc+cc))*100, 2)
    print(result1, ac, tc, gc, cc, gcp, len(s))


