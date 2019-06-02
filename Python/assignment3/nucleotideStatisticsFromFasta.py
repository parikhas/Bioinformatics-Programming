#!/usr/bin/python

headers = []
seq = []
current_seq = ""

with open("test.fasta", "r") as f1:
    for line in f1:
        #print(line)
        if line.startswith(">"):
            #print(line)
            headers.append(line)
            print("Within if")
            print(current_seq)
            if current_seq != "":
                #print(current_seq)
                seq.append(current_seq)
                #print(seq)
            current_seq = ""

        else:
            print("Outside if")
            #print(current_seq)
            current_seq += line.strip()
            print(current_seq)
    seq.append(current_seq)

#print(headers)
#print(seq)


