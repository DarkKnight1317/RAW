import numpy as np
from reader import *
from process import *
# from plot_range_profile import *
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation




def estimate_range(radars, rx_index=0):
    c = 3 * (10 ** 8)
    # sample_rate = 10000
    sample_rate = 6250
    # frequency_slope = 29.0041
    frequency_slope = 42
    num_range_bins = 256
    range_factor = c * sample_rate * 1000 / (2 * frequency_slope * 10**12 * num_range_bins)    
    def animate(frame):
        ax.clear()
        for radar in radars:
            mat = np.array(radar.fft_1[f'r{rx_index}'])
            y = np.sqrt(np.sum(np.square(np.abs(mat[frame, :, :])), axis=0))
            y = 10*np.log10(y)
            x = np.arange(0, radar.n_samples, 1)
            range_meter = x * range_factor
            ax.set_xlim(0, 23)
            ax.set_ylim(30, 50)            
            ax.plot(range_meter, y)
        print(f"frame={frame}")
        ax.set_title(f'Range Estimation, frame:{frame}')
        ax.set_xlabel('Range in meters')
        ax.set_ylabel('Chirps')
        ax.grid()
        ax.legend(['data_1', 'data_2', 'data_3'])
    
    fig, ax = plt.subplots()
    ani = FuncAnimation(fig, animate, frames=radars[0].n_frames, interval=5, repeat=True)
    plt.show()


if __name__ == '__main__':
    radars = [Process(filename='gps_data_1.mat'), Process(filename='gps_data_2.mat'), Process(filename='gps_data_3.mat')]
    # estimate_range(radar, rx_index=3)
    # radars = [Process('gps_data_2.mat')]
    estimate_range(radars)