# user specific requirements
source("file_locations.R")

# script for creating base count and coverage files for coverage figures and base ratio analysis
library(stringr)
library(reshape2)
library(plyr)


read_table <- function(filename){
  stat_table <- read.table(filename, 
                          sep="\t", header = FALSE, na.strings = NA, stringsAsFactors = F)
  ds <- filename
  ds <-str_replace(ds, pattern="-fastq-stats.txt", replace="")
  stat_table$dataset <- ds
  return(stat_table[stat_table$V1 %in% c("stats_info","stats_len"),])
}

setwd(bioinf_data_loc)
stat_tables <- list.files()[grep("*fastq-stats.txt", c(list.files()), value = F)]
stat_df <- ldply(stat_tables, read_table)
colnames(stat_df) <- c("metric","variable","value", "dataset")
stat_df$metric <- str_replace(stat_df$metric, "stats_","")
setwd(script_loc)
write.csv(stat_df, str_c(stat_data_loc, "merged_fastq_stats.csv", sep = ""), row.names = FALSE)