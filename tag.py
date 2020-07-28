import datetime
import numpy as np
import clelib as cl

class Tag():
    def __init__(self, mes):
        self.ID = mes.ID
        self.SN = 1000
        self.measurements = []
        self.x = 3.
        self.y = 3.
        self.ToT = 0.
        self.h = 0.
        self.state = 0
        filename = "logs/" + str(datetime.datetime.now()) + "_" + self.ID + ".txt"
        filename = filename.replace(" ", "_")
        filename = filename.replace(":", "_")
        filename = filename.replace("-", "_")
        self.file = open(filename, 'w')

    def add_meas(self, mes, config):
        if mes.SN != self.SN:
            self.SN = mes.SN
            flag = self.coords_calc(config)
            if flag:
                # coords output
                self.file.write(str(self.x) + " " + str(self.y) + " " + str(self.ToT) + "\n")
                print("Tag " + self.ID + ", x: " + str(self.x) + " m, y: " + str(self.y) + " m")
            self.measurements = []
        self.measurements.append(mes)

    def coords_calc(self, config):
        N = len(self.measurements)
        if N < 3:
            return False
        else:
            SatPos = np.zeros((3, N))
            PD = np.zeros((N, 1))
            for i, Sat in enumerate(self.measurements):
                for anchor in config.anchors:
                    if anchor.number == Sat.Anchor:
                        SatPos[0][i] = anchor.x
                        SatPos[1][i] = anchor.y
                        SatPos[2][i] = anchor.z
                        PD[i][0] = Sat.TimeStamp - (anchor.X[0] + anchor.X[1]*(Sat.TimeStamp - anchor.T_rec))
            PD = PD * config.c
            Init = np.zeros((3, 1))
            Init[0, 0] = self.x
            Init[1, 0] = self.y
            Init[2, 0] = PD[0][0]
            try:
                b, X = cl.solver_pd(SatPos, PD, self.h, Init, config)
                if b:
                    self.x = X[0, 0]
                    self.y = X[1, 0]
                    self.ToT = X[2, 0]/config.c
                    return True
                else:
                    return False
            except:
                return False
