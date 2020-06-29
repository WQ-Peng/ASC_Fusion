import essentia.standard as es
import pandas as pd
from pathName import *
import numpy
import os
from multiprocessing import Process


def statsticsCal(array, dict_seg, desc):
    m = numpy.mean(array)
    v = numpy.var(array)
    d = numpy.diff(array)
    dm = numpy.mean(d)
    dv = numpy.var(d)
    dict_seg[desc + '.mean'] = m
    dict_seg[desc + '.var'] = v
    dict_seg[desc + '.dmean'] = dm
    dict_seg[desc + '.dvar'] = dv
    return  dict_seg

def frame_pool_aggregation(essentia_frame_pool, filename):
    ii = 0
    feature_frame = pd.DataFrame()
    seg_framesize = 22
    #10 segments
    while ii < 217/seg_framesize+1:
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
                dict_seg = statsticsCal(essentia_frame_pool[desc][seg_framesize*ii:seg_framesize*(ii+1)], dict_seg, desc)

            else:
                for jj in range(essentia_frame_pool[desc].shape[1]):
                    dict_seg = statsticsCal(essentia_frame_pool[desc][seg_framesize*ii:seg_framesize*(ii+1),jj], dict_seg, desc+str(jj))

        dataFrame_ii = pd.DataFrame(dict_seg, index=[filename + '_' + str(ii)])
        feature_frame = feature_frame.append(dataFrame_ii)
        ii += 1

    return feature_frame

def subprocessFeatureExtractionFrame(path_audio, path_feature_freesound_statistics, fn):
    """
    Run this in process to avoid memory leak
    :param path_audio:
    :param path_feature_freesound_statistics:
    :param fn:
    :return:
    """
    extractor = es.FreesoundExtractor(lowlevelFrameSize=4096, lowlevelHopSize=2048)
    _, feature_frame_pool = extractor(os.path.join(path_audio, fn))
    feature_pd_DataFrame = frame_pool_aggregation(feature_frame_pool, fn)
    feature_pd_DataFrame.to_csv(os.path.join(path_feature_freesound_statistics, fn.split('.')[0] + '.csv'))

if __name__ == '__main__':
    sample_audio_path = '/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development/audio/'
    sample_audio_name = 'a001_0_10.wav'
    sample_feature_path = '/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development/feature/freesound_extractor/statistics'

    subprocessFeatureExtractionFrame(sample_audio_path, sample_feature_path, sample_audio_name)