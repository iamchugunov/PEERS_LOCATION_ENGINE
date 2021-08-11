function [ X, Dx, nev, flag ] = CS_filter( X, Dx, dt, t_M, t_S, R )

    Dn = 6e-20;
    Q =  5e-20/0.0225;
    
    c = 299792458;
    
    y = t_S - t_M - R;
    
    dw_unit = (1.0 / 499.2e6 / 128.0);
    T_max = 2^40 * dw_unit;
    
    if dt < 0
        dt = dt + T_max;
    end
    
    F = [1 dt; 0 1];
    G = [0;dt];
    H = [1 0];
    
    x_ext = F * X;
    D_ext = F * Dx * F' + G * Q * G';
        K = D_ext * H' * inv(H * D_ext * H' + Dn);
        Dx = D_ext - K * H * D_ext;
        X = x_ext + K * (y - H * x_ext);
        nev = (y - H * x_ext);
%         if abs(nev) < 1e-6%6*sqrt(Dx(1,1))
        if abs(nev) < 6*sqrt(Dx(1,1))
            flag = 1;
        else
            flag = 0;
        end
    
    
end

