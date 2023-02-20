from controllerTest import write_adr

try:
    while True:
        mac = input("mac adr: ")
        if (len(mac)!= 17):
            print("format invalide")
        else:
            print(mac)
            write_adr("",mac)
except KeyboardInterrupt:
    print("\nstop")