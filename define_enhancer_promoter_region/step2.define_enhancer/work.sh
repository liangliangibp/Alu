sh defenhrprmt.sh
perl stitch_enhancer.pl enhancer.feature_count.bed > stitched_enhancer.feature_count.bed
Rscript gridRsub.getSuperEnhancerCutoff.R stitched_enhancer.feature_count.bed #we got Count_cuffoff
perl collect_enhancer_superEnhancer.pl stitched_enhancer.feature_count.bed Count_cuffoff > stitched_enhancer.anno.bed
perl selected_PCtranscribe_region.pl Result_Step8_feature_and_other.bed 
bedtools subtract -a stitched_enhancer.anno.bed -b prmt.bed > stitched_enhancer.anno.notPrmt.bed
bedtools subtract -a stitched_enhancer.anno.notPrmt.bed -b produce_PCRNA.bed > stitched_enhancer.anno.notPrmt.notPCRNA.bed 
perl reName_sonOfEnhancer.pl stitched_enhancer.anno.notPrmt.notPCRNA.bed > stitched_enhancer.anno.notPrmt.notPCRNA.withID.bed 



