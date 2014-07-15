# calculating likelihood and chimeria rates for variant string combinations for
# individual and data set totals

# user specific requirements
source("file_locations.R")

#required packages
require(reshape2)
require(stringr)
require(plyr)
require(gtools)

#functions
get_org_vs_df <- function(org, vs = vs_table){
  pat <- str_c(org,"*", sep = "")
  vs <- vs[grep(pat, vs$dataset, value = F),]
  vs_total <-ddply(vs, .(variant_string), summarize, counts = sum(counts))
  vs_total$dataset <- str_c(org, "Total", sep = "-")
  rbind(vs, vs_total)
}

pat_combos <- function(pat_names, gene_copies){
  # creates a matrix of all possible variant combinations for a specified number of gene copies
  combinations(n = length(pat_names), r = gene_copies, v = pat_names, repeats.allowed= TRUE)
}

P.vec.ec<-function(p.switch ,allele.ind, pats){
  # variant string probability vectors for E. coli
  p.vec<-NULL
  for(i in 1:nrow(pats)){
    p.vec<-c(p.vec,(1-p.switch)*mean(allele.ind==i)+
               p.switch*mean(pats[allele.ind,2]==pats[i,2]))
  }
  p.vec
}

P.vec.lm<-function(p.switch, allele.ind, pats){
  # variant string probability vectors for L. monocytogenes
  p.switch.short<-1-(1-p.switch)^13
  p.switch.long<-1-(1-p.switch)^131
  p.vec<-NULL
  for(i in 1:nrow(pats)){
    p.vec<-c(p.vec,(1-p.switch.short)*(1-p.switch.long)*mean(allele.ind==i)+
               (1-p.switch.short)*p.switch.long*mean(paste(pats[allele.ind,1],pats[allele.ind,2])==paste(pats[i,1],pats[i,2]))*mean(pats[allele.ind,3]==pats[i,3])+
               p.switch.short*(1-p.switch.long)*mean(paste(pats[allele.ind,2],pats[allele.ind,3])==paste(pats[i,2],pats[i,3]))*mean(pats[allele.ind,1]==pats[i,1])+
               p.switch.short*p.switch.long*mean(pats[allele.ind,1]==pats[i,1])*mean(pats[allele.ind,2]==pats[i,2])*mean(pats[allele.ind,3]==pats[i,3]))
  }
  p.vec
}

likelihood_fun <-function(p.switch, allele.ind, dat, P.fun, pats){
  # variant string likelihood function
  -dmultinom(dat,prob=P.fun(p.switch, allele.ind, pats),log=TRUE)
} 

pat_like <- function(counts, vs_combo, pats, P.fun, like = likelihood_fun){
    fit<-optimize(like,c(0,1),allele.ind=vs_combo,dat=counts, P.fun, pats)
    c(vs_combo,fit$minimum,fit$objective)
}

comb_like_calc <- function(df, org, vs_combinations, pats, P.fun){
  #iterate through datasets
  vs_stats <- data.frame()
  for(ds in unique(df$dataset)){
    ds_counts <- df[df$dataset == ds, "counts"]
    #iterate through string sets
    ds_vs_stats <- data.frame()
    for(i in 1:nrow(vs_combinations)){
      ds_vs_stats <- rbind(ds_vs_stats, pat_like(ds_counts, vs_combinations[i,], pats, P.fun))
    }
    ds_vs_stats$dataset <- ds
    vs_stats <- rbind(vs_stats, ds_vs_stats)
  }
  colnames(vs_stats) <- c(str_c("gc", 1:ncol(vs_combinations), sep = "-"),"likelihood","chimera", "dataset")
  return(vs_stats)
}

# loading variant string data
variant_df <- read.csv(str_c(stat_data_loc, "string_tables_filtered.csv", sep = ""))

# calculate likelihood and chimera
## Ecoli
ec_pats <-cbind(rep(0:1,each=2),rep(0:1,2))
ec_vs_combinations <- pat_combos(pat_names=1:nrow(ec_pats), gene_copies= 7)
ecoli_variant_df <- get_org_vs_df("Ecoli", vs = variant_df)
ecoli_vs_stats <- comb_like_calc(ecoli_variant_df,"Ecoli",ec_vs_combinations, pats = ec_pats, P.fun = P.vec.ec)
write.csv(ecoli_vs_stats, str_c(stat_data_loc,"string_stats_ecoli.csv", sep = ""), row.names = FALSE)

## Lmono
lm_pats <-cbind(rep(0:1,each=4),c(0,0,1,1,0,0,1,1),rep(0:1,4))
lm_vs_combinations <- pat_combos(pat_names=1:nrow(lm_pats), gene_copies= 6)
lmono_variant_df <- get_org_vs_df("Lmono", vs = variant_df)
lmono_vs_stats <- comb_like_calc(lmono_variant_df,"Lmono",lm_vs_combinations, pats = lm_pats, P.fun = P.vec.lm)
write.csv(lmono_vs_stats, str_c(stat_data_loc,"string_stats_lmono.csv", sep = ""), row.names = FALSE)
