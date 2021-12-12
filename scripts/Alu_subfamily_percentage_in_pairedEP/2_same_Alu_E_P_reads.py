# -*- coding: utf-8 -*


import os
import sys

def same_Alu_ratio(params):
    data_lines = open(params[0]).readlines()
    line_count = len(data_lines)
    same_alu_count = 0
    for line in data_lines:
        items = line.split('\t')
        a=items[10]
        b=items[22]
        if a[:4] == b[:4]:
            same_alu_count += 1
    print(params[0]," same_alu_count:",same_alu_count,"line_count =",line_count,"same alu subfamily rate =",float(same_alu_count/float(line_count)))
                 
if __name__ == "__main__":
    same_Alu_ratio(sys.argv[1:]) 
