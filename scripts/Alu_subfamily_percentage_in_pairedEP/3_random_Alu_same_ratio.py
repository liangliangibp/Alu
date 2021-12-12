# -*- coding: utf-8 -*


import os
import sys
import time
import random
import numpy as np

def random_alu_pair(params):

    data_lines = open(params[0]).readlines()
    left_alu_list = []
    right_alu_list = []
    for line in data_lines:
        items = line.split('\t')
        left_alu_list.append(items[10])
        right_alu_list.append(items[-2])

    print(len(left_alu_list))
    all_count = int(params[1])
    ratio_list = []
    for _ in range(all_count):
        random.shuffle(left_alu_list)
        random.shuffle(right_alu_list)
        same_alu_count = 0
        for left,right in zip(left_alu_list,right_alu_list):
            if left[:4] == right[:4]:
                same_alu_count += 1
        ratio_list.append(float(same_alu_count/len(left_alu_list)))

    print(all_count,"same alu mean =",np.mean(np.array(ratio_list)),np.std(np.array(ratio_list)))


if __name__ == "__main__":
    #random_alu_pair(["../data/K562_merged_EPreadsid.txt",100])
    random_alu_pair(sys.argv[1:])
