import datetime
import numpy as np
import clelib as cl

class Tag():
    def __init__(self, mes, config):
        self.ID = mes.ID
        self.SN = 1000
        self.measurements = []
        self.x = 3.
        self.y = 3.
        self.ToT = 0.
        self.h = config.hei
        self.DOP = 1.
        self.state = 0
        filename = "logs/" + str(datetime.datetime.now()) + "_" + self.ID + ".txt"
        filename = filename.replace(" ", "_")
        filename = filename.replace(":", "_")
        filename = filename.replace("-", "_")
        self.file = open(filename, 'w')

    def add_meas(self, mes, config):
        if mes.SN != self.SN:
            self.SN = mes.SN
            if config.mode == 0:
                flag = self.coords_calc_2D(config)
            if config.mode == 1:
                flag = self.coords_calc_3D(config)
            if flag:
                # coords output
                s = str(datetime.datetime.now().timestamp()) + " " + str(self.x) + " " + str(self.y) + " "
                s = s + str(len(self.measurements))
                for meas in self.measurements:
                    s = s + " " + str(meas.Anchor) + " " + str(meas.TimeStamp)
                s = s + "\n"
                self.file.write(s)
                config.f.write(self.ID + " " + str(self.x) + " " + str(self.y) + " " + str(self.h) + "\n")
                print("Tag " + self.ID + ", x: " + str(self.x) + " m, y: " + str(self.y) + " m ")
            self.measurements = []
        self.measurements.append(mes)

    def coords_calc_2D(self, config):
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
                        Sat.TimeStamp = PD[i][0]
            PD = PD * config.c
            Init = np.zeros((3, 1))
            Init[0, 0] = self.x
            Init[1, 0] = self.y
            Init[2, 0] = PD[0][0]
            try:
                b, X, DOP = cl.solver_pd_2D(SatPos, PD, self.h, Init, config)
                if b:
                    self.x = X[0, 0]
                    self.y = X[1, 0]
                    self.ToT = X[2, 0]/config.c
                    self.DOP = DOP
                    return True
                else:
                    return False
            except:
                return False

    def coords_calc_3D(self, config):
        N = len(self.measurements)
        if N < 4:
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
            Init = np.zeros((4, 1))
            Init[0, 0] = self.x
            Init[1, 0] = self.y
            Init[2, 0] = config.hei
            Init[3, 0] = PD[0][0]
            try:
                b, X, DOP = cl.solver_pd_3D(SatPos, PD, self.h, Init, config)
                if b:
                    self.x = X[0, 0]
                    self.y = X[1, 0]
                    self.h = X[2, 0]
                    self.ToT = X[3, 0]/config.c
                    self.DOP = DOP
                    return True
                else:
                    return False
            except:
                return False
