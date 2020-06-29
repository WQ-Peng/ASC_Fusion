import essentia.standard as es
from pathName import *
import os

def extract_featrues(audio_path, result_path):

    #grnerate extractor
    extractor = es.FreesoundExtractor(lowlevelFrameSize=2048, lowlevelHopSize=1024)

    #extract features
    result_pool, result_frame_pool = extractor(audio_path)

    #aggregate statistic descriptors
    #aggr_result_pool = es.PoolAggregator(defaultStats = [ 'mean', 'var', 'dmean', 'dvar' ])(result_pool)
    aggr_result_frame_pool = es.PoolAggregator(defaultStats = [ 'mean', 'var', 'dmean', 'dvar' ])(result_frame_pool)

    #save result as yaml file
    #ess.YamlOutput(filename = result_path + '/test_result.sig',format = 'json')(aggr_result_pool)
    es.YamlOutput(filename = result_path, format = 'json')(aggr_result_frame_pool)

if __name__ == '__main__':
    extract_featrues(os.path.join(path_audio_origin,'audio/a001_0_10.wav'), path_audio_origin)