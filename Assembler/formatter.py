print("data_in = 16'hFFFF")

with open("out.txt", 'r') as f:
    for line in f.readlines():
        print("#100")
        print("data_in = 16'b" + line[:-1] + ";")