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
        
        nums = find(toa_ns(:,k) < 0);
        if ~isempty(nums)
            toa_ns(nums,k) = toa_ns(nums,k) + T_max * 1e9;
        end
        
        t_k = max(toa_ns(:,k)) * 1e-9;
        if t_k - t0 < 0
            t_k = t_k + T_max;
        end
        
        if t_k - t0 < T
            y = [y toa_ns(:,k)];
        else
            t = t + 1;
            
            xx = [];
            flag = [];
            for j = 1:size(y,2)
                [xx(:,j) dop, nev, flag(j)] = coord_solver2D(y(:,j)*config.c, config.PostsENU, [5;5;max(y(:,1))*config.c], 1);
            end
            nums = find(flag);
            xx = xx(:,nums);
            TT = max(y) * 1e-9;
            TT = TT(nums);
            for j = 2:length(TT)
                if TT(j) - TT(j-1) < 0
                    TT(j) = TT(j) + T_max;
                end
            end
            XA = approx1(xx(1:2,:),TT);
            
            X0(1:6) = XA;
            [X1, R, nev] = max_likelyhood_3Da(y, config, X0);
%             [X1, R, nev] = max_likelyhood_2dv(y, config, X0);
%             X0 = X1;

            
            
%             XX = [X1(1) X1(1) + X1(2) * T + X1(3) * T^2/2; X1(4) X1(4) + X1(5) * T + X1(6) * T^2/2;];
            XX = make_interp(X1,T);
%             XX0 = [X0(1) X0(1) + X0(2) * T + X0(3) * T^2/2; X0(4) X0(4) + X0(5) * T + X0(6) * T^2/2];
            XX0 = make_interp(X0,T);
            figure(3)
            hold on
            plot(xx(1,:),xx(2,:),'b.-')
            plot(XX(1,:),XX(2,:),'r.-')
            plot(XX0(1,:),XX0(2,:),'g.-')
            
            
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
            
            X_e = X(:,t);
            
            X0(1) = X_e(1) + X_e(2) * T + X_e(3) * T^2/2;
            X0(2) = X_e(2) + X_e(3) * T;
            X0(3) = X_e(3);
            X0(4) = X_e(4) + X_e(5) * T + X_e(6) * T^2/2;
            X0(5) = X_e(5) + X_e(6) * T;
            X0(6) = X_e(6);
            
            try
                t0 = max(toa_ns(:,k)) * 1e-9;
                y = [];
                y = toa_ns(:,k);
            end
        end
        
        k = k + 1;
        
    end
    
end

