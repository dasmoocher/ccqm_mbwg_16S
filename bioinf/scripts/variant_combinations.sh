# bash script for processing variant linkages

Ecoli_ref=../resources/Ecoli_16S_consensus.fasta
Lmono_ref=../resources/Lmono_16S_consensus.fasta


for i in *bwa-refine.bam;
do
	if [[ $i == Ecoli* ]]; then
		f=$Ecoli_ref
	else
		f=$Lmono_ref
	fi
	basename=$(echo $i | sed 's/.bam//')
	../bin/tmap samtools view -o $basename.sam $i
	python ../scripts/SAM_parser.py $basename.sam $f $basename.csv
done

cp ../resources/*Sanger-Clones.sam ./

for i in *Sanger-Clones.sam;
do
	if [[ $i == Ecoli* ]]; then
		f=$Ecoli_ref
	else
		f=$Lmono_ref
	fi
	basename=$(echo $i | sed 's/.sam//')
	python ../scripts/SAM_parser.py $i $f $basename.csv
done