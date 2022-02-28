from importlib.resources import path
import os
from scipy.io import loadmat
import numpy as np



dir = r'C:\Users\Bishal\RadarProject\Data\Hexacopter_log\Hexadrone_real_data'
filename = '2022-02-05 14-47-45.bin-12240.mat'

data_path = os.path.join(dir, filename)

class Readgps:
    def __init__(self,
                 filename='2022-02-05 14-47-45.bin-12240.mat',
                 dir=r'C:\Users\Bishal\RadarProject\Data\Hexacopter_log\Hexadrone_real_data'):
        
        self.data_path = os.path.join(dir, filename)
        self.lat, self.lon, self.alt = self.load_gps()

    def load_gps(self):
        raw = loadmat(self.data_path)
        # print(np.shape(raw['GPS']))
        xyz = raw['GPS'][:,8:11]
        # print(xyz.shape, type(xyz))
        lat = xyz[...,0]
        lon = xyz[..., 1]
        alt = xyz[..., 2]
        return lat, lon, alt

    def get_coordinates(self):

        