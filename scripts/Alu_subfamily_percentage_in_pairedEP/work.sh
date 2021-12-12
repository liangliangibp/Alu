cell=(GM12878 H1 HeLa HepG2 hNPC IMR90 K562)
EPchimericBedPath=../../source_data/EPchimericReads/
for var in ${cell[@]};

do

bedtools intersect -a $EPchimericBedPath/$var'_merge.enhancerReads_link_Promoter.bed' -b ../../source_data/hg19_Alu_fa_out_.bed -wa -wb |less -S > $var'_merge.enhancerReads_link_Promoter_Alu.bed'
bedtools intersect -a $EPchimericBedPath/$var'_merge.promoterReads_link_Enhancer.bed' -b ../../source_data/hg19_Alu_fa_out_.bed -wa -wb |less -S > $var'_merge.promoterReads_link_Enhancer_Alu.bed'

python 1_merge_readsID_E_P.py $var'_merge.enhancerReads_link_Promoter_Alu.bed' $var'_merge.promoterReads_link_Enhancer_Alu.bed' 

python 2_same_Alu_E_P_reads.py $var'_merged_EPreadsid.txt'
python 3_random_Alu_same_ratio.py $var'_merged_EPreadsid.txt' 1000 > $var'_random_same_Alu.txt'

done
