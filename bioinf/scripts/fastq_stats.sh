#!/usr/bin/bash
# fastq basic stats
for fq in *fastq;
do
	out=$(echo $fq | sed 's/.fastq/-fastq-stats.txt/')
	perl ../bin/prinseq-lite.pl -stats_all -fastq $fq > $out
done