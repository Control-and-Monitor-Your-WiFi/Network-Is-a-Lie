import time
from pipe import write_adr



base = "00:00:00:00:00:0"
for i in range(0,5):
    s = base + str(i)
    write_adr("pipe",s)
    time.sleep(1)


