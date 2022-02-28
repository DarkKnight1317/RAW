from matplotlib import image
import numpy as np
from reader import *
from process import *
# from plot_range_profile import *
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from scipy.fftpack import fftshift

def estimate_velocity(radars=['gps_data_1.mat'], rx_index=0):        
    sample_axis_factor = 0.0976
    chirp_axis_factor = 0.1201
    def animate(frame):
        ax.clear()
        print(f"frame = {frame}")
        for radar in radars:
            # mat = np.array(radar.fft_1[f'r{rx_index}'])
            doppler_main = 20 * np.log10(np.abs(np.array(radar.fft_2[f'r{rx_index}'])))
            image = fftshift(doppler_main, axes=(1,))
            extent = [-64 * chirp_axis_factor, 63 * chirp_axis_factor, 0 * sample_axis_factor, 256 * sample_axis_factor]
            ax.imshow(np.transpose(image[frame, :, :]), origin='lower', extent=extent)
            ax.set_title(f"Range-Dopler Plot, frame:{frame+1}")
            ax.set_xlabel('Velocity')
            ax.set_ylabel('Range in meter')
        

    print(f"Plotting Range Dopler Plot...")
    fig, ax = plt.subplots()
    ani = FuncAnimation(fig, animate, frames=radars[0].n_frames, interval=50, repeat=False)
    plt.show()


if __name__ == '__main__':
    radar = [Process('gps_data_3.mat')]
    # radars = [Process(filename='gps_data_1.mat'), Process(filename='gps_data_2.mat'), Process(filename='gps_data_3.mat')]
    estimate_velocity(radar)