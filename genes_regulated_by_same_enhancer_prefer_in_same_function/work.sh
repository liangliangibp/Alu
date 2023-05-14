
cell=(GM12878 H1 HepG2 hNPCS IMR90 K562 HeLa)
for var in ${cell[@]};
do
python target_gene_random_GO.py $var'_ep_gene.txt' $var'_ep_gene.txt' > $var'_result.txt'


done
