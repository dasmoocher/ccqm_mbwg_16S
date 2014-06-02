# CCQM MBWG Microbial Identity 2013  

  
## Procedure for reproducing sequence analysis
1. [Bioinformatics sequence processing](#bsp)  
    1. [Sequence gathering](#bdg)
	2. [conservative bases](#bcb)
	3. [biologically variable positions](#bbv)
	4. [individual gene copy sequences](#bvs)

### [Bioinformatitics sequence processing](id:bsp)
The complete sequence analysis pipeline can be completed by running the *pipe.sh* script from the command line: `bash scripts\pipe.sh` from within the *ccqm_mbwg_16S/bioinf* directory. See the supplemental computation methods section of the manuscript (in prep) for a detailed description of the bioinformatics pipeline.


#### [Data Gathering](id:bdg)
* Sanger sequencing data is included in the *fastq-data* directory of the repository as fastq files.  The raw data was trimmed and converted to fastq manually using [Geneious](http://www.geneious.com/)
	- The raw sequencing data is archived in the _GenBank Trace Archive_  to retrieve the raw data from the database
		- Go to[http://www.ncbi.nlm.nih.gov/Traces/trace.cgi?view=search](http://www.ncbi.nlm.nih.gov/Traces/trace.cgi?view=search)  
		- Input search query string: `CENTER_NAME = "NIST" or CENTER_NAME = "LGC" or CENTER_NAME = "ISP" or CENTER_NAME = "ATCC"` (should return 495 sequences)  

* Next generation sequencing data - archived in the _GenBank SRA_   
	* *sra_to_fastq.sh* - script will download and dump datasets as fastq for next generation sequencing datasets generated in the study.
	* Additional steps included to split the NMIA data by barcodes using *mothur*, using the *nmia_split.batch* script, called from the *sra_to_fastq.sh* script.  The dataset is "dumped" as an sff file which is split by barcode and converted into fasta and qual.  The *fastaqual_to_fastq.py* script (also called by *sra_to_fastq.sh*) is used to convert the files into fastq files for *E. coli* and *L. monocytogenes*.
	
#### [Conservative Bases](id:bcb)
* pipeline comparison - *ccqm_pipeline_comparison.sh*
	* requirements: in *resources directory*: *metadata.txt*, *Ecoli_16S_consensus.fasta*, and *Lmono_16S_consensus*; software requirements noted in script header. 	
	

#### [Biologically Variable Positions](id:bbv)
* Base counts and initial statisitics for biologically variable positions calculated using *GenomeAnalysisTK.jar* for the mapping files generated using *bwa* with realignment around indels and removal of duplicate reads.

#### [Indiviudual Gene Copy Sequences](id:bvs)
* The *SAM_parser.py* script was used to generate the contatenated biologically variable positions for individual sequencing reads from the mapping files generated using *bwa* with realignment around indels and removal of duplicate read.
