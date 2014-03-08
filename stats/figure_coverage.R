##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#########################%%%%%%%
##
## Coverage plot for CCQM identity work
## written by: Nate Olson
## May 2013
## Modified 2/9/2014 for reproducibility
##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#########################%%%%%%%

library(ggplot2)
library(reshape2)
library(stringr)

# user specific requirements
source("file_locations.R")

vcf_df <- read.csv(str_c(stat_data_loc, "merged_base_ratios.csv", sep = ""))
vcf_df <- cbind(vcf_df, 
                colsplit(string = vcf_df$dataset, 
                         pattern= "-", 
                         names = c("org", "plat", "lab","rep")))

ggplot(vcf_df) + 
  geom_path(aes(x = POS, 
		y = DP, 
		color = lab, 
		linetype = org, 
		group = dataset)) + 
  facet_wrap(~plat) + scale_y_log10() + 
  labs(y = "Coverage", x = "Reference Location (bp)", color = "Participants", linetype = "Organisms") +
  theme_bw() +
  theme(legend.position = "bottom", legend.direction = "horizontal")


ggsave(filename = str_c(figure_loc,"coverage.pdf", sep = "") ,width = 6, height = 4)