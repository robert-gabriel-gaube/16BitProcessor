with open("out.txt", 'r') as f:
    idx = 0
    for line in f.readlines():
        idx = idx + 1
        print(idx)
        print("#100")
        print("data_in = 16'b" + line[:-1] + ";")