"""
RQA with PyRQA package
"""

import numpy as np
from pyrqa.analysis_type import Classic
from pyrqa.computation import RQAComputation
from pyrqa.image_generator import ImageGenerator
from pyrqa.metric import EuclideanMetric
from pyrqa.neighbourhood import FixedRadius
from pyrqa.settings import Settings
from pyrqa.time_series import TimeSeries
from pyrqa.opencl import OpenCL


def cal_rqa(path_1, path_2):
    """ calculate RQA of audio feature in file path_1 and path_2"""

    # opencl set up
    #opencl = OpenCL(command_line=True)
    opencl = OpenCL(platform_id=1,
                    device_ids=(0,))

    # load tiem series
    data_points_x = np.loadtxt(path_1, delimiter=',', skiprows=1)
    normalized_data_points_x = data_points_x / np.amax(data_points_x)
    time_series_x = TimeSeries(normalized_data_points_x,
                            embedding_dimension=0,
                            time_delay=0)
    data_points_y = np.loadtxt(path_2, delimiter=',', skiprows=1)
    normalized_data_points_y = data_points_y / np.amax(data_points_y)
    time_series_y = TimeSeries(normalized_data_points_y,
                            embedding_dimension=0,
                            time_delay=0)
    time_series = (time_series_x,
                time_series_y)
    # set rqa setting
    settings = Settings(time_series,
                        analysis_type=Cross,
                        neighbourhood=FixedRadius(0.2),
                        similarity_measure=EuclideanMetric,
                        theiler_corrector=0)

    # calculate
    computation = RQAComputation.create(settings, opencl=opencl,
                                    verbose=False)
    result = computation.run()    # chech pkg: pyrqa/result.py for result format
    return (result.to_array())[3::]
