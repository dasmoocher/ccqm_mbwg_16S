#!/bin/bash
####
# bash script that obtains fastq sequence files for next generation sequencing datasets
#
# Requirements: sratoolkit- available at http://www.ncbi.nlm.nih.gov/Traces/sra/?view=software
#	       mothur - available at http://www.mothur.org/wiki/Download_mothur
#
# Created by: Nate Olson
#
# Updated February 20, 2014
#
####

set -v
SRA_SRC=src/sratoolkit.2.3.5-2-ubuntu64/bin

# accession numbers for next generation sequencing datasets generated 
# as part of the 2013 CCQM MBSG 16S rRNA interlaboratory study
SRAS=(SRR1020876 SRR1021459 SRR1020906 SRR1020910 SRR1021199 SRR1022526 \
	  SRR1022527 SRR1031053 SRR1031054 SRR1031055 SRR1031056)

for sra in ${SRAS[@]};
do
$SRA_SRC/fastq-dump $sra -O fastq-data
done;

# additional code for splitting NMIA barcoded data
$SRA_SRC/sff-dump -A SRR1021212
bin/mothur scripts/nmia_split.batch
cat *EC*fasta > SRR1021212-EC.fasta
cat *EC*qual > SRR1021212-EC.qual
cat *LM*fasta > SRR1021212-LM.fasta
cat *LM*qual > SRR1021212-LM.qual

echo "Converting fasta and qual to fastq"
for org in LM EC;
do
python scripts/fastaqual_to_fastq.py SRR1021212-$org.fasta
done
mv *fastq fastq-data/
#cleaning up files
rm -f *sff *fasta *qual *qscore
