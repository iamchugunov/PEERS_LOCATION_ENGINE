function [ X, Dx, nev ] = CS_filter( X, Dx, dt, t_M, t_S, R )

    Dn = 6e-20;
    Q =  5e-20/0.0225;
    
    c = 299792458;
    
    y = t_S - t_M - R;
    
    F = [1 dt; 0 1];
    G = [0;dt];
    H = [1 0];
    
    x_ext = F * X;
    D_ext = F * Dx * F' + G * Q * G';
    if t_S == 0
        X = x_ext;
        Dx = D_ext;
        nev = 0;
    else
        K = D_ext * H' * inv(H * D_ext * H' + Dn);
        Dx = D_ext - K * H * D_ext;
        X = x_ext + K * (y - H * x_ext);
        nev = (y - H * x_ext);
%         if (abs(nev) > 3*sqrt(Dx(1,1)) && Dx(2,2) < 2e-19)
%             X = x_ext;
%             Dx = D_ext;
%         end
    end
    
end

