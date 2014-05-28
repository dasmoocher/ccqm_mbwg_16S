#!/bin/bash

# getting sample and base count position data
# by: Nate olson
# organisation: NIST
# written 2/8/2014
# Requirements:
# gakt for generating depth, base counts and other summery statistics

# code written based on directory structure described in github README file

# Processing additional command line arguments
# e.g. PATH, JAVA, directory for output
# add in usage and requirements with --help
set -v 

#adding repository bin and scripts folder to path
BIN=../bin #binary directory

#java runtime specs 
JAVA=Xmx2g

# reference files
Ecoli_ref=../resources/Ecoli_16S_consensus.fasta
Lmono_ref=../resources/Lmono_16S_consensus.fasta

for i in *vcf;
do
	if [[ $i == Ecoli* ]]; then
		f=$Ecoli_ref
	else
		f=$Lmono_ref
	fi
	prefix=$(echo $i | sed 's/.vcf//')

	java -$JAVA -jar $BIN/GenomeAnalysisTK.jar -T VariantsToTable \
		-R $f \
		-V $i \
		-raw -AMD -dt NONE \
		-F REF -F POS -F DP -F QUAL -F MQ -F MQ0 -F MQRankSum -F QD \
		-F AC -F AF -F AN -F Dels -F FS -F HaplotypeScore \
		-F BaseQRankSum -F MLEAC -F MLEAF -F ReadPosRankSum \
		-o $prefix-Table.tsv
done
