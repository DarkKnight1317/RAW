import os 
import numpy as np 
from scipy.fft import fft

from reader import *

class Process(ReadRadar):
    def __init__(self, filename='gps_data_1.mat'):
        super().__init__(filename=filename)
        print(f"Processing Filename: {self.filename}")
        self.fft_1 = self.fft_1d()
        self.fft_2 = self.fft_2d()
        self.fft_3 = self.fft_3d()

    def fft_1d(self):
        fft_1 = {}
        for index in range(self.n_rx):
            fft_1[f'r{index}'] = fft(self.rx[f'r{index}'], axis=2) # FFT along sample axis
        return fft_1
    
    def fft_2d(self):
        fft_2 = {}
        for index in range(self.n_rx):
            fft_2[f'r{index}'] = fft(self.fft_1[f'r{index}'], axis=1) # FFT along chirp axis
        return fft_2
    
    def fft_3d(self):
        fft_3 = {}
        for index in range(self.n_rx):
            fft_3[f'r{index}'] = fft(self.fft_2[f'r{index}'], axis=0)
        return fft_3
    
if __name__ == '__main__':
    radar = Process()
    # print(radar.fft_chirp['r0'].shape)
    