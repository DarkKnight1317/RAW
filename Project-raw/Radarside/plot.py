from data import *
import matplotlib.pyplot as plt
import numpy as np


if __name__ == '__main__':
    # plt.scatter(gps['lat'], gps['long'])
    plt.plot(gps['lat'], gps['long'])
    plt.grid()
    plt.show()