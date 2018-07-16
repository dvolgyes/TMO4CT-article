#!/usr/bin/python3
import sys
import numpy as np

def list2array(x):
    return np.asarray(list(x))

lines = sys.stdin.readlines()
array = list(map(str.split,lines))
array = np.stack(list(map(list2array,array)))

for column in range(array.shape[1]):
    try:
        idx = np.argmax(array[:,column].astype(np.float))
        array[idx,column] = "\\bf "+array[idx,column]
        align=">"
    except:
        align=""
    length = max(map(len,array[:,column].tolist()))
    for row in range(array.shape[0]):
        v = array[row,column]
        array[row,column] = f"{v:{align}{length}}"

for row in range(array.shape[0]):
    print(" ".join(array[row,:].tolist()))

