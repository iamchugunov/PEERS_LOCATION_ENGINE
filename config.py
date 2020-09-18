import datetime

class Config():

    def __init__(self):
        # mode 0 - 2D; 1 - 3D
        self.mode = 0
        # list of anchors // first anchor is always master-anchor
        self.anchors = []
        # list of tags
        self.tags = []
        # dw tic, sec (~16 ps)
        self.dw_unit = (1.0 / 499.2e6 / 128.0)
        # timer overflow, sec
        self.T_max = pow(2., 40.) * self.dw_unit
        # current seq number
        self.cur_seq = 1000
        # speedoflight
        self.c = 299792458.
        # max zone
        self.zone = 1000.
        # heigh of tags in 2D
        self.hei = 1
        # log-file of all tags
        filename = "logs/" + str(datetime.datetime.now()) + "_" + "ALL.txt"
        filename = filename.replace(" ", "_")
        filename = filename.replace(":", "_")
        filename = filename.replace("-", "_")
        self.f = open(filename, 'w')