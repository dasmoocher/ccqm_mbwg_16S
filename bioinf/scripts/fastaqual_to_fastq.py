'''
Purpose: Convert fasta and qual files to fastq

Requirements: python and biopython

Input: fasta and qual file, files must have the same base name, 
       specify fasta file as first argument for command line use

Output: fastq file with same base name as fasta input file

Written by:  Nathan Olson
Organization: National Institute of Standards and Technology

Date: February 1, 2014

Source code from: http://nebc.nerc.ac.uk/downloads/scripts/parse
'''
#!/usr/bin/env python
import sys
from Bio import SeqIO
from Bio.SeqIO.QualityIO import PairedFastaQualIterator

#Takes a FASTA file, which must have a corresponding .qual file,
# and makes a single FASTQ file.

if len(sys.argv) == 1:
        print "Please specify a  single FASTA file to convert."
        sys.exit()

filetoload = sys.argv[1]
basename = filetoload

#Chop the extension to get names for output files
if basename.find(".") != -1:
        basename = '.'.join(basename.split(".")[:-1])

try:
	fastafile = open(filetoload)
	qualfile = open(basename + ".qual")
except IOError:
	print "Either the file cannot be opened or there is no corresponding"
	print "quality file (" + basename +".qual)"
	sys.exit()

rec_iter = PairedFastaQualIterator(fastafile,qualfile)

SeqIO.write(rec_iter, open(basename + ".fastq", "w"), "fastq")