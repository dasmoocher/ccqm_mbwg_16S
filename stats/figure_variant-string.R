# Script to generate variant string figure

# user specific requirements
source("file_locations.R")

# required packages
library(ggplot2)
library(reshape2)
library(plyr)
library(stringr)



#loading data
biovar <- read.csv(str_c(stat_data_loc, "string_tables_filtered.csv", sep = ""))
#colnames(biovar) <- c("variants","LGC 454 Rep 1", "LGC 454 Rep 2", "LGC 454 Rep 3", "NMIA 454", "LGC Sanger", "NIST Sanger")
#biovarm <- melt(biovar)
#biovarm <- rename(biovarm, replace= c("variable" = "dataset"))
biovar <-ddply(biovar, "dataset", transform,
               prop = counts / sum(counts), 
               n = sum(counts))
biovar$lci <- qbinom(0.025, biovar$n, biovar$prop)/biovar$n
biovar$uci <- qbinom(0.975, biovar$n, biovar$prop)/biovar$n

biovar$org <- "E. coli"
biovar$org[grep("Lmono*",biovar$dataset)] <- "L. monocytogenes"

# #cleaning up the data
# biovarm$dataset <- factor(biovarm$dataset, 
#                          levels = c("LGC Sanger", "NIST Sanger","LGC 454 Rep 1", 
#                                     "LGC 454 Rep 2", "LGC 454 Rep 3", "NMIA 454"))
biovar$variant_string <- factor(biovar$variant_string, levels = c("GCG","GTG","TCG", "GTA", "GCA", "TCA", "TTA", "TTG",       
                                                        "ACCGATTGTA","ACCGATTGTG","GGTAGAATCG","GGTAGAATCA"))

expected <- data.frame(variant_string = levels(biovar$variant_string), 
                       prop = c(c(2,2,1,1,0,0,0,0)/6,c(3,3,1,0)/7), 
                       org = c(rep("L. monocytogenes",8),rep("E. coli", 4)))

#plotting
biovar_plot <- function(org){
  bvp <-  ggplot(biovar[biovar$org == org,]) + 
    geom_bar(aes(x = dataset, y = prop, fill = dataset), 
             position = "dodge", stat = "identity") + 
    geom_errorbar(aes(x = dataset, ymin = lci, ymax = uci)) +
    geom_hline(data = expected[expected$org == org,], aes(yintercept = prop), linetype = 2) +
    theme_bw() +
    theme(strip.text = element_text(face = "italic"), 
          legend.position = "bottom", legend.direction = "horizontal") +
    labs(x = "Variant String", y = "Observed Proportion", fill = "Dataset") + 
    facet_grid(org~variant_string, scale = "free_x")
  return(bvp)
}


for(i in c("E. coli", "L. monocytogenes")){
  name <- str_c(figure_loc, str_replace(i,". ",""), "_var_strings",".pdf", sep = "")
  ggsave(name, biovar_plot(i),width = 8, height = 4)
}
