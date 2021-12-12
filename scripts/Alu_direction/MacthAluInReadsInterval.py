# -*- coding: utf-8 -*
import os
import sys
import multiprocessing as mp

def load_alu_data(path):
    print("start load alu file:",path)
    reads_data = {}
    data_list = open(path).readlines()
    for line in data_list:
        items = line.split('\t')
        chrname = items[0].strip() 
        key = chrname
        if key in reads_data:
            reads_data[key].append(line)
        else:
            reads_data[key] = [line]
    return reads_data


def load_sam_data(sam1_path,sam2_path):
    print("start load sam file:",sam1_path,sam2_path)
    reads_data = {}
    data1_list = open(sam1_path).readlines()
    data2_list = open(sam2_path).readlines()
    data_list = data1_list + data2_list
    for line in data_list:
        items = line.split('\t')
        chrname = items[2].strip() 
        pairId = "_".join(items[0].strip().split("%")[-1].split('_')[:3]) 
        readsNum = items[0].strip().split("%")[1]  

        key = chrname +"_"+pairId
        if key in reads_data:
            if readsNum in reads_data[key]:
                #print("error:",line," ",reads_data[key][readsNum])
                reads_data[key][readsNum].append(line)
            else:
                reads_data[key][readsNum] = [line]
        else:
            reads_data[key] = {readsNum:[line]}

    return reads_data

def load_bed_data(bed1_path,bed2_path):
    print("start load file:",bed1_path,bed2_path)
    reads_data = {}
    data1_list = open(bed1_path).readlines()
    data2_list = open(bed2_path).readlines()
    data_list = data1_list + data2_list
    #print("bed data:",len(data1_list),len(data2_list),len(data_list))
    for line in data_list:
        items = line.split('\t')
        chrname = items[0].strip() 
        pairId = items[3].strip().split("%")[-1]  # EP#%read2%Sample1_AlignPairSegment_201257_Plus_ST-E00494:574:HVL7GCCXY:8:1101:17381:69959 
        readsNum = items[3].strip().split("%")[1]  # reads1 or reads2 

        key = chrname +"_"+pairId
        if key in reads_data:
            if readsNum in reads_data[key]:
               # print("error:",line," ",reads_data[key][readsNum])
                reads_data[key][readsNum].append(line)
            else:
                reads_data[key][readsNum] = [line]
        else:
            reads_data[key] = {readsNum:[line]}
    return reads_data



def overlap_pos(pos1_start,pos1_end,pos2_start,pos2_end):
    if pos1_end < pos2_start or pos1_start > pos2_end:
        return False;
    return True;

 
def alu_overlap(alu_list_data,pos_start,pos_end):
    overlap_list = []
    for alu in alu_list_data:
        alu_items = alu.split('\t')
        alu_pos_start = int(alu_items[1]) 
        alu_pos_end = int(alu_items[2]) 
        if overlap_pos(alu_pos_start,alu_pos_end,pos_start,pos_end):
            overlap_list.append(alu)
    return overlap_list
        

def findAlu(result_list,key,alu_list,same_pairId_data,bed_paird_data):
    chrname = key.split('_')[0]
    if "read1" in same_pairId_data and "read2" in same_pairId_data:
        #if len(same_pairId_data['read1']) != 1 or len(same_pairId_data['read2']) != 1:
        #    print("error! read1 or read2 data count > 1 data:",same_pairId_data)
        sam_read1_items = same_pairId_data['read1'][0].split('\t') 
        sam_read2_items = same_pairId_data['read2'][0].split('\t') 
        bed_read1_items = bed_paird_data['read1'][0].split('\t')  
        bed_read2_items = bed_paird_data['read2'][0].split('\t')  
        read1_pos_start = int(bed_read1_items[1])
        read1_pos_end = int(bed_read1_items[2])
        read2_pos_start = int(bed_read2_items[1])
        read2_pos_end = int(bed_read2_items[2])

        alu_read1_overlap = alu_overlap(alu_list,read1_pos_start,read1_pos_end)
        alu_read2_overlap = alu_overlap(alu_list,read2_pos_start,read2_pos_end)
        #if len(alu_read1_overlap) <= 0 or len(alu_read2_overlap) <=0 :
        #    print("alu not match read1 size:",len(alu_read1_overlap)," read2 match alu size:",len(alu_read2_overlap))
        # 比较alu方向  同为 + 或者 C
        if len(alu_read1_overlap) == 1 and len(alu_read2_overlap) == 1:
            read1_alu_dir = alu_read1_overlap[0].split('\t')[3]
            read2_alu_dir = alu_read2_overlap[0].split('\t')[3]
            #if read1_alu_dir != read2_alu_dir: # 同为+ 或同为C
            #    alu_direction = "+/C"
            #else:
            alu_direction = read1_alu_dir+"/"+read2_alu_dir
                      
            #if sam_read1_items[1] != sam_read2_items[1]: # 不相同 0 16
            #    reads_direction = "0/16"
            #else:
            reads_direction = sam_read1_items[1] +"/"+sam_read2_items[1]
            line = key+"\t"+alu_read1_overlap[0].strip()+"\t"+alu_read2_overlap[0].strip()+"\t"+reads_direction+"\t"+alu_direction+"\n" 
            #print("write data:"+line)
            result_list.append(line)
        #else:
        #    print("read1 match alu size:",len(alu_read1_overlap)," read2 match alu size:",len(alu_read2_overlap))
    else:
        print("error data!")



# 找出符合条件alu
def findAluDirectionInReads(sam1_file_path,sam2_file_path,bed1_file_path,bed2_file_path,alu_file_path):

    # 加载sam 数据
    sam_data = load_sam_data(sam1_file_path,sam2_file_path)
    # 加载bed 数据 (主要是用位置信息)
    bed_data = load_bed_data(bed1_file_path,bed2_file_path)
    # 加载alu数据
    alu_data = load_alu_data(alu_file_path)


    result_list = mp.Manager().list()
    print("sam_data pairid size:",len(sam_data))
    pp = mp.Pool(processes=mp.cpu_count()-5)
    for key in sam_data:
        same_pairId_data =  sam_data[key]
        chrname = key.split('_')[0]
        if chrname not in alu_data:
            #print("error! chrname not in alu data:",chrname)
            continue
        if key not in bed_data:
            #print("no this chrname in bed file:",chrname)
            continue
        bed_paird_data = bed_data[key] 
        if "read1" not in bed_paird_data or "read2" not in bed_paird_data:
            #print("error no read1 or read2 in bed data:",bed_paird_data,same_pairId_data)
            continue
        pp.apply_async(findAlu,(result_list,key,alu_data[chrname],same_pairId_data,bed_paird_data))
        #findAlu(result_list,key,alu_data[chrname],same_pairId_data,bed_paird_data)
       

    pp.close()
    pp.join()
    match_file_name = os.path.basename(sam1_file_path).split("_")[0]+"_findMatchedAluInReads.txt"
    output = open(match_file_name,'w')
    header = "ChrNameAndPairId\tMatchedAluInRead1\tMatchedAluInRead2\tReadDirection\tAluDirection\n"
    output.write(header)
    print(len(result_list))
    for line in result_list:
        output.write(line)
    output.close()


# 输入参数: 参数1：sam1文件   参数2： sam2文件  参数3：bed1文件  参数4：bed2文件 5： alu文件 
if __name__ == "__main__":

    findAluDirectionInReads(sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4],sys.argv[5])
