"""
calculate RQA matrix of each feature
"""

import os

import numpy as np
from pathName import *
from rqa import cal_rqa

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

# construct RQA matrix of each feature
for feature_type in feature_type_list:
    path_feature_folder = os.path.join(path_feature_origin, 'freesound_extractor', feature_type)

    # construct empty matrix
    num_audio = len(audio_name_list)
    RQA_matrix_all = np.zeros((num_audio, num_audio, len(RQA_type_list)))

    # calculate
    for i in range(num_audio):
        print("calculating audio: "+str(i)+", feature: "+feature_type)
        feature_x = os.path.join(path_feature_folder, audio_name_list[i]+'.csv')
        for j in range(num_audio):
            feature_y = os.path.join(path_feature_folder, audio_name_list[j]+'.csv')
            RQA_matrix_all[i,j,:] = cal_rqa(feature_x, feature_y)    # RQA_matrix_all: 3d numpy array, 3rd dimension is RQA type

    # save into csv file
    
    for type_index in range(len(RQA_type_list)):
        # reshape matrix
        RQA_matrix_each = RQA_matrix_all[:,:,type_index]    # 3d -> 2d, each RQA type
        target_name = os.path.join(path_feature_RQA, RQA_type_list[type_index], feature_type+'.csv')
        np.savetxt(target_name, RQA_matrix_each, delimiter=',')
