import os 
import numpy as np 
import matplotlib.pyplot as plt
from scipy.fft import fft

from reader import *
from process import *


class Plot(Process):
    def __init__(self, filename=None):
        super().__init__(filename=filename)
    
    def Range(self):
        fig, ax = plt.subplots(2, 2)
        


if __name__ == '__main__':
    pass
