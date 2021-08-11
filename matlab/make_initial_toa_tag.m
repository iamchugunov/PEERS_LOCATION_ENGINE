function [flag, ax, delta] = make_initial_toa_tag(tx, d)
    t = [];
    x = [];
    
    dw_unit = (1.0 / 499.2e6 / 128.0);
    T_max = 2^40 * dw_unit;
    
    for i = 1:length(tx)
        t = [t tx(i)];
        if i > 1 && t(i) - t(i-1) < 0
            t(i) = t(i) + T_max;
        end
        x = [x d(i)];
    end
    
    A = [length(tx) 0; 0 0];
    b = [0;0];
    
    for i = 1:length(tx)
        A(1,2) = A(1,2) + t(i);
        A(2,2) = A(2,2) + t(i)^2;
        b(1) = b(1) + x(i);
        b(2) = b(2) + x(i) * t(i);
    end
    A(2,1) = A(1,2);
    
    ax = inv(A) * b;
    
    delta = 0;
    for i = 1:length(tx)
        delta = delta + (ax(1) + ax(2)*tx(i) - d(i))^2;
    end
    delta = sqrt(delta/length(tx));
    
    if delta < 3e-10
        flag = 1;
    else
        flag = 0;
    end
    
end

