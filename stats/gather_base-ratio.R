# user specific requirements
source("file_locations.R")

# script for creating base count and coverage files for coverage figures and base ratio analysis
library(stringr)
library(reshape2)
library(plyr)

read_table <- function(filename){
  print(filename)
  vcf_table <- read.table(filename, 
                          sep="\t", header = TRUE, na.strings = NA)
  ds <-str_replace(filename, pattern="-TMAP-refine-Full-Table.tsv", replace="")
  vcf_table$dataset <- ds
  return(vcf_table)
}

setwd(bioinf_data_loc)
vcf_tables <- list.files()[grep("*TMAP-refine-Full-Table.tsv", c(list.files()), value = F)]
vcf_df <- ldply(vcf_tables, failwith(NULL, read_table))
vcf_df <- cbind(vcf_df, colsplit(vcf_df$BaseCounts, pattern=",", names=c("A","C","G","T")))
vcf_df$BaseCounts <- NULL
setwd(script_loc)
write.csv(vcf_df, str_c(stat_data_loc, "merged_base_ratios.csv", sep = ""), row.names = FALSE)
