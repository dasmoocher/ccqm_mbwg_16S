
# required packages
library(ggplot2)
library(reshape2)
library(plyr)
library(stringr)

# user specific requirements
source("file_locations.R")



#loading the base ratio data
vcf_ambigs <- read.csv(str_c(stat_data_loc,"biovar_table.csv"))

#### Calculating proportion confidence intervals
# using beta binomial for 95% posterior credible interval
vcf_ambigs$uci <- qbeta(.975,vcf_ambigs$Y+1,vcf_ambigs$N-vcf_ambigs$Y+1)
vcf_ambigs$lci <- qbeta(.025,vcf_ambigs$Y+1,vcf_ambigs$N-vcf_ambigs$Y+1)

if(any(vcf_ambigs$prop==1)){
  vcf_ambigs$uci[vcf_ambigs$prop==1] <- 1
  vcf_ambigs$lci[vcf_ambigs$prop==1] <- qbeta(.05,vcf_ambigs$Y+1, vcf_ambigs$N-vcf_ambigs$Y+1)[vcf_ambigs$prop==1]
}

if(any(vcf_ambigs$prop==0)){
  vcf_ambigs$uci[vcf_ambigs$prop==0]<- qbeta(.95,vcf_ambigs$y+1,vcf_ambigs$n-vcf_ambigs$y+1)[vcf_ambigs$prop==0]
  vcf_ambigs$lci[vcf_ambigs$prop==0]<-0
}

#### Investigation of potential systematic bias  
# Plots of observed abundant base ratios with 95 % confidence intervals calculated using binominal sampling theory.  
# Dashed lines indicate the expected abundant base proportions assumming 6 and 7 gene copies for _L. monocytogenes_ and _E. coli_ respecively.  p-values for logistic regression indicate statistical difference from the LGC "454" rep 1 dataset.  

vcf_ambigs$Location <- as.character(vcf_ambigs$POS)
vcf_ambigs$dataset <- str_replace_all(vcf_ambigs$dataset, pattern="-",replacement="\n")
##### _E. coli_ 6:1
ggplot(vcf_ambigs[vcf_ambigs$exp_ratio == "6:1",]) + 
  geom_point(aes(x = Location, y = prop)) + 
  geom_errorbar(aes(x = Location, ymin = lci, ymax = uci)) + 
  facet_wrap(~dataset, nrow = 1) +
  geom_hline(aes(yintercept = 1/7), linetype = 2) +
  geom_hline(aes(yintercept = 2/7), linetype = 2) +
  geom_hline(aes(yintercept = 3/7), linetype = 2) +
  geom_hline(aes(yintercept = 4/7), linetype = 2) +
  geom_hline(aes(yintercept = 5/7), linetype = 2) +
  geom_hline(aes(yintercept = 6/7), linetype = 2) +
  geom_hline(aes(yintercept = 1), linetype = 2) +
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 270)) +
  labs(y = "Abundant Base Proportion")
ggsave(str_c(figure_loc,"base_ratio_61.pdf", sep = ""))

##### _E. coli_ 4:3
ggplot(vcf_ambigs[vcf_ambigs$exp_ratio == "4:3",]) + 
  geom_point(aes(x = Location, y = prop)) + 
  geom_errorbar(aes(x = Location, ymin = lci, ymax = uci)) + 
  facet_grid(~dataset) +
  geom_hline(aes(yintercept = 1/7), linetype = 2) +
  geom_hline(aes(yintercept = 2/7), linetype = 2) +
  geom_hline(aes(yintercept = 3/7), linetype = 2) +
  geom_hline(aes(yintercept = 4/7), linetype = 2) +
  geom_hline(aes(yintercept = 5/7), linetype = 2) +
  geom_hline(aes(yintercept = 6/7), linetype = 2) +
  geom_hline(aes(yintercept = 1), linetype = 2) +
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 270)) +
  labs(y = "Abundant Base Proportion")
ggsave(str_c(figure_loc,"base_ratio_43.pdf", sep = ""))

##### _L. monocyotogenes_ 5:1
ggplot(vcf_ambigs[vcf_ambigs$exp_ratio == "5:1",]) + 
  geom_point(aes(x = Location, y = prop)) + 
  geom_errorbar(aes(x = Location, ymin = lci, ymax = uci)) + 
  facet_grid(~dataset) +
  geom_hline(aes(yintercept = 1/6), linetype = 2) +
  geom_hline(aes(yintercept = 2/6), linetype = 2) +
  geom_hline(aes(yintercept = 3/6), linetype = 2) +
  geom_hline(aes(yintercept = 4/6), linetype = 2) +
  geom_hline(aes(yintercept = 5/6), linetype = 2) +
  geom_hline(aes(yintercept = 1), linetype = 2) +
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 270)) +
  labs(y = "Abundant Base Proportion")
ggsave(str_c(figure_loc,"base_ratio_51.pdf", sep = ""))

##### _L. monocyotogenes_ 3:3
ggplot(vcf_ambigs[vcf_ambigs$exp_ratio == "3:3",]) + 
  geom_point(aes(x = Location, y = prop)) + 
  geom_errorbar(aes(x = Location, ymin = lci, ymax = uci)) + 
  facet_grid(~dataset) +
  geom_hline(aes(yintercept = 1/6), linetype = 2) +
  geom_hline(aes(yintercept = 2/6), linetype = 2) +
  geom_hline(aes(yintercept = 3/6), linetype = 2) +
  geom_hline(aes(yintercept = 4/6), linetype = 2) +
  geom_hline(aes(yintercept = 5/6), linetype = 2) +
  geom_hline(aes(yintercept = 1), linetype = 2) +
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 270)) +
  labs(y = "Abundant Base Proportion")
ggsave(str_c(figure_loc,"base_ratio_33.pdf", sep = ""))
