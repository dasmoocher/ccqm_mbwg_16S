## File descriptions
*Ecoli_16S_consensus.fasta* and *Lmono_16S_consensus.fasta* are 16S reference sequences with ambiguous bases at biologically variable positions.   

*Ecoli_16S_consensus_no_ambigs.fasta* and *Lmono_16S_consensus_no_ambigs.fasta* are 16S reference sequences with no ambiguous bases at biologically variable positions. Used a systematic approach for replacing ambiguous positions with first base ACGT (alphabetical ordering) not expected at that position.  This approach was used to promote variant calls for ambiguous positions.   

**Specific base replacements**   

| Organism | Ref base | Replacement | Position    |
|----------|----------|-------------|-------------|
| Ecoli    | R        | C           | 118         |
|          | R        | C           | 975         |
|          | S        | A           | 979         |
|          | Y        | A           | 983         |
|          | RRWWK    | CTCGA       | 992-996     |
|          | Y        | A           | 1011        |
|          | R        | C           | 1395        |
| Lmono    | K        | A           | 175         |
|          | Y        | A           | 188         |
|          | R        | C           | 419         |
|          | R        | C           | 16 from end |
|          | R        | C           | 5 from end  |
|          | WW       | AA          | last 2 bases|


*metadata.csv* metadata file defining datasets used by the *ccqm_pipeline_comparison.sh* script   

*nmia_barcodes.oligo* defines the barcodes used to split the NMIA multipled "454" dataset.   

**Sanger-Clones**   
sam and fasta files for the LGC and NIST clone libraries were generated manually using [Geneious](http://www.geneious.com/). Briefly the sequences from each clone were first assembled and the consensus sequences for each of the clones were then mapped to the respective reference sequence. The resulting sam files were used in the Likely Gene Copy Analysis.
 
