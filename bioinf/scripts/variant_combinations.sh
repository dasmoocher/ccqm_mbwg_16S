# bash script for processing variant linkages

Ecoli_ref=../resources/Ecoli_16S_consensus.fasta
Lmono_ref=../resources/Lmono_16S_consensus.fasta

for i in *TMAP-refine.bam #*SangerClones*bam;
do
	if [[ $i == Ecoli* ]]; then
		f=$Ecoli_ref
	else
		f=$Lmono_ref
	fi
	basename=$(echo $i | sed 's/.bam//')
	../bin/samtools view -o $basename.sam $i
	python ../scripts/SAM_parser.py $basename.sam $f $basename.csv
done