##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#########################%%%%%%%
##
## Proportion plots for biologically variant positions
## written by: Nate Olson
## May 2013
## Modified 7/20/2013 - cleanup for release on github
## Modified 1/17/2014 - new version of figures, will combine and clean up output using Adobe Illustrator
## Modified 2/9/2014 - changed to generate a summary table for base ratio statistics
##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#########################%%%%%%%

# required packages
require(stringr)
require(reshape2)
library(plyr)

# user specific requirements
source("file_locations.R")

# set working directory for analysis folder
vcf_df <- read.csv(str_c(stat_data_loc,"merged_base_ratios.csv", sep = ""))
#  
# position associated ambiguities
ambigs <- list(
  "118"=c("A","G"),
  "975"=c("G","A"),
  "979"=c("G","C"),
  "983"=c("T","C"),
  "992"=c("A","G"),
  "993"=c("G","A"),
  "994"=c("A","T"),
  "995"=c("A","T"),
  "996"=c("T","G"),
  "1011"=c("C","T"),
  "1395"=c("A","G"),
  "175"=c("T","G"),
  "188"=c("C","T"),
  "419"=c("A","G"))

vcf_ambigs <- vcf_df[(grepl("Ecoli*", vcf_df$dataset) & 
                        vcf_df$POS %in% c(118,975,979,983,992:996,1011,1395)) |
                       (grepl("Lmono*", vcf_df$dataset) & 
                          vcf_df$POS %in% c(175,188,419)),]

# bayesian analysis
Y <- NULL
N <- NULL
max_prob <- NULL
max_copy <- NULL
prop <- NULL
for(i in 1:nrow(vcf_ambigs)){
  y = vcf_ambigs[i,ambigs[as.character(vcf_ambigs$POS[i])][[1]][2]] 
  n = vcf_ambigs[i,ambigs[as.character(vcf_ambigs$POS[i])][[1]][2]] +
    vcf_ambigs[i,ambigs[as.character(vcf_ambigs$POS[i])][[1]][1]] 
  Y = c(Y,y)
  N = c(N,n)
  if(grepl("Ecoli*", vcf_ambigs$dataset[i])){
    copy_number = 7
    p = (0:7)/7
  } else {
    copy_number = 6
    p = (0:6)/6
  } 
  z = (y-n*p)/sqrt(n*p*(1-p))
  z <- replace(z,is.nan(z),-Inf) 
  post = dnorm(z)/sum(dnorm(z))
  if(y == 0){
    max_prob = c(max_prob, 1)
    max_copy = c(max_copy, 0)
    prop <- c(prop, 0)
  }else if(y == n){
    max_prob = c(max_prob, 1)
    max_copy = c(max_copy, copy_number)
    prop <- c(prop, 1)
  }else{
    max_copy <- c(max_copy, order(-post)[1]-1)
    max_prob <- c(max_prob, max(post))
    prop <- c(prop, y/n)
  }
}

vcf_ambigs <- data.frame(cbind(vcf_ambigs, prop, max_copy, max_prob, N, Y))
vcf_ambigs$exp_ratio[vcf_ambigs$POS %in% 
                     c(975,979, 983,992:996,1011)] <- "6:1"
vcf_ambigs$exp_ratio[vcf_ambigs$POS %in% 
                     c(118,1395)]                  <- "4:3"
vcf_ambigs$exp_ratio[vcf_ambigs$POS %in% 
                     c(175,419)]                   <- "5:1"
vcf_ambigs$exp_ratio[vcf_ambigs$POS %in% 
                     c(188)]                       <- "3:3"

vcf_ambigs$max_copy <- as.factor(vcf_ambigs$max_copy)
vcf_ambigs$exp_ratio <- factor(vcf_ambigs$exp_ratio, levels = c("3:3","5:1","4:3","6:1"))

vcf_ambigs$total_copy <- 6
vcf_ambigs$total_copy[grep("Ecoli*", vcf_ambigs$dataset)] <- 7
vcf_ambigs$min_copy <- as.numeric(as.character(vcf_ambigs$total_copy)) - as.numeric(as.character(vcf_ambigs$max_copy))
vcf_ambigs$base_ratio <- str_c(vcf_ambigs$max_copy, vcf_ambigs$min_copy, sep = ":")

#writing data to file
write.csv(vcf_ambigs, str_c(stat_data_loc, "biovar_table.csv", sep = ""), row.names = FALSE)