Description of variables in data files used in statistical analysis
========================================================


### merged_base_ratios.csv


<!-- html table generated in R 3.0.3 by xtable 1.7-3 package -->
<!-- Mon Jun  2 16:30:56 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> Variable </TH> <TH> Description </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> metric </TD> <TD> info - informational value, len - length summary statistic </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> variable </TD> <TD> type of information value or summary statistic </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> value </TD> <TD> information or summary statistica value </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> dataset </TD> <TD> source dataset </TD> </TR>
   </TABLE>

### merged_base_ratios.csv


<!-- html table generated in R 3.0.3 by xtable 1.7-3 package -->
<!-- Mon Jun  2 16:30:57 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> Variable </TH> <TH> Description </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> REF </TD> <TD> Reference Base </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> POS </TD> <TD> Reference Position </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> DP </TD> <TD> Approximate read depth (reads with MQ=255 or with bad mates are filtered) </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> QUAL </TD> <TD> Quality values assigned by variant caller </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> MQ </TD> <TD> RMS Mapping Quality </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> AF </TD> <TD> Allele Frequency, for each ALT allele, in the same order as listed </TD> </TR>
  <TR> <TD align="right"> 7 </TD> <TD> AN </TD> <TD> Number of observed alleles </TD> </TR>
  <TR> <TD align="right"> 8 </TD> <TD> Dels </TD> <TD> Fraction of Reads Containing Spanning Deletions </TD> </TR>
  <TR> <TD align="right"> 9 </TD> <TD> FS </TD> <TD> Phred-scaled p-value using Fisher's exact test to detect strand bias </TD> </TR>
  <TR> <TD align="right"> 10 </TD> <TD> HaplotypeScore </TD> <TD> Consistency of the site with at most two segregating haplotypes </TD> </TR>
  <TR> <TD align="right"> 11 </TD> <TD> dataset </TD> <TD> Sequencing dataset </TD> </TR>
  <TR> <TD align="right"> 12 </TD> <TD> A </TD> <TD> Number of As at the position </TD> </TR>
  <TR> <TD align="right"> 13 </TD> <TD> C </TD> <TD> Number of Cs at the position </TD> </TR>
  <TR> <TD align="right"> 14 </TD> <TD> G </TD> <TD> Number of Gs at the position </TD> </TR>
  <TR> <TD align="right"> 15 </TD> <TD> T </TD> <TD> Number of Ts at the position </TD> </TR>
   </TABLE>


### biovar_table.csv


<!-- html table generated in R 3.0.3 by xtable 1.7-3 package -->
<!-- Mon Jun  2 16:30:57 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> Variable </TH> <TH> Description </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> REF </TD> <TD> Reference Base </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> POS </TD> <TD> Reference Position </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> DP </TD> <TD> Approximate read depth (reads with MQ=255 or with bad mates are filtered) </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> QUAL </TD> <TD> Quality values assigned by variant caller </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> MQ </TD> <TD> RMS Mapping Quality </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> AF </TD> <TD> Allele Frequency, for each ALT allele, in the same order as listed </TD> </TR>
  <TR> <TD align="right"> 7 </TD> <TD> AN </TD> <TD> Number of observed alleles </TD> </TR>
  <TR> <TD align="right"> 8 </TD> <TD> Dels </TD> <TD> Fraction of Reads Containing Spanning Deletions </TD> </TR>
  <TR> <TD align="right"> 9 </TD> <TD> FS </TD> <TD> Phred-scaled p-value using Fisher's exact test to detect strand bias </TD> </TR>
  <TR> <TD align="right"> 10 </TD> <TD> HaplotypeScore </TD> <TD> Consistency of the site with at most two segregating haplotypes </TD> </TR>
  <TR> <TD align="right"> 11 </TD> <TD> dataset </TD> <TD> Sequencing dataset </TD> </TR>
  <TR> <TD align="right"> 12 </TD> <TD> A </TD> <TD> Number of As at the position </TD> </TR>
  <TR> <TD align="right"> 13 </TD> <TD> C </TD> <TD> Number of Cs at the position </TD> </TR>
  <TR> <TD align="right"> 14 </TD> <TD> G </TD> <TD> Number of Gs at the position </TD> </TR>
  <TR> <TD align="right"> 15 </TD> <TD> T </TD> <TD> Number of Ts at the position </TD> </TR>
  <TR> <TD align="right"> 16 </TD> <TD> prop </TD> <TD> Major base proportion (Y/N) </TD> </TR>
  <TR> <TD align="right"> 17 </TD> <TD> max_copy </TD> <TD> Major base gene copy number with the maximum probablility </TD> </TR>
  <TR> <TD align="right"> 18 </TD> <TD> max_prob </TD> <TD> Probability of max_copy </TD> </TR>
  <TR> <TD align="right"> 19 </TD> <TD> N </TD> <TD> Number of major and minor bases </TD> </TR>
  <TR> <TD align="right"> 20 </TD> <TD> Y </TD> <TD> Number of major bases </TD> </TR>
  <TR> <TD align="right"> 21 </TD> <TD> exp_ratio </TD> <TD> Consensus base ratio </TD> </TR>
  <TR> <TD align="right"> 22 </TD> <TD> total_copy </TD> <TD> Number of 16S rRNA gene copies in the genome </TD> </TR>
  <TR> <TD align="right"> 23 </TD> <TD> min_copy </TD> <TD> Minor base gene copy number, for max_copy </TD> </TR>
  <TR> <TD align="right"> 24 </TD> <TD> base_ratio </TD> <TD> Base copy ratio with the highest probability for the dataset </TD> </TR>
   </TABLE>

### string_stats[_ecoli | lmono].csv


<!-- html table generated in R 3.0.3 by xtable 1.7-3 package -->
<!-- Mon Jun  2 16:30:57 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> Variable </TH> <TH> Description </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> gc.1 </TD> <TD> Estimated variant combination for gene copy 1 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> gc.2 </TD> <TD> Estimated variant combination for gene copy 2 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> gc.3 </TD> <TD> Estimated variant combination for gene copy 3 </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> gc.4 </TD> <TD> Estimated variant combination for gene copy 4 </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> gc.5 </TD> <TD> Estimated variant combination for gene copy 5 </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> gc.6 </TD> <TD> Estimated variant combination for gene copy 6 </TD> </TR>
  <TR> <TD align="right"> 7 </TD> <TD> gc.7 </TD> <TD> Estimated variant combination for gene copy 7, L. monocytogenes only has 6 gene copies </TD> </TR>
  <TR> <TD align="right"> 8 </TD> <TD> likelihood </TD> <TD> Likelihood for set of variant combination </TD> </TR>
  <TR> <TD align="right"> 9 </TD> <TD> chimera </TD> <TD> Probability of a chimera event </TD> </TR>
  <TR> <TD align="right"> 10 </TD> <TD> dataset </TD> <TD> Dataset used to estimate the set of variant combinations </TD> </TR>
   </TABLE>


### string_tables_filtered.csv


<!-- html table generated in R 3.0.3 by xtable 1.7-3 package -->
<!-- Mon Jun  2 16:30:57 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> Variable </TH> <TH> Description </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> variant_string </TD> <TD> Combinations of bases at biologically variable positions </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> counts </TD> <TD> Number of reads with the combinations of variants </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> dataset </TD> <TD> source sequence dataset </TD> </TR>
   </TABLE>

