#!/bin/bash

#####
# pipeline for processing data from CCQM study for variant call analysis
#
# Created by: Nate Olson
#
# Written 05/15/2013
#
# Updated 2/20/2014
#
# Requirements:
# TMAP and bwa for mapping
# samtools, picard, and gatk for processing sam files
# samtools for mpileup
# samtools and gatk for snp calling
# scripts for processing mpileup files
#
#####

# Processing additional command line arguments
# e.g. PATH, JAVA, directory for output
# add in usage and requirements with --help
set -v 

#adding repository bin and scripts folder to path
BIN=../bin #binary directory
FQDIR=../fastq-data #fastq directory

#java runtime specs 
JAVA=Xmx4g

# Functions
### Are any of these redundant????
index_reference() {
	$BIN/tmap index -f $1
	$BIN/tmap samtools faidx $1
	$BIN/bwa index $1
	java -$JAVA -jar $BIN/CreateSequenceDictionary.jar R=$1 O=$(echo $1 | sed 's/fasta/dict/')	
}

mapping(){
	#takes fastq and reference fasta as input and maps using tmap and bwasw
	f=$1 # the reference fasta is the first argument passed
	fq=$2 # the read set in fastq format is the second argument passed
	
	prefix2=$(echo $fq | sed 's/.fastq//')
	#mapping datasets using tmap
	$BIN/tmap mapall -f $f -r $fq -n 4 -v -u -o 2 stage1 map4 stage2 map2 stage3 mapvsw> $prefix2-TMAP.bam
	#samtools view -bSh -o $prefix2-TMAP.bam $prefix2-TMAP.sam
	#mapping datasets using bwa bwasw
	#$BIN/bwa bwasw -t 4 $f $fq > $prefix2-bwa.sam
	$BIN/bwa mem -t 4 $f $fq > $prefix2-bwa.sam
	$BIN/tmap samtools view -bSh -o $prefix2-bwa.bam $prefix2-bwa.sam
}

bam_processing(){
	# take bam files as input adds full read ground, then sorts and indexes

	f=$1 # the reference fasta is the first argument passed
	bam=$2 # the sam file is the second argument passed
	lab=$3
	rep=$4
	plat=$5
	org=$6

	prefix3=$(echo $bam | sed 's/.bam/-basic/')	
	#modifying sequence alignment
	java -$JAVA -jar $BIN/AddOrReplaceReadGroups.jar I= $bam O= $prefix3.bam RGID=$org RGLB=$rep RGPU=$lab RGPL=ccqm RGSM=$org-$plat-$lab-$rep 
	echo "SortingSam ..."	
	java -$JAVA -jar $BIN/SortSam.jar I= $prefix3.bam O= $prefix3.sort.bam SO=coordinate
	$BIN/tmap samtools index $prefix3.sort.bam
	mv $prefix3.sort.bam $prefix3.bam
}

bam_refiner(){
	f=$1
	bam=$2
	plat=$3

	prefix4=$(echo $bam | sed 's/-basic.bam/-refine/')
	#do not remove replicates for amplicon datasets
	if [[ $plat == 'ION' ]]; then 
		java -$JAVA -jar $BIN/MarkDuplicates.jar REMOVE_DUPLICATES=TRUE I=$bam O=$prefix4.bam M=$prefix4.metric.txt

	else
		cp $bam $prefix4.bam	
	fi
	
	$BIN/tmap samtools index $prefix4.bam
	java -$JAVA -jar $BIN/GenomeAnalysisTK.jar -R $f -I $prefix4.bam -T RealignerTargetCreator  -o $prefix4.intervals
	java -$JAVA -jar $BIN/GenomeAnalysisTK.jar -R $f -I $prefix4.bam -T IndelRealigner -targetIntervals $prefix4.intervals  -o $prefix4.realigned.bam
	mv $prefix4.realigned.bam $prefix4.bam
	rm $prefix4.intervals
}

process_fastq_bam() {
	#takes fastq as input and processes whole through to mpileup and gatk unified genotyper
	
	fq=$1
	org=$2
	lab=$3
	rep=$4
	plat=$5
	
	prefix1=$(echo $fq | sed 's/.fastq//')
	# determining which reference to use
	if [[ $org == "Ecoli" ]]; then
		f=$Ecoli_ref
	else
		f=$Lmono_ref
	fi

	echo $fq

	mapping $f $fq

	for bam in $prefix1-TMAP.bam $prefix1-bwa.bam;
	do
		bam_processing $f $bam $lab $rep $plat $org
		bam_ref=$(echo $bam | sed 's/.bam/-basic.bam/')
		bam_refiner $f $bam_ref $plat
	done

	for bam in $prefix1-TMAP-basic.bam $prefix1-TMAP-refine.bam \
			$prefix1-bwa-basic.bam $prefix1-bwa-refine.bam;
	do
		$BIN/tmap samtools index $bam		
		prefix5=$(echo $bam | sed 's/.bam//')
		#GATK variant calling
		java -$JAVA -jar $BIN/GenomeAnalysisTK.jar -R $f -I $bam -T UnifiedGenotyper -glm SNP  -o $prefix5-gatk.vcf

		#samtools variant calling
		$BIN/tmap samtools mpileup -uf $f $bam > $prefix5-sam.pileup
		$BIN/tmap bcftools view -vcg $prefix5-sam.pileup > $prefix5-sam.vcf
	done
}

get_metadata_and_process_dataset (){
	# splits lines of code in metadata file and assigns appropriate variables
	# required variables
	# 1. data_set.file
	# 2. organism
	# 3. sequencing center
	# 4. sequencing unit - replicate number (1 for most)
	# 5. sequencing platform
	
	local meta_line=$1
	data_set=$(echo $meta_line | cut -d ',' -f1)
	org=$(echo $meta_line | cut -d ',' -f2)
	lab=$(echo $meta_line | cut -d ',' -f3)
	rep=$(echo $meta_line | cut -d ',' -f4)
	plat=$(echo $meta_line | cut -d ',' -f5)
	
	echo "Working on:"	
	echo "$data_set $org $lab $rep $plat"
	
	# modifying datafile names for analysis 
	cp $FQDIR/$data_set "$org-$plat-$lab-$rep.fastq"
	fastq="$org-$plat-$lab-$rep.fastq"
	
	# map fastq dataset to reference
	echo "processing fastq ..."
	process_fastq_bam $fastq $org $lab $rep $plat
}


# indexing and assigning reference variables
# assumes references are E. coli and L. monocytogenes
if [[ $2 == *coli* ]]; then 
	Ecoli_ref=$2 
	Lmono_ref=$3
else 
	Ecoli_ref=$3 
	Lmono_ref=$2
fi
index_reference $Ecoli_ref
index_reference $Lmono_ref

# Read metadata input file command line argument
while read line; 
	do
	get_metadata_and_process_dataset $line	
done <$1


