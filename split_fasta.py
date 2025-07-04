#pip install Bio
import os
from Bio import SeqIO
path = "/Users/huiqing/Documents/Cx_pipiens/"
os.chdir(path)

i=1
file_to_work = "b2_plinkPruned_geno10_s3.snps.tab.fasta"
with open(file_to_work, "r") as fasta_file:
    lines = fasta_file.readlines()
    for j in range(1,2231971,50000):
        with open("fasta_output_"+str(i)+".fasta", "a") as f_out:
            for line in lines:
                if line.startswith(">"):
                    f_out.write(line)
                else:
                    f_out.write(line[j:j+50000]+"\n")
            i = i+1
