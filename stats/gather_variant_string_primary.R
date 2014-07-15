# generating variant string copy numbers 

# user specific requirements
source("file_locations.R")

#required packages
require(reshape2)
require(stringr)
require(plyr)

#functions
get_strings <- function(sam){
  # take output from SAM_parse.py and creates 
  # a dataframe with read names with variants 
  # strings for each read
  sam_df <- read.table(sam, header = T, sep = ",")
  sam_df <- sam_df[sam_df$ref_position < 1450,]
  sam_cast <- dcast(sam_df, read_name~ref_position,value.var = "base_call")
  remove(sam_df)  
  sam_cast[,"117"] <- NULL
  sam_cast <- sam_cast[complete.cases(sam_cast),]
  sam_strings <- data.frame(read_name = sam_cast$read_name, 
                            variant_string = do.call("paste", c(sam_cast[,-1], sep = "")))
  string_counts <- dcast(sam_strings, variant_string~.)
  colnames(string_counts) <- c("variant_string","counts")
  return(string_counts)
}

read_table <- function(filename){
  # loading parsed sam files and generating data frames with variant string counts
  string_counts <- get_strings(filename)
  if(nrow(string_counts) == 0){
    return(NULL)
  }
  ds <- filename
  ds <-str_replace(ds, pattern="-TMAP-refine.csv", replace="")
  string_counts$dataset <- ds
  return(string_counts)
}


#### Generating the variant string count data frame
setwd(bioinf_data_loc)
sam_tables <- list.files()[grep("454.*TMAP-refine.csv", c(list.files()), value = F)]
sam_tables <- c(sam_tables, list.files()[grep("*Sanger-Clones.csv", c(list.files()), value = F)])
string_df <- ldply(sam_tables, failwith(NULL, read_table))
setwd(script_loc)

# writing data frame to disk
write.csv(string_df, paste(stat_data_loc,"string_tables.csv", sep = ""), row.names = FALSE)
