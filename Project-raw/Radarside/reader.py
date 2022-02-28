import os 
from scipy.io import loadmat
import numpy as np


filename = 'gps_data_1.mat'
dir = os.path.join(r'C:\Users\Bishal\RadarProject\Data\RadarData', filename)
raw_data = loadmat(dir)
radar_data = raw_data['retVal']

# n_chirps = 128
# n_samples = 256
# n_frames = 100
# n_samples, n_chirps = radar_data[0].reshape((256, -1)).shape
# print(n_chirps)

class ReadRadar():
    def __init__(self, filename='gps_data_3.mat', n_chirps=128, n_samples=256, n_frames=100, n_rx=4) -> None:
        self.filename=filename
        print(f"Reading file: {self.filename}")
        self.dir = os.path.join(r'C:\Users\Bishal\RadarProject\Data\RadarData', self.filename)
        self.raw_data = self.get_raw_data()    
        self.n_chirps = n_chirps
        self.n_samples = n_samples
        self.n_frames = n_frames
        self.n_rx = n_rx
        self.rx = self.get_rx_data()

    def get_raw_data(self):
        return loadmat(self.dir)['retVal']
    
    def get_rx_data(self):
        rx = {}
        for index in range(self.n_rx):
            # rx[f'r{index}'] = self.raw_data[index].reshape((self.n_frames, self.n_samples, self.n_chirps))
            rx[f'r{index}'] = self.raw_data[index].reshape((self.n_frames, self.n_chirps, self.n_samples))
        return rx

if __name__ == '__main__':
    radar1 = ReadRadar(filename='gps_data_2.mat')
    radar2 = ReadRadar(filename='gps_data_3.mat')
    print((radar1.rx['r1'] - radar2.rx['r1']).shape)

    