## Specifying file directories
require(stringr)
ccqm16S_loc <- "~/Desktop/MBWG/ccqm_16S/"
stat_data_loc <- str_c(ccqm16S_loc,"ccqm_16S_stats/data/", sep = "")
bioinf_data_loc <- str_c(ccqm16S_loc,"ccqm_16S_bioinformatics/results/", sep = "")
script_loc <- str_c(ccqm16S_loc,"ccqm_16S_stats/", sep = "")
figure_loc <- str_c(ccqm16S_loc,"ccqm_16S_pub/figures/", sep = "")
tables_loc <- str_c(ccqm16S_loc,"ccqm_16S_pub/tables/", sep = "")
sup_loc <- str_c(ccqm16S_loc,"supplemental/", sep = "")