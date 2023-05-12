## define enhancers and promoters
H3K4me1="H3k04me1.peaks.narrowPeak.bed"
H3K4me3="H3k4me3.peaks.narrowPeak.bed"
H3K27ac="H3k27ac.peaks.narrowPeak.bed"
null="null.bed"

prmtg="../step1.define_rough_promoter/rough_AllGene_promoter_region.in_genome.bed"

prmt="prmt.bed"

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
END{    OFS = "\t"
        for(k in D) {
                split(k, X, ","); v = D[k]-1
                print X[1], X[2], X[3], X[4], v, X[5]
        }
}
' | sort -k1,1 -k2,2n > $prmt

