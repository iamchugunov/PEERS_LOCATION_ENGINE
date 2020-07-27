import numpy as np

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
        self.Dx = np.array([[1, 0.0], [0.0, 1]])
        self.T_rec = 0.0
        self.T_tx = 0.0
        self.master = master