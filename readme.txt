 

snp_based_on_sequence.m(+select_func.m)
purpose：find homeologous single nucleotide polymorphisms (SNPs) matched to the sequences of the putative paternal parents E. equisetina-E. minuta-E. monosperma and the maternal parents E. przewalskii-E. regeliana in the alignment of one-to-one orthologous groups (OGs) 
Input file: the alignment of one-to-one orthologous groups
Output file: a table includes the information of SNPs


poly_curve.m
purpose：figure the saturation curve between the logarithmic number of consensus transcripts and the logarithmic number of expressed OGs
Input file: a table includes the results of sub_datesets
Output file: Figure 1

gaussian_analysis.m (+BICGaussianMixture1DFunc.m)
purpose：used to identify significant peaks in the Ks distribution with the best fitting model selected based on Bayesian information criterion (BIC) scores
Input file: a table inculdes the values of Ks
Outputfile: Figure 2b

SNP_analysis.m
purpose：classify SNPs into heterozygous sites (SPM) that have fixed differences between two subgenomes for polyploid samples, or homozygous sites (SPP or SMM) that are only shared with maternal or paternal parents, where PP and MM represent paternal and maternal homozygosities, respectively
Input file: a table inculdes informations 'id of transcripts','the position of SNP sites','sites of KB_F','sites of E.equisetina','sites of E.regeliana'
Outputfile: a table inculdes informations 'id of transcripts','the position of SNP sites','sites of KB_F','sites of E.equisetina','sites of E.regeliana' and 'type of SNPs'

