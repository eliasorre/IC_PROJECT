#!/usr/bin/env python3
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import sys
import math
import tikzplotlib
import os

buffer = ""
with open("pixelSensor_tb_copy.cir") as fi:
    for line in fi:
        if(line.startswith(".param C_EXPOSE")):
            buffer += ".param C_EXPOSE = {expose}\n"
        elif(line.startswith("gnuplot s")):
            buffer += "gnuplot storeplot{vsplot} XDUT2.VSTORE\n"
        elif(line.startswith("gnuplot m")):
            buffer += "gnuplot manyplot{many} XDUT2.VSTORE ERASE EXPOSE CONVERT VRAMP XDUT2.VCMP_OUT READ\n"
        elif(line.startswith("tran")):
            buffer += "tran 1n {tran}u"
        else:
            buffer += line

fon = "pixelSensor_tb_sweep"
exposes = [0, 50, 100, 150, 200, 250, 300, 400, 450, 500, 700, 1600]
trans = [40, 45, 55, 60, 65, 70, 75, 80, 85, 90, 95, 120, 200]
plot_number = np.arange(11)

for i in range(len(exposes)):
    buffer_tmp = buffer.replace("{expose}",str(exposes[i]))
    buffer_tmp = buffer_tmp.replace("{many}", str(plot_number[i]))
    buffer_tmp = buffer_tmp.replace("{tran}", str(trans[i]))
    cir = buffer_tmp.replace("{vsplot}", str(plot_number[i]))
    with open(f"{fon}.cir", "w") as fo:
        fo.write(cir)
    os.system(f"ngspice {fon}.cir")
    #os.system(f"python3 freq.py {fon}.csv 'v(a1)' 4.1e-9 >> {fon}.yaml")
