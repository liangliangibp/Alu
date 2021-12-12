# -*- coding: utf-8 -*
# 脚本作用: 相互作用RNA的方向不一致的所占的比例
import os
import sys

def load_direction_data(path):
    basename = os.path.basename(path).split('_')[0]
    output = open(basename+'_opposite_Alu.txt','w')
    output1 = open(basename+'_same_Alu.txt','w')
    data_list = open(path).readlines()
    for line in data_list[1:]:  # 第一行为表头
        items = line.strip().split("\t")
        if (items[-2]== "0/16" or items[-2]== "16/0" or items[-2]== "0/272" or items[-2]== "272/0" or items[-2]== "256/16" or items[-2]== "16/256" or items[-2]== "256/272" or items[-2]== "272/256"):
            if (items[-1] == "C/+" or items[-1] == "+/C"):
                output.write(line)
            else: 
                output1.write(line)
        if (items[-2]== "0/0" or items[-2]== "16/16" or items[-2]== "256/256" or items[-2]== "272/272" or items[-2]== "256/0" or items[-2]== "0/256" or items[-2]== "16/272" or items[-2]== "272/16"):
            if (items[-1] == "+/+" or items[-1] == "C/C"):
                output.write(line)
            else:
                output1.write(line)
    output.close()


if __name__ == "__main__":

    load_direction_data(sys.argv[1])
            
