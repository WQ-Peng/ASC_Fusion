import os

path_dcase2017_origin = '/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development'

path_audio_origin = os.path.join(path_dcase2017_origin, 'audio')
path_feature_origin = os.path.join(path_dcase2017_origin, 'feature')

#freesound feature
path_feature_freesound = os.path.join(path_feature_origin, 'freesound_extractor')

# original audio files freesound features
path_feature_freesound_statistics = os.path.join(path_feature_freesound, 'statistics')

#feature specific folders
for name in ['BarkBands', 'ERBBands', 'MelBands', 'MFCC', 'HPCP', 'Tonal', 'Pitch', 'SilenceRate', 'Spectral', 'GFCC']:
    exec('path_feature_%s = os.path.join(path_feature_origin, name)'%name)

def mkdir(dirName):
    """
    Creat folders
    :dirName: directory you want to creat
    """
    if not os.path.exists(dirName):
        os.mkdir(dirName)

if __name__ == "__main__":
    for name in ['BarkBands', 'ERBBands', 'MelBands', 'MFCC', 'HPCP', 'Tonal', 'Pitch', 'SilenceRate', 'Spectral', 'GFCC']:
        exec('mkdir(path_feature_%s)'%name)
