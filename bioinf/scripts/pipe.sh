#!/bin/bash
#####
# bash script which executes a series of bash scripts that perform the initial 
# bioinformatic data analysis of the 2013 CCQM MBSG 16S rRNA interlaboratory 
# sequencing study
#
# Created by: Nate Olson
#
# Updated February 20, 2014
#
#####

bash scripts/trace_to_fastq.sh
#bash scripts/sra_to_fastq.sh
cd results
bash ../scripts/ccqm_pipeline_comparison.sh \
	../resources/metadata_sanger.csv \
	../resources/Lmono_16S_consensus.fasta \
	../resources/Ecoli_16S_consensus.fasta
bash ../scripts/fastq_stats.sh
bash ../scripts/pipeline_comparison_tables.sh
bash ../scripts/base_ratio_primary_analysis.sh
bash ../scripts/variant_combinations.sh