# requirements for tables
source("../stats/file_locations.R")
require(stringr)
require(plyr)
require(reshape2)
require(ggplot2)

base_ratio_df <- read.csv(str_c(stat_data_loc, "biovar_table.csv"), stringsAsFactors = F)
base_ratio_df <- cbind(base_ratio_df, colsplit(base_ratio_df$dataset,"-",names=c("Org","Plat","Lab", "Rep")))
base_ratio_df$ds2 <- with(base_ratio_df, str_c(Plat, Lab, Rep, sep = " "))
base_ratio_df$ds2[base_ratio_df$Lab != "LGC" | base_ratio_df$Plat != "454"] <- str_replace(
    base_ratio_df$ds2[base_ratio_df$Lab != "LGC" | base_ratio_df$Plat != "454"], " 1","")
base_ratio_df$ds2[grep("Sanger-NIST",base_ratio_df$dataset)] <- "Sanger-Clone\nNIST"
base_ratio_df$ds2[grep("Sanger-LGC",base_ratio_df$dataset)] <- "Sanger-Clone\nLGC"

base_ratio_df$Org <- ifelse(base_ratio_df$Org == "Ecoli", "E. coli", "L. monocytogenes")

consensus_df <- ddply(base_ratio_df, .(Org, POS), summarize, base_ratio = unique(exp_ratio), Lab = "Consensus")
base_ratio_df$class <- base_ratio_df$Plat
base_ratio_df$class[base_ratio_df$Plat == "Sanger" & base_ratio_df$Lab %in% c("LGC", "NIST")] <- "Clone"
consensus_df$class <- ""
base_ratio_df <- rbind.fill(base_ratio_df, consensus_df)
base_ratio_df$class <- factor(base_ratio_df$class,levels = c("","454","Clone","ION","Sanger"))


base_ratio_df <- cbind(base_ratio_df, 
                       colsplit(base_ratio_df$base_ratio, 
                                pattern = ":",names = c("major","minor")))
label_df <- base_ratio_df[base_ratio_df$max_prob < 0.95 & !is.na(base_ratio_df$max_prob),]
label_df$max_prob <- round(label_df$max_prob, digits = 2)

ggplot(base_ratio_df) + 
    geom_raster(aes(x = as.factor(POS),y = Lab, fill = as.factor(major))) + 
    geom_text(data = label_df,
              aes(x = as.factor(POS),y = Lab, label = max_prob)) +
    facet_grid(class~Org, scale = "free", space = "free") +
    labs(x = "Location", y = "Dataset", fill = "Major Variant\nCopy Number") +
    theme_bw() +
    theme(strip.text.x = element_text(size = 12, face = "italic"),
          #strip.text.y = element_blank(),
          strip.background = element_blank(), legend.position = "bottom",legend.direction = "horizontal")
ggsave(str_c(figure_loc,"variant_copy_ratio_heatmap.png", sep = ""), height = 4, width=8)
