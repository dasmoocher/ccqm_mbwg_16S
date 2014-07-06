# Base image 
FROM ubuntu:14.04

# Dockerfile for ccqm_mbwg_16 dependencies
MAINTAINER NateOlson

# Adding ccqm_mbwg as volume
VOLUME ~/ccqm_mbwg_16S

# install of basic dependencies
RUN apt-get update

RUN apt-get install  -y \
	apt-utils \
	git \
	make \
	gcc \
    g++ \
    sra-toolkit \
    python-setuptools \
    python-dev \
    automake \
    autoconf \
    autogen \
    wget
    
    

# install R packages
RUN sh -c "echo deb http://cran.rstudio.com/bin/linux/ubuntu trusty/ > /etc/apt/sources.list.d/cran.list"
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN apt-get update
RUN apt-get install -y r-base r-base-dev
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile
RUN Rscript -e "install.packages(c('reshape2','ggplot2','knitr','dplyr','gtools','xtable'))"

# install biopython
Run easy_install biopython

# install depdendencies
## tmap
RUN git clone --recursive https://github.com/nh13/TMAP.git
RUN cd TMAP sh autogen.sh && ./configure && make
RUN mv TMAP/tmap ~/ccqm_mbwg_16S/bin/

## bwa
RUN git clone https://github.com/lh3/bwa.git
RUN cd bwa && make
RUN mv bwa/bwa ~/ccqm_mbwg_16S/bioinf/bin/

## picard
RUN git clone https://github.com/broadinstitute/picard.git
RUN mv picard*/*jar ~/ccqm_mbwg_16S/bin/

## mothur
RUN wget http://www.mothur.org/w/images/8/88/Mothur.cen_64.zip
RUN unzip Mothur.cen_64.zip 
RUN mv mothur ~/ccqm_mbwg_16S/bin/


## prinseq
RUN wget http://sourceforge.net/projects/prinseq/files/standalone/prinseq-lite-0.20.4.tar.gz/download
RUN tar xvf download
RUN mv prinseq*/prinseq-lite.pl ~/ccqm_mbwg_16S/bin/


