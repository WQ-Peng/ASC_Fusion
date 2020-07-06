"""
This file contains function to extract features from one single csv file to 
individual feature csv files, eg MelBands, to simplify later processing
"""
import pandas as pd
from multiprocessing import Process
from pathName import *

def separate(filename):
    """
    Separate features to individual folders

    Args：
        filename: feature csv filename
    """
    feature_all = pd.read_csv(os.path.join(path_feature_freesound_statistics, filename))
    
    #extract from feature_all and put into individual dataframe, check csv file for index
    feature_BarkBands = pd.concat([feature_all.iloc[:,0:5], feature_all.iloc[:,46:73]], axis=1)
    feature_ERBBands = pd.concat([feature_all.iloc[:,6:11], feature_all.iloc[:,73:91]], axis=1)
    feature_MelBands = pd.concat([feature_all.iloc[:,12:17], feature_all.iloc[:,104:144]], axis=1)
    feature_MFCC = feature_all.iloc[:,144:157]
    feature_HPCP = pd.concat([feature_all.iloc[:,44:46], feature_all.iloc[:,169:205]], axis=1)
    feature_Tonal = feature_all.iloc[:,41:44]
    feature_Pitch = feature_all.iloc[:,17:20]
    feature_SilenceRate = feature_all.iloc[:,20:23]
    feature_Spectral = pd.concat([feature_all.iloc[:,5:6], feature_all.iloc[:,11:12], \
        feature_all.iloc[:,23:41], feature_all.iloc[:,157:169]], axis=1)
    feature_GFCC = feature_all.iloc[:,91:104]

    #save into individual folders
    for name in ['BarkBands', 'ERBBands', 'MelBands', 'MFCC', 'HPCP', 'Tonal', 'Pitch', 'SilenceRate', 'Spectral', 'GFCC']:
        exec('feature_%s.to_csv(os.path.join(path_feature_%s, filename), index=False)'%(name,name))


if __name__ == "__main__":
    filenames_feature = [f for f in os.listdir(path_feature_freesound_statistics) \
         if os.path.isfile(os.path.join(path_feature_freesound_statistics, f))]
    print('Separating features to individual folders, ', 'in total ', len(filenames_feature))
    for ii, fn in enumerate(filenames_feature):
        print('calculating', ii, fn),
        p = Process(target=separate, args=(fn,))
        p.start()
        p.join()
