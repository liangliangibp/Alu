## define enhancers and promoters
H3K4me1="H3k04me1.peaks.narrowPeak.bed"
H3K4me3="H3k4me3.peaks.narrowPeak.bed"
H3K27ac=".H3k27ac.peaks.narrowPeak.bed"
null="null.bed"
prmtg="../step1.define_rough_promoter/rough_PCgene_promoter_region.in_genome.bed"
H3K27acbam="H3k27ac.Merge.sort.bam"
H3K4me1bam="H3k04me1.Merge.sort.bam"
H3K4me3bam="H3k4me3.Merge.sort.bam"

prmt="prmt.bed"
enhr="enhancer.feature_count.bed"
enhc="enhancer.bed"
stitched="stitched_enhancer.bed";
stitchedr="stitched_enhancer.count.bed";

## promoter: TSS
## p1. active promoter: H3K4me3+, H3K27ac+
## p2. poised promoter: H3K4me3+, H3K27ac-
## p3. inactive promoter: H3K4me3-, H3K27ac-
bedtools intersect -F 0.5 -loj -a $prmtg -b $H3K4me3 $null -names H3K4me3 H3K27ac | \
cut -f1-7 | sort -u -k1,1 -k2,2n -k7,7r | \
awk '{
	sid = $1","$2","$3","$4","$6;
	D[sid] = 1
	if($7 == "H3K4me3") D[sid] = 2
	if($7 == "H3K27ac") D[sid] = 3
}
END{	OFS = "\t"
	for(k in D) {
		split(k, X, ","); v = D[k]-1
		print X[1], X[2], X[3], X[4], v, X[5]
	}
}
' | sort -k1,1 -k2,2n > $prmt

## enhancer: not promoter, clustered with 12.5k
## e1. active enhancer: H3K27ac+
## e2. poised enhancer: H3K4me1+, H3K27ac-
cat $H3K27ac $H3K4me1 | sort -k1,1 -k2,2n | bedtools merge -i - | \
bedtools intersect -loj -a - -b $H3K27ac | \
cut -f1-4 | sort -u -k1,1 -k2,2n -k4,4 | \
awk '{
	sid = $1 "\t" $2 "\t" $3;
	D[sid] = 1
	if($4 == $1) D[sid] = 2
}
END{	OFS = "\t"
	for(k in D) {
		v = D[k]-1
		print k, v
	}
}
' | sort -k1,1 -k2,2n > $enhc


awk '$5>0' $prmt | \
bedtools intersect -v -f 0.5 -a $enhc -b - > $enhr

bedtools merge -d 12500 -i $enhr | \
awk 'BEGIN{OFS="\t"} {print $1, $2, $3, "ECID:" NR}' > $stitched 

bedtools merge -d 12500 -i $enhr | \
awk 'BEGIN{OFS="\t"} {print $1, $2, $3, "ECID:" NR}' | \
bedtools intersect -loj -a $enhr -b - -names EC | \
awk 'BEGIN{OFS="\t"} {print $1, $2, $3, $8, $4}' > $enhc


## Enhancer coverage by H3K27ac, H3K4me3, H3K4me1
bedtools multicov -bed $enhc -bams $H3K27acbam $H3K4me3bam $H3K4me1bam > $enhr
bedtools multicov -bed $stitched -bams $H3K27acbam > $stitchedr

