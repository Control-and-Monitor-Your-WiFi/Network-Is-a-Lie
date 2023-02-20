def read_adr(pipe_path):
    try:
        f = open(pipe_path, "r+")
        text = f.read()
        f.close()
        f = open(pipe_path, "w")
        f.write(text[17:])
        f.close()
        return text[:17]
    except:
        return ""

def write_adr(pipe_path, mac_adr):
    f = open(pipe_path, "a")
    f.write(mac_adr)
    f.close()