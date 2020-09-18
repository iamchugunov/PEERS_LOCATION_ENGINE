import numpy as np
import clelib as cle

class Anchor():
    def __init__(self, mes, master):
        if master:
            self.number = mes.Master
            self.x = mes.Master_x
            self.y = mes.Master_y
            self.z = mes.Master_z
            self.Range = 0.
        else:
            self.number = mes.Anchor
            self.x = mes.Anchor_x
            self.y = mes.Anchor_y
            self.z = mes.Anchor_z
            self.Range = mes.R
        self.sync_flag = 0
        self.need_to_sync = 0
        self.X = np.array([[0.0], [0.0]])
        self.Dx = np.array([[2.46e-20, 4.21e-20], [4.21e-20, 1.94e-19]])
        self.T_rec = 0.0
        self.T_tx = 0.0
        self.master = master
        self.startnumber = 10
        self.tx = []
        self.rx = []
        self.k_skip = 0 # number of skipped rx messages by raim

    def add_meas(self, config, tx, rx):
        if len(self.tx) == self.startnumber:
            del self.tx[0]
            del self.rx[0]
        self.tx.append(tx)
        self.rx.append(rx)
        if len(self.tx) == self.startnumber:
            t = []
            x = []
            for i in range(0, self.startnumber):
                t.append(self.tx[i])
                if i > 0 and t[i] - t[i-1] < 0:
                    t[i] = t[i] + config.T_max
                x.append(self.rx[i] - self.tx[i] - self.Range)
            A = np.array([[self.startnumber, 0.], [0., 0.]])
            b = np.array([[0.0], [0.0]])
            for i in range(0, self.startnumber):
                A[0][1] = A[0][1] + t[i]
                A[1][1] = A[1][1] + pow(t[i], 2)
                b[0][0] = b[0][0] + x[i]
                b[1][0] = b[1][0] + x[i] * t[i]
            A[1][0] = A[0][1]
            ax = (np.linalg.inv(A)).dot(b)
            delta = 0.
            for i in range(0, self.startnumber):
                delta = delta + pow(ax[0][0] + ax[1][0]*t[i] - x[i], 2)
            delta = np.sqrt(delta/self.startnumber)
            if delta < 3.0e-10:
                self.sync_flag = 1
                X = np.array([ax[0][0] + ax[1][0]*t[0], ax[1][0]])
                Dx = self.Dx
                for i in range(1, self.startnumber):
                    dt = self.tx[i] - self.tx[i-1]
                    if dt < 0:
                        dt = dt + config.T_max
                    b, X, Dx, nev = cle.CS_filter(X, Dx, dt, self.tx[i], self.rx[i], self.Range)

                #self.X[0][0] = ax[0][0] + ax[1][0]*t[len(t)-1]
                #self.X[1][0] = ax[1][0]
                self.X = X
                self.Dx = Dx
                self.T_tx = self.tx[len(self.tx)-1]
                self.tx = []
                self.rx = []



