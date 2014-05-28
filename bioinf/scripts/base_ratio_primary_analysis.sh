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
JAVA=Xmx3g

# reference files
Ecoli_ref=../resources/Ecoli_16S_consensus_no_ambigs.fasta
Lmono_ref=../resources/Lmono_16S_consensus_no_ambigs.fasta

index_reference() {
	$BIN/tmap samtools faidx $1
	java -$JAVA -jar $BIN/CreateSequenceDictionary.jar R=$1 O=$(echo $1 | sed 's/fasta/dict/')	
}

index_reference $Ecoli_ref
index_reference $Lmono_ref
for i in *bwa-refine.bam; 
do
	if [[ $i == Ecoli* ]]; then
		f=$Ecoli_ref
	else
		f=$Lmono_ref
	fi
	prefix=$(echo $i | sed 's/.bam//')
	echo $prefix $f
	java -$JAVA -jar $BIN/GenomeAnalysisTK.jar -T UnifiedGenotyper \
		-I $i \
		-R $f \
		-A BaseCounts \
		-dt NONE \
		-out_mode EMIT_ALL_SITES \
		-o $prefix-Full.vcf

	java -$JAVA -jar $BIN/GenomeAnalysisTK.jar -T VariantsToTable \
		-R $f \
		-V $prefix-Full.vcf -dt NONE \
		-raw -AMD \
		-F REF -F POS -F DP -F BaseCounts -F QUAL -F MQ -F AF -F AN -F Dels -F FS -F HaplotypeScore \
		-o $prefix-Full-Table.tsv
done
