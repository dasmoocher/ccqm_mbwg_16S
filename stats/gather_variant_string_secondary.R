###
#
# Input variant string table filter by possible variant combinations
# fill in missing counts with 0
#
###

# packages
require(dplyr)

# user specific requirements
source("file_locations.R")

# read variant string table - generated using merge_variant-string.R
vs_table <- read.csv(paste(stat_data_loc, "string_tables.csv", sep = ""))

###
# 
# create filtered table 
#
###
get_ds <- function(org, vs = vs_table){
  pat <- paste(org,"*", sep = "")
  datasets <- unique(as.character(vs$dataset))
  datasets[grep(pat, datasets, value = F)]
}

vs_filter_skeleton <- function(variants, ds){
  data.frame(dataset = rep(ds, each = length(variants)), variant_string = rep(variants, length(ds)))
}

### Creating skeleton data frames for each org
## E. coli
ecoli_variants <- c("ACCGATTGTA", "ACCGATTGTG", "GGTAGAATCA", "GGTAGAATCG")
ecoli_datasets <- get_ds("Ecoli")
ecoli_vs_filter <- vs_filter_skeleton(ecoli_variants, ecoli_datasets)

## L. monocytogenes
lmono_variants <- c("GCA","GCG","GTA","GTG","TCA","TCG","TTA","TTG")
lmono_datasets <- get_ds("Lmono")
lmono_vs_filter <- vs_filter_skeleton(lmono_variants, lmono_datasets)

### Adding variant string counts to skeleton data frames from vs_table
vs_filter <- rbind(lmono_vs_filter, ecoli_vs_filter)
vs_filter <- left_join(vs_filter, 
                             vs_table[,c("dataset","variant_string","counts")], 
                             by = c("dataset", "variant_string"))
vs_filter$counts[is.na(vs_filter$counts)] <- 0

# writing data frame to disk
write.csv(vs_filter, paste(stat_data_loc,"string_tables_filtered.csv", sep = ""), row.names = FALSE)
