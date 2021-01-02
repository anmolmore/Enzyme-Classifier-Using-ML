# Team Members
# - Shubhendu Vimal - 11915067
# - Dharani Kiran Kavuri - 11915033
# - Anmol More - 11915043

#Data Preparation in plain Python

#Read raw fasta protien sequence files and convert it to parsable CSV files using biopython

#Embedded block of code for converting to pdf only, run separately (time taking)

import sys
import pandas as pd
from Bio.SeqUtils.ProtParam import ProteinAnalysis

#arg 1 - fasta file name
#arg 2 - no of records to process
file = str(sys.argv[1])
limit = int(sys.argv[2])
print("Processing file : ", file)

df = pd.DataFrame()
enzyme_type = file[:-6]

# read fasta files, line by line and process enzyme sequence
print("Group all as : ", enzyme_type)
with open(file) as fileobject:
    start = True
    row = ""
    for line in fileobject:
        if("sp|" in line or "tr|" in line) :
            start = True
            if(row != "") :
                row_dict = {}
                row_dict["Sequence"] = row
                row_dict["Type"] = enzyme_type

                try :
                	#use biopython library to process enzyme sequence
                    analysed_seq = ProteinAnalysis(row)
                    #print(analysed_seq)
                    amino_acid_counts = analysed_seq.count_amino_acids()
                    row_dict.update(amino_acid_counts)
                    analysed_seq = ProteinAnalysis(row)
                    row_dict["weight"] = analysed_seq.molecular_weight()
                    row_dict["gravy"] = analysed_seq.gravy()
                    df = df.append(row_dict, ignore_index=True)
                    print(df.shape)
                    if(df.shape[0] > limit) :
                    	break
                except :
                    print("Error")
                row = ""
        elif(start) :
            row += line.rstrip()
print(df.head())
df.to_csv("data/" + enzyme_type + ".csv", index=False)