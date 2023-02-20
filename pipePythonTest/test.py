l = "01234567890123456789"
print(l)
print(l[5:])#tout sauf 5 premier
print(l[:5])#5 premier

base = "00:00:00:00:00:0"
for i in range(0,5):
    s = base + str(i)
    print (s)