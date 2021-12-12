cell=(GM12878 H1 HeLa HepG2 hNPC IMR90 K562)
chimericReadsPath=../../source_data/EPchimericReads
for var in ${cell[@]};
do
python MacthAluInReadsInterval.py $chimericReadsPath/$var'_merge.enhancerReads_link_Promoter.sam' $chimericReadsPath/$var'_merge.promoterReads_link_Enhancer.sam' $chimericReadsPath/$var'_merge.enhancerReads_link_Promoter.bed' $chimericReadsPath/$var'_merge.promoterReads_link_Enhancer.bed' ../../source_data/hg19_Alu_fa_out_direction_.bed  

python StatisticDirection.py $var'_findMatchedAluInReads.txt'

done
