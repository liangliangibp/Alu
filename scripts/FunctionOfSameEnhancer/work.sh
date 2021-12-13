cell=(GM12878 H1 HepG2 hNPC IMR90 K562 HeLa)
path=../../source_data/FunctionOfSameEnhancer
for var in ${cell[@]};
do
python target_gene_random_GO.py $path/$var'_E_targetgene.txt' $path/$var'_GO_function.txt' > $var'_same_random_ratio.txt'

done
