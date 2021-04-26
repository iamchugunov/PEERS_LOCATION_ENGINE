function [X, Xf] = make_esimation_2D(toa_ns, config, T)
    
    X0 = zeros(9,1);
    X0(1) = 5.82710000000000;
    X0(4) = 4.25440000000000;
    X0(7) = 1;
    
    dw_unit = (1.0/499.2e6/128.0);
    T_max = 2^40 * dw_unit; % timer overflow, sec
    
    t0 = max(toa_ns(:,1)) * 1e-9;
    y = toa_ns(:,1);
    
    N = size(toa_ns,2);
    t = 0; % SV counter
    
    k = 2; % points counter
    while 1
        if k > N
            break
        end
        
        t_k = max(toa_ns(:,k)) * 1e-9;
        if t_k - t0 < 0
            t_k = t_k + T_max;
        end
        
        if t_k - t0 < T
            y = [y toa_ns(:,k)];
        else
            k = k + 1;
            t = t + 1;
            [X1, R, nev] = max_likelyhood_2dv(y, config, X0);
            X(:,t) = X1(1:9);
            d4 = inv(-R);
            D4 = [d4(1,1); d4(2,2); d4(3,3); d4(4,4); d4(5,5); d4(6,6); d4(7,7); d4(8,8); d4(9,9)];
            D_n = diag(D4);
            if t == 1
                Xf(:,1) = X1(1:9);
                D_x = eye(9);
                D_ksi = diag([0.1 0.1 0].^2);
            else
                [Xf(:,t), D_x] = Kalman_step_3D(X(:,t), Xf(:,t-1), D_x, T, D_n, D_ksi);
            end
            
            try
                t0 = max(toa_ns(:,k)) * 1e-9;
                y = [];
                y = toa_ns(:,k);
            end
        end
        
        k = k + 1;
        
    end
    
end

