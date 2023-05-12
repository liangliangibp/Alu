H3K4me3="H3k4me3.peaks.narrowPeak.bed"
H3K27ac="null.bed"

perl 1.get_all_trans_promoter.pl gencode.v19.annotation.gtf

#########improve downstream region (in genebody), stop at the end of 3' most chipseq peak
bedtools intersect -a out2.downstream.bed -b $H3K4me3 $H3K27ac -names H3K4me3 H3K27ac -wa -wb > out3.downstream.anno.bed
perl 2.improve_downstream_boundary.pl out3.downstream.anno.bed > out4.downstream.improved.bed

#########improve upstream region (at intergenic), stop at the start of 5' most chipseq peak
bedtools intersect -a out1.upstream.bed -b $H3K4me3 $H3K27ac -names H3K4me3 H3K27ac -wa -wb > out5.upstream.anno.bed
perl 3.improve_upstream_boundary.pl out5.upstream.anno.bed > out6.leftmoset_chipseq_loci.upstream.bed
bedtools intersect -a out1.upstream.bed -b ../1.define_rough_promoter/hg19.intergenic_region.bed -wa -wb > out7.upstream_overlap_intergenic.bed
perl 4.get_intergenic_in_upstream.pl out7.upstream_overlap_intergenic.bed > out8.leftmost_intergenic_loci.upstream.bed
perl 5.integrate_ChIPseq_and_intergenic.for_upstream.pl out6.leftmoset_chipseq_loci.upstream.bed out8.leftmost_intergenic_loci.upstream.bed > out9.upstream.improved.bed

sh defenhrprmt.sh
perl require_active_or_poised_promoter.pl prmt.bed > prmt.NotInactive.bed
cat HeLaS3.prmt.NotInactive.bed | bedtools sort -i - | bedtools merge -i - > prmt.NotInactive.merge.bed
perl selected_transcribe_region.pl Result_Step8_feature_and_other.bed

#finally used
cat out4.downstream.improved.bed out9.upstream.improved.bed > prmt.raw_region.bed
bedtools intersect -a HeLa.prmt.raw_region.bed -b HeLaS3.prmt.NotInactive.merge.bed > prmt.raw_region.forNotInactive.bed
bedtools sort -i HeLa.prmt.raw_region.forNotInactive.bed | bedtools merge -i - > prmt.raw_region.forNotInactive.merge.bed
bedtools subtract -a prmt.raw_region.forNotInactive.merge.bed -b ../step2.define_Enhancer/stitched_enhancer.anno.notPrmt.notPCRNA.withID.bed > prmt.NotInactive.notEnhancer.bed
bedtools subtract -a prmt.NotInactive.notEnhancer.bed -b produce_RNA.bed > prmt.NotInactive.notEnhancer.notExon.bed
cat prmt.NotInactive.notEnhancer.notExon.bed | awk -v OFS='\t' '{print $1,$2,$3,"PT_"NR}' > prmt.NotInactive.notEnhancer.notExon.withID.bed
