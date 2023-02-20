import time
from pipe import read_adr


for i in range (0,20):
    mac = read_adr("pipe")
    print(i,mac)
    time.sleep(0.5)

