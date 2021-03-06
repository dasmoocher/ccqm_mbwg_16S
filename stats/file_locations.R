## Specifying file directories
require(stringr)
setwd("../")
ccqm16S_loc <- getwd()
stat_data_loc <- str_c(ccqm16S_loc,"/stats/data/", sep = "")
bioinf_data_loc <- str_c(ccqm16S_loc,"/bioinf/results/", sep = "")
script_loc <- str_c(ccqm16S_loc,"/stats/", sep = "")
figure_loc <- str_c(ccqm16S_loc,"/pub/", sep = "")
sup_loc <- str_c(ccqm16S_loc,"/pub/", sep = "")
setwd(script_loc)
