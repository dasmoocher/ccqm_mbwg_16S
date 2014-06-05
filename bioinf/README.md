## Procedure for reproducing sequence analysis
1. [Bioinformatics sequence processing](#bsp)  
    1. [Sequence Gathering](#bdg)
	2. [Biologically Conserved Position Analysis](#bcb)
	3. [Biologically Variable Position Analysis](#bbv)
	4. [Likely Gene Copy Sequence Analysis](#bvs)

### [Bioinformatitics sequence processing](id:bsp)
The complete sequence analysis pipeline can be completed by running the *pipe.sh* script from the command line: `bash scripts\pipe.sh` from within the *ccqm_mbwg_16S/bioinf* directory. See the supplemental computation methods section of the manuscript (in prep) for a detailed description of the bioinformatics pipeline.


#### [Sequence Gathering](id:bdg)
* Sanger sequencing data is included in the *fastq-data* directory of the repository as fastq files.  The raw data was trimmed and converted to fastq manually using [Geneious](http://www.geneious.com/)
	- The raw sequencing data is archived in the _GenBank Trace Archive_  to retrieve the raw data from the database
		- Go to[http://www.ncbi.nlm.nih.gov/Traces/trace.cgi?view=search](http://www.ncbi.nlm.nih.gov/Traces/trace.cgi?view=search)  
		- Input search query string: `CENTER_NAME = "NIST" or CENTER_NAME = "LGC" or CENTER_NAME = "ISP" or CENTER_NAME = "ATCC"` (should return 495 sequences)  

* Next generation sequencing data - archived in the _GenBank SRA_   
	* *sra_to_fastq.sh* - script will download and dump datasets as fastq for next generation sequencing datasets generated in the study.
	* Additional steps included to split the NMIA data by barcodes using *mothur*, using the *nmia_split.batch* script, called from the *sra_to_fastq.sh* script.  The dataset is "dumped" as an sff file which is split by barcode and converted into fasta and qual.  The *fastaqual_to_fastq.py* script (also called by *sra_to_fastq.sh*) is used to convert the files into fastq files for *E. coli* and *L. monocytogenes*.
	
#### [Biologically Conserved Position Analysis](id:bcb)
* pipeline comparison - *ccqm_pipeline_comparison.sh*
	- Pipeline generates 8 sets of variant calls for each of the pipelines using two mapping algorithms, tmap and bwa, with and without refinement of the resulting bam files, then variants are called using the GATK UnifiedGenotyper and the samtools mpileup.
#### [Biologically Variable Position Analysis](id:bbv)
* Base counts and initial statisitics for biologically variable positions calculated using *GenomeAnalysisTK.jar* for the mapping files generated using *bwa* with realignment around indels and removal of duplicate reads.

#### [Likely Gene Copy Sequence Analysis](id:bvs)
* The *SAM_parser.py* script was used to generate the contatenated biologically variable positions for individual sequencing reads from the mapping files generated using *bwa* with realignment around indels and removal of duplicate read.
