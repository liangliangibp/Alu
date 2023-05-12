#perl 1.get_pc_trans_promoter.pl gencode.v19.annotation.gtf > rough_PCgene_promoter_region.bed
#bedtools intersect -a rough_PCgene_promoter_region.bed -b hg19.chr.bed > rough_PCgene_promoter_region.in_genome.bed

perl 2.get_all_trans_promoter.pl gencode.v19.annotation.gtf > rough_AllGene_promoter_region.bed
bedtools intersect -a rough_AllGene_promoter_region.bed -b hg19.chr.bed > rough_AllGene_promoter_region.in_genome.bed

#perl 3.get_all_trans.pl gencode.v19.annotation.gtf > all_trans.bed
#bedtools subtract -a hg19.chr.bed -b all_trans.bed > hg19.intergenic_region.bed
