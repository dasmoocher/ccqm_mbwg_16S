## Specifying file directories
require(stringr)
ccqm16S_loc <- "~/Desktop/ccqm_mbwg_16S/"
stat_data_loc <- str_c(ccqm16S_loc,"stats/data/", sep = "")
bioinf_data_loc <- str_c(ccqm16S_loc,"bioinf/results/", sep = "")
script_loc <- str_c(ccqm16S_loc,"stats/", sep = "")
figure_loc <- str_c(ccqm16S_loc,"pub/figures/", sep = "")
tables_loc <- str_c(ccqm16S_loc,"pub/tables/", sep = "")
sup_loc <- str_c(ccqm16S_loc,"pub/supplemental/", sep = "")