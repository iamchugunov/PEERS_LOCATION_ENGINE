function [XX] = make_interp(X, T)
    t = 0:0.1:T;
    for i = 1:length(t)
        XX(1,i) = X(1) + X(2) * t(i) + X(3) * t(i)^2/2;
        XX(2,i) = X(4) + X(5) * t(i) + X(6) * t(i)^2/2;
    end
end

