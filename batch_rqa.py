"""
calculate RQA matrix of each feature
"""

import os

import numpy as np
from pathName import *
from rqa import cal_rqa
from multiprocessing import Pool
from time import time

start_time = time()

# list audio name
audio_name_list = []
with open(path_meta) as f:
    for line in f.readlines():
        name_temp = (line.strip()).split()    # ['audio/b020_110_120.wav', 'beach', 'b020']
        name_temp = (name_temp[0]).split('.')[0]    # 'audio/b020_110_120'
        audio_name_list.append(name_temp.split('/')[1])    # 'b020_110_120'

feature_type_list = ["BarkBands","ERBBands","MelBands","MFCC","HPCP","Tonal","Pitch","SilenceRate","Spectral","GFCC"]
RQA_type_list = ["RR", "DET", "L", "L_max", "DIV", "L_entr", "LAM", "TT", "V_max", "V_entr", \
                "W", "W_max", "W_div", "W_entr", "ratio_DET_RR", "ratio_LAM_DET"]

def subprocess_cal_rqa(feature_x, feature_y):
    """
    subprocess of calculating rqa

    feature_x, feature_y: feature csv paths
    array: shared array to store the rqa of one audio between others temporarily
    j: index in the loop
    """
    return cal_rqa(feature_x, feature_y)    # array_tmp: 2d numpy array, 2nd dimension is RQA type,
                                                       # cal_rqa() retuen a shape(16,) numpy array, contains 16 rqa measures

def subprocess_map(argu):
    """subprocess in order to use Pool.map_async with multi arguments"""
    return subprocess_cal_rqa(argu[0], argu[1])

# construct RQA matrix of each feature
for feature_type in feature_type_list:
    path_feature_folder = os.path.join(path_feature_origin, 'freesound_extractor', feature_type)

    # construct empty matrix
    num_audio = len(audio_name_list)
    RQA_matrix_all = []    # RQA_matrix_all: 3d list
    # pool setup
    pool = Pool(processes=30)
    argu = []    # list to store arguments for map_async

    # calculate
    for i in range(num_audio):
        print("calculating audio: "+str(i)+", feature: "+feature_type+", time:"+str(int(time()-start_time)))
        path_feature_x = os.path.join(path_feature_folder, audio_name_list[i]+'.csv')

        for j in range(num_audio):
            path_feature_y = os.path.join(path_feature_folder, audio_name_list[j]+'.csv')
            argu.append([path_feature_x,path_feature_y])
        print("setup done")
        result = pool.map(func=subprocess_map, iterable=argu)    # multiprocessing
        RQA_matrix_all.append(result)
    print("pool done")
    pool.close()

    RQA_matrix_all_np = np.array(RQA_matrix_all)    # RQA_matrix_all_np: 3d numpy array

    # save into csv file
    for type_index in range(len(RQA_type_list)):
        # reshape matrix
        RQA_matrix_each = RQA_matrix_all_np[:,:,type_index]    # 3d -> 2d, each RQA type
        target_file_name = os.path.join(path_feature_RQA, RQA_type_list[type_index], feature_type+'.csv')
        np.savetxt(target_file_name, RQA_matrix_each, delimiter=',')
