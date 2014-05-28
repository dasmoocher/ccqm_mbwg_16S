
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
# 
vcf_ambigs$Location <- factor(vcf_ambigs$POS) #, levels = c(118,175,188,419,975,983,992:996,1011,1395))
vcf_ambigs$dataset <- str_replace_all(vcf_ambigs$dataset, pattern="-",replacement="\n")
vcf_ambigs$org <- "ecoli"
vcf_ambigs$org[grepl("Lmono", vcf_ambigs$dataset)] <- "lmono"
vcf_ambigs$dataset <- str_replace(vcf_ambigs$dataset, pattern="Ecoli\n",replacement="")
vcf_ambigs$dataset <- str_replace(vcf_ambigs$dataset, pattern="Lmono\n",replacement="")
vcf_ambigs$dataset[vcf_ambigs$dataset == "Sanger\nNIST\n1"] <- "Sanger\nClone\nNIST"
vcf_ambigs$dataset[vcf_ambigs$dataset == "Sanger\nLGC\n1"] <- "Sanger\nClone\nLGC"
vcf_ambigs$dataset[vcf_ambigs$dataset == "Sanger\nATCC\n1"] <- "Sanger\nATCC"
vcf_ambigs$dataset[vcf_ambigs$dataset == "Sanger\nISP\n1"] <- "Sanger\nISP"
vcf_ambigs$dataset[vcf_ambigs$dataset == "454\nNMIA\n1"] <- "454\nNMIA"
vcf_ambigs$dataset[vcf_ambigs$dataset == "ION\nNIMC\n1"] <- "ION\nNIMC"
vcf_ambigs$dataset[vcf_ambigs$dataset == "ION\nNIST\n1"] <- "ION\nNIST"

ggplot(vcf_ambigs[vcf_ambigs$org == "lmono",]) + 
    geom_point(aes(x = dataset, y = prop, color = dataset)) + 
    geom_errorbar(aes(x = dataset, ymin = lci, ymax = uci, color = dataset)) + 
    facet_wrap(~Location, ncol = 1) +
    geom_hline(aes(yintercept = 0), linetype = 2, alpha = 0.5) +
    geom_hline(aes(yintercept = 1/6), linetype = 2, alpha = 0.5) +
    geom_hline(aes(yintercept = 2/6), linetype = 2, alpha = 0.5) +
    geom_hline(aes(yintercept = 3/6), linetype = 2, alpha = 0.5) +
    geom_hline(aes(yintercept = 4/6), linetype = 2, alpha = 0.5) +
    geom_hline(aes(yintercept = 5/6), linetype = 2, alpha = 0.5) +
    geom_hline(aes(yintercept = 1), linetype = 2, alpha = 0.5) +
    theme_bw() + 
    theme(legend.position = "none") +
    labs(y = "Abundant Base Ratio", x = "Dataset", color = "Dataset")
ggsave(str_c(figure_loc,"base_ratio_lmono.pdf", sep = ""), height = 8, width=6)

ggplot(vcf_ambigs[vcf_ambigs$org == "ecoli",]) + 
    geom_point(aes(x = dataset, y = prop, color = dataset)) + 
    geom_errorbar(aes(x = dataset, ymin = lci, ymax = uci, color = dataset)) + 
    facet_wrap(~Location) +
    geom_hline(aes(yintercept = 0), linetype = 2, alpha = 0.5) +
    geom_hline(aes(yintercept = 1/7), linetype = 2, alpha = 0.5) +
    geom_hline(aes(yintercept = 2/7), linetype = 2, alpha = 0.5) +
    geom_hline(aes(yintercept = 3/7), linetype = 2, alpha = 0.5) +
    geom_hline(aes(yintercept = 4/7), linetype = 2, alpha = 0.5) +
    geom_hline(aes(yintercept = 5/7), linetype = 2, alpha = 0.5) +
    geom_hline(aes(yintercept = 6/7), linetype = 2, alpha = 0.5) +
    geom_hline(aes(yintercept = 1), linetype = 2, alpha = 0.5) +
    theme_bw() + 
    theme(legend.position = "bottom", legend.direction = "horizontal",
          axis.text.x = element_blank()) +
    labs(y = "Abundant Base Ratio", x = "Dataset", color = "Dataset")
ggsave(str_c(figure_loc,"base_ratio_ecoli.pdf", sep = ""), height = 8, width=8)
