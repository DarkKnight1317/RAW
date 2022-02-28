import os
import matplotlib.pyplot as plt 
import numpy as np 

from reader import *

gps = Readgps()
lat, lon, alt = gps.load_gps()
plt.plot(lon, lat)
plt.ylabel('Latitude')
plt.xlabel('Longitude')
plt.title('Lon vs Lat')
plt.grid()
plt.show()