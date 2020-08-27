import numpy as np
from anchor import Anchor
from tag import Tag


# PSEUDORANGE (TOA) TAG'S POSITION ESTIMATION USING LEAST SQUARE METHOD

def solver_pd_2D(SatPos, PD, h, Init, config):
    N = PD.size

#    y = np.zeros((N+1,1))
#    for i in range(N):
#        y[i,0] = PD[i,0]
#    y[N] = h
    y = PD
    X = Init
    k = 0
    while True:
        H = np.zeros((N,3))
        Y = np.zeros((N,1))
        for j in range(N):
            D = np.sqrt(pow(SatPos[0,j] - X[0,0], 2) + pow(SatPos[1,j] - X[1,0], 2) + pow(SatPos[2,j] - h, 2))
            H[j, 0] = (X[0, 0] - SatPos[0, j]) / D
            H[j, 1] = (X[1, 0] - SatPos[1, j]) / D
            H[j, 2] = 1.
            Y[j, 0] = D + X[2,0]

        X_prev = X
        X = X + ((np.linalg.inv(H.transpose().dot(H))).dot(H.transpose())).dot(y-Y)
        k = k + 1

        if (np.linalg.norm(X - X_prev) < 0.001) or (k > 8):
            break
    invHH = np.linalg.inv(H.transpose().dot(H))
    DOP = np.sqrt(invHH[0, 0] * invHH[0, 0] + invHH[1, 1] * invHH[1, 1])
    if (np.linalg.norm(X - X_prev) < 1) and (np.sqrt(pow(X[0, 0], 2) + pow(X[1, 0], 2)) < config.zone):
        b = True
    else:
        b = False

    return b, X, DOP

def solver_pd_3D(SatPos, PD, h, Init, config):
    N = PD.size

#    y = np.zeros((N+1,1))
#    for i in range(N):
#        y[i,0] = PD[i,0]
#    y[N] = h
    y = PD
    X = Init
    k = 0
    while True:
        H = np.zeros((N,4))
        Y = np.zeros((N,1))
        for j in range(N):
            D = np.sqrt(pow(SatPos[0,j] - X[0,0], 2) + pow(SatPos[1,j] - X[1,0], 2) + pow(SatPos[2,j] - X[2,0], 2))
            H[j, 0] = (X[0, 0] - SatPos[0, j]) / D
            H[j, 1] = (X[1, 0] - SatPos[1, j]) / D
            H[j, 2] = (X[2, 0] - SatPos[2, j]) / D
            H[j, 3] = 1.
            Y[j, 0] = D + X[3,0]

        X_prev = X
        X = X + ((np.linalg.inv(H.transpose().dot(H))).dot(H.transpose())).dot(y-Y)
        k = k + 1

        if (np.linalg.norm(X - X_prev) < 0.001) or (k > 8):
            break
    invHH = np.linalg.inv(H.transpose().dot(H))
    DOP = np.sqrt(invHH[0, 0] * invHH[0, 0] + invHH[1, 1] * invHH[1, 1])
    if (np.linalg.norm(X - X_prev) < 1) and (np.sqrt(pow(X[0, 0], 2) + pow(X[1, 0], 2)) < config.zone):
        b = True
    else:
        b = False

    return b, X, DOP

# TDOA TAG'S POSITION ESTIMATION USING LEAST SQUARE METHOD

def solver_rd(SatPos, RD, h, Init):
    N = RD.size
    y = RD
    X = Init
    k = 0
    while True:
        H = np.zeros((N,2))
        Y = np.zeros((N,1))
        for j in range(N):
            D = np.sqrt(
                pow(SatPos[0, j + 1] - X[0, 0], 2) + pow(SatPos[1, j + 1] - X[1, 0], 2) + pow(SatPos[2, j + 1] - h, 2))
            Dm = np.sqrt(pow(SatPos[0, 0] - X[0, 0], 2) + pow(SatPos[1, 0] - X[1, 0], 2) + pow(SatPos[2, 0] - h, 2))
            H[j, 0] = (X[0, 0] - SatPos[0, j + 1]) / D - (X[0, 0] - SatPos[0, 0]) / Dm
            H[j, 1] = (X[1, 0] - SatPos[1, j + 1]) / D - (X[1, 0] - SatPos[1, 0]) / Dm
            Y[j, 0] = D - Dm

        X_prev = X
        X = X + ((np.linalg.inv(H.transpose().dot(H))).dot(H.transpose())).dot(y-Y)
        k = k + 1

        if (np.linalg.norm(X - X_prev) < 0.001) or (k > 8):
            break

    return X

# SYNCHRONIZATION ALGORITHM USING LINEAR KALMAN FILTER

def CS_filter(X, Dx, dt, t_M, t_S, R):

    Dn = 6.e-20
    Q  = 5.e-20/0.0225

    y = t_S - t_M - R
    F = np.array([[1., dt],[0., 1.]])
    G = np.array([[0.],[dt]])
    H = np.array([1., 0.])
    H = H.reshape(1,2)
    x_ext = F.dot(X)
    D_ext = (F.dot(Dx)).dot(F.transpose()) + (G.dot(Q)).dot(G.transpose())
    K = (D_ext.dot(H.transpose()))/((H.dot(D_ext)).dot(H.transpose()) + Dn)
    Dx = D_ext - (K.dot(H)).dot(D_ext)
    X = x_ext + K.dot(y - H.dot(x_ext))
    return X, Dx

# MESSAGE PROCESSING FUNCTIONS

def process_NM(mes, config):
    new_anchor = Anchor(mes, 0)
    master = Anchor(mes, 1)
    if len(config.anchors) > 0:
        config.anchors.append(new_anchor)
    else:
        config.anchors.append(master)
        config.anchors.append(new_anchor)

def process_CS(mes, config):
    if mes.Seq != config.cur_seq:
        config.cur_seq = mes.Seq
        for anchor in config.anchors:
            anchor.need_to_sync = 0

    for anchor in config.anchors:
        if anchor.number == mes.Anchor:
            anchor.need_to_sync = 1
            anchor.T_rec = mes.TimeStamp

    for anchor in config.anchors:
        if (anchor.master == 0) and (config.anchors[0].need_to_sync*anchor.need_to_sync):
            anchor.need_to_sync = 0
            if anchor.sync_flag:
                dt = config.anchors[0].T_rec - anchor.T_tx
                if dt < 0:
                    dt = dt + config.T_max
                anchor.X, anchor.Dx = CS_filter(anchor.X, anchor.Dx, dt, config.anchors[0].T_rec, anchor.T_rec, anchor.Range)
                anchor.T_tx = config.anchors[0].T_rec
            else:
                anchor.X = np.array([[anchor.T_rec - config.anchors[0].T_rec - anchor.Range], [0.0]])
                anchor.sync_flag = 1
                anchor.T_tx = config.anchors[0].T_rec

def process_BLINK(mes, config):
    match_flag = 0
    for tag in config.tags:
        if mes.ID == tag.ID:
            tag.add_meas(mes, config)
            match_flag = 1

    if match_flag == 0:
        tag = Tag(mes, config)
        tag.add_meas(mes, config)
        config.tags.append(tag)
        print("NEW TAG HAS BEEN FOUND, ID: " + str(tag.ID))