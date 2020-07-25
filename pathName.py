"""Paths of frequentlu used folders and func to creat them
Change according to your computer before using them
"""
import os

path_dcase2017_origin = '/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development'

path_audio_origin = os.path.join(path_dcase2017_origin, 'audio')
path_feature_origin = os.path.join(path_dcase2017_origin, 'feature')

# freesound feature
path_feature_freesound = os.path.join(path_feature_origin, 'freesound_extractor')

# original audio files freesound features
path_feature_freesound_statistics = os.path.join(path_feature_freesound, 'statistics')

# feature specific folders
for name in ['BarkBands', 'ERBBands', 'MelBands', 'MFCC', 'HPCP', 'Tonal', 'Pitch', 'SilenceRate', 'Spectral', 'GFCC']:
    exec('path_feature_%s = os.path.join(path_feature_origin, name)'%name)

# RQA path
path_feature_RQA = os.path.join(path_feature_origin, 'RQA')

# meta file
path_meta = os.path.join(path_dcase2017_origin, 'meta.txt')

# cross-validation setup
path_evaluation_setup = os.path.join(path_dcase2017_origin, 'evaluation_setup')

path_fold1_train_txt = os.path.join(path_evaluation_setup, 'fold1_train.txt')
path_fold1_eval_txt = os.path.join(path_evaluation_setup, 'fold1_evaluate.txt')

path_fold2_train_txt = os.path.join(path_evaluation_setup, 'fold2_train.txt')
path_fold2_eval_txt = os.path.join(path_evaluation_setup, 'fold2_evaluate.txt')

path_fold3_train_txt = os.path.join(path_evaluation_setup, 'fold3_train.txt')
path_fold3_eval_txt = os.path.join(path_evaluation_setup, 'fold3_evaluate.txt')

path_fold4_train_txt = os.path.join(path_evaluation_setup, 'fold4_train.txt')
path_fold4_eval_txt = os.path.join(path_evaluation_setup, 'fold4_evaluate.txt')

def mkdir(dirName):
    """
    Creat folders

    Args:
        dirName: directory you want to creat
    """
    if not os.path.exists(dirName):
        os.mkdir(dirName)

if __name__ == "__main__":
    for name in ['BarkBands', 'ERBBands', 'MelBands', 'MFCC', 'HPCP', 'Tonal', 'Pitch', 'SilenceRate', 'Spectral', 'GFCC']:
        exec('mkdir(path_feature_%s)'%name)
