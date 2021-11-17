import csv
import matplotlib.pyplot as plt

header = []
data = []


filename = "comp_test.csv"
with open(filename) as csvfile:
    csvreader = csv.reader(csvfile)

    header = next(csvreader)

    for datapoint in csvreader:

        values = [float(value) for value in datapoint]
        data.append(values)

voltage = [p[0] for p in data]
vc_out = [p[2] for p in data]
# id = [p[2] for p in data]
# rds = [p[3] for p in data]
# #va = [p[1] for p in data]
# #gm = [p[1] for p in data]

#ch2 = [p[2] for p in data]


plt.plot(voltage,vc_out)
#plt.plot(time, ch2)
plt.xlabel("VSTORE Voltage")
plt.ylabel("VCMP_OUT voltage")
#plt.legend(['av_2', 'Utgangssignal'], loc = "upper right")    
plt.show()