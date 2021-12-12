# -*- coding: utf-8 -*
import os
import sys


def load_data(path):
    reads_data = {}
    data_list = open(path).readlines()
    for line in data_list:
        items = line.split('\t')
        key = items[0] + items[3].split("%")[-1] 
        if key in reads_data:
            reads_data[key].append(line)
        else:
            reads_data[key] = [line]
    return reads_data

def merge_readsID(filePaths):
    print("file paths:",filePaths)
    reads_data1 = load_data(filePaths[0])
    reads_data2 = load_data(filePaths[1])
    basename = os.path.basename(filePaths[0]).split('_')[0]
    f_name = basename+"_merged_EPreadsid.txt"
    output = open(f_name,'w')
    for key in reads_data1:
        if key in reads_data2:
            reads1_list = reads_data1[key]
            reads2_list = reads_data2[key]
            for line1 in reads1_list:
                for line2 in reads2_list:
                    output.write(line1.strip()+"\t"+line2) 
    output.close()

if __name__ == "__main__":

    merge_readsID(sys.argv[1:])
