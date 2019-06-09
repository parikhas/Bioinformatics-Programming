#!/usr/bin/python

headers = []
seq = []
current_seq = ""

with open("ss.txt", "r") as f1:
    for line in f1:
        if line.startswith(">"):
            headers.append(line)
            if current_seq != "":
                seq.append(current_seq)
            current_seq = ""
        else:
            current_seq += line.strip()
    seq.append(current_seq)

if len(headers) == len(seq):
    print("Size of header and sequence lists is the same")
elif len(headers) != len(seq):
    print("Size of header and sequence lists is not the same")

count_prot = 0
count_seq = 0

with open ("pdbProtein.fasta", "w") as f1, open ("pdbSS.fasta", "w") as f2:
    for h,s in zip(headers,seq):
        if h.endswith("sequence\n"):
            count_seq += 1
            print(h,s,file=f2)
        else:
            count_prot += 1
            print(h,s,file=f1)

print("Found", count_prot, "protein sequences")
print("Found", count_seq, "secondary structure sequences")

