# -*- coding: utf-8 -*

import os
import sys
import time
import random

# 加载 enhancer及对方靶基因 文件
def load_enhance_targetgene_data(path):
    reads_data = {}
    data_list = open(path).readlines()
    for line in data_list[1:]:  # 第一行为表头
        items = line.strip().split('\t')
        enhancer = items[0].strip()
        targetgene = items[-1].strip().replace(' ','')
        if enhancer in reads_data:
            reads_data[enhancer].append(targetgene)
        else:
            reads_data[enhancer] = [targetgene]
    return reads_data

# 加载 function文件及靶基因文件
def load_function_targetgene_data(path):
    reads_data = {}
    data_list = open(path).readlines()
    for line in data_list[1:]: # 第一行为表头
        items = line.strip().split('\t')
        function = items[1].strip().replace('"','')
        targetgenes = items[5].replace('"','').split(',')
        for genes in targetgenes:
            genes = genes.strip()
            if genes in reads_data:
                reads_data[genes].append(function)
            else:
                reads_data[genes] = [function]
    return reads_data


def target_genen_random(enhancer_targetgene_file_path,function_file_path,random_size):
    # 数据加载 
    enhancer_targetgene_data = load_enhance_targetgene_data(enhancer_targetgene_file_path)
    function_data = load_function_targetgene_data(function_file_path)
    all_enhancer_connection_target_gene = {}
    for enhancer in enhancer_targetgene_data.keys():
        #print(enhancer,enhancer_targetgene_data[enhancer])
        enhacer_has_connection_target_gene = []
        for t_gene in enhancer_targetgene_data[enhancer]:
            if  t_gene in function_data:
                enhacer_has_connection_target_gene.append(t_gene) 
        if len(enhacer_has_connection_target_gene) > 0:
            all_enhancer_connection_target_gene[enhancer] = enhacer_has_connection_target_gene
        else:
            print("this enhancer has no connection target gene in functions set :",enhancer)
              

    all_has_connection_target_gene = [] 

    # 循环每个enhancer，在对应target gene 里随机取gene 判断功能相同占比
    same_func_rate_list = []
    for enhancer in all_enhancer_connection_target_gene:
        # 不考虑只有一个通路情况
        if len(all_enhancer_connection_target_gene[enhancer]) <= 1:
            continue
        
        all_has_connection_target_gene.extend(all_enhancer_connection_target_gene[enhancer])
        has_same_func_count = 0
        for i in range(random_size):
            # 随机取两个基因
            #random_gene1 = random.choice(all_enhancer_connection_target_gene[enhancer]) 
            #random_gene2 = random.choice(all_enhancer_connection_target_gene[enhancer]) 
            # 一次随机两个
            random_gene = random.sample(all_enhancer_connection_target_gene[enhancer],2)
            random_gene1 = random_gene[0]
            random_gene2 = random_gene[1]
            # 判断功能是否相同
            for func in function_data[random_gene1]:
                if func in function_data[random_gene2]:
                    has_same_func_count += 1 
                    break

        same_func_rate = float(has_same_func_count)/random_size
        print(enhancer,all_enhancer_connection_target_gene[enhancer]," random ",random_size," has same func rate:",same_func_rate)
        same_func_rate_list.append(same_func_rate)

    # 所有enhancer相同功能占比平均
    print("the average of all enhancer that has same func rate: ",sum(same_func_rate_list)/float(len(same_func_rate_list)))


    # 随机从所有target gene里取gene判断功能相同占比 
    all_has_connection_target_gene = set(all_has_connection_target_gene)
    has_same_func = 0
    for i in range(random_size):
        #random_gene1 = random.choice(list(all_has_connection_target_gene))
        #random_gene2 = random.choice(list(all_has_connection_target_gene))
        # 一次随机两个
        random_gene = random.sample(list(all_has_connection_target_gene),2)
        random_gene1 = random_gene[0]
        random_gene2 = random_gene[1]
       
        # 判断功能是否相同
        for func in function_data[random_gene1]:
            if func in function_data[random_gene2]:
                has_same_func += 1 
                break

    print("random from all target genes that has same func rate:",float(has_same_func)/random_size)



# 参数1：enhancer target genes文件 参数2：function 文件
# 功能：随机抽取靶基因统计占比
if __name__ == "__main__":

    target_genen_random(sys.argv[1],sys.argv[2],10000)
