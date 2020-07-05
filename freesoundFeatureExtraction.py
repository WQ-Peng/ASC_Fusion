import essentia.standard as es
import pandas as pd
from pathName import *
import numpy
import os
from multiprocessing import Process


def statsticsCal(array, dict_seg, desc):
    """
    Statistical pool agregation . Just copy in this case
    """
    dict_seg[desc] = numpy.array(array)

    return  dict_seg

def frame_pool_aggregation(essentia_frame_pool, filename):
    """
    Save essentia pool to csv file, exclude useless features
    """
    feature_frame = pd.DataFrame()
    dict_seg = {}
    # ignore all the useless features
    for desc in essentia_frame_pool.descriptorNames():
        #exclude melband96
        if 'melbands96' in desc:
            continue
        if 'histogram' in desc:
            # print('ignore',desc)
            continue
        if desc == 'lowlevel.gfcc.cov' or desc == 'lowlevel.gfcc.icov' \
            or desc == 'lowlevel.mfcc.cov' or desc == 'lowlevel.mfcc.icov':
            # print('ignore', desc)
            continue
        if 'melbands128' in desc:
            # print('ignore', desc)
            continue
        if 'onset_times' in desc or \
            'bpm_intervals' in desc or \
            'metadata' in desc or \
            'beats_position' in desc or \
                'chords_key' in desc or \
                'chords_scale' in desc or \
                'key_edma' in desc or \
                'key_krumhansl' in desc or \
                'key_temperley' in desc or \
                'chords_progression' in desc or \
                'rhythm' in desc or \
                'tonal.tuning_frequency' in desc or \
                'sfx.oddtoevenharmonicenergyratio' in desc or \
                'tristimulus' in desc or \
                'loudness_ebu128' in desc:
            continue

        if type(essentia_frame_pool[desc]) is float:
            continue
        if essentia_frame_pool[desc].shape[0] == 1:
            continue

        if len(essentia_frame_pool[desc].shape) == 1:
            dict_seg = statsticsCal(essentia_frame_pool[desc], dict_seg, desc)

        else:
            for jj in range(essentia_frame_pool[desc].shape[1]):
                dict_seg = statsticsCal(essentia_frame_pool[desc][:,jj], dict_seg, desc+str(jj))
    #432 is the number of frames: (44100*10) / 1024 + 1
    feature_frame = pd.DataFrame(dict_seg, index=range(432))

    return feature_frame

def subprocessFeatureExtractionFrame(path_audio, path_feature_freesound_statistics, fn):
    """
    Run this in process to avoid memory leak
    :param path_audio:
    :param path_feature_freesound_statistics:
    :param fn:
    :return:
    """
    extractor = es.FreesoundExtractor(lowlevelFrameSize=2048, lowlevelHopSize=1024, tonalFrameSize=2048, tonalHopSize=1024)
    _, feature_frame_pool = extractor(os.path.join(path_audio, fn))
    feature_pd_DataFrame = frame_pool_aggregation(feature_frame_pool, fn)
    feature_pd_DataFrame.to_csv(os.path.join(path_feature_freesound_statistics, fn.split('.')[0] + '.csv'))

if __name__ == '__main__':
    #extract features
    filenames_audio = [f for f in os.listdir(path_audio_origin) if os.path.isfile(os.path.join(path_audio_origin, f))]
    print('calculating audio feature, ', 'in total ', len(filenames_audio))
    for ii, fn in enumerate(filenames_audio):
        print('calculating', ii, fn),
        p = Process(target=subprocessFeatureExtractionFrame, args=(path_audio_origin, path_feature_freesound_statistics,fn,))
        p.start()
        p.join()
