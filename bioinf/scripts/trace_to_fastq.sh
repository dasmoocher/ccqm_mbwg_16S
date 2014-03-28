#!/bin/bash
####
# bash script to move fasta and qual files to single folder
#
# Requirements: python script fastaqual_to_fastq.py
#
# Input: fasta and qual files in compressed directory downloaded from NCBI trace archive, 
#		 in trace-data directory
#
# Created by: Nate Olson
#
# Updated February 20, 2014
#
####

#moving manually trimmed Sanger sequences
cp resources/*fastq fastq-data/
#ls resources/*fastq 

#echo "Uncompress trace file"
#cd trace-data
#tar xvzf trace.tar.gz
#cd ../

#echo "Generate single file fasta and qual file for each dataset"
#for i in ESCHERICHIA LISTERIA;
#do
#for j in NIST LGC ATCC ISP;
#do
#cat trace-data/*/$i*/$j/fasta/*fasta > fastq-data/$i-$j-sanger.fasta
#cat trace-data/*/$i*/$j/qscore/*qscore > fastq-data/$i-$j-sanger.qual
#done
#done

 
#echo "Converting fasta and qual to fastq"
#cd fastq-data
#for fasta in *fasta;
#do
#python ../scripts/fastaqual_to_fastq.py $fasta
#done

#echo "Cleaning up fasta and qual files"
#rm *fasta *qual

#cd ../

