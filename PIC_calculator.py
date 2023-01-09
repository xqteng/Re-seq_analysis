#PIC_calculcator
"""
1. parse vcf
2, PIC of a position = 1 - allele1^2 - allele2^2 ... ...
3. average PIC
4. optional: either full data or some
"""

import argparse
import gzip
import csv

parser = argparse.ArgumentParser(description="Calculate Polymorphism  Information Contents by vcf file")
parser.add_argument("-v", "--vcf", action="store", required=True, help="Input VCF file. ")
parser.add_argument("-o", "--out", action="store_true", required=False, help="Output filename")
parser.add_argument("-g", "--gzip", action="store_true", required=False, help="Set if the VCF is gzipped.")
parser.add_argument("-L", "--long", action="store_true", required=False, help="Weather output a large file with PIC on every pos. If not set,only a file with average PIC is outputed")

args = parser.parse_args()
vcf_in = args.vcf
if args.out:
    out_name = args.out
else:
    out_name = vcf_in + ".pic"

out_writer = open(out_name,mode = "w")

if args.gzip:
    opener = gzip.open
else:
    opener = open


if args.long:
    out_writer.write("CHROM\tPOS\tPIC\n")
else:
    out_writer.write("The average PIC is:\n")

    
with opener(vcf_in, 'r') as tsvin:
        tsvin = csv.reader(tsvin, delimiter='\t')
        nrow = 0
        sumPIC = 0
        for row in tsvin:
            if any('##' in strings for strings in row):
                continue
            if any('#CHROM' in strings for strings in row):
                continue
            chrom,pos,id,ref,alt,qual,filter,info,format=row[0:9]
            haplotypes = row[9:]

            AF = info.split(";")[1].split("=")[1].split(",")
            AF = [float(frequency) for frequency in AF]
            AF.append(1-sum(AF))

            ###PIC = 1- sum(pi**2) - sum(pi**2)**2+sum(pi**4)
            PIC_s1 = sum([i**2 for i in AF]) 
            PIC_s2 = (sum([i**2 for i in AF]) )**2
            PIC_s3 = sum([i**4 for i in AF])
            PIC = 1 -   PIC_s1 -   PIC_s2 +  PIC_s3
            nrow += 1
            sumPIC += PIC
            if args.long:
                out_writer.write(chrom + "\t" +pos + "\t" +str(PIC) +"\n")
        if not args.long:
            averagePIC = round(sumPIC/nrow,6)
            out_writer.write(str(averagePIC))
            
            
