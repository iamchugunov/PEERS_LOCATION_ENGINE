function [X, dop] = coord_solver2D(y, posts, X0, h)

    epsilon = 0.001;
    max_iter = 7;
    
    N = size(posts,2);
    Y = zeros(N, 1);
    H = zeros(N, 3);
    X = X0;
    
    iter = 0;
    
while 1
    
    iter = iter + 1;
    
    for i = 1:N
        d = sqrt((X(1,1) - posts(1,i))^2 + (X(2,1) - posts(2,i))^2 + (h - posts(3,i))^2);
        Y(i, 1) = d + X(3,1);
        H(i, 1) = (X(1,1) - posts(1,i))/d;
        H(i, 2) = (X(2,1) - posts(2,i))/d;
        H(i, 3) = 1;
    end
    
    X_prev = X;
    X = X + (H'*H)^(-1)*(H')*(y-Y);
    
    if (norm(X - X_prev) < epsilon) || (iter > max_iter)
        invHH = inv(H'*H);
        DOPx = abs(invHH(1,1));
        DOPy = abs(invHH(2,2));
        DOPt = abs(invHH(3,3));
        dop = sqrt([DOPx DOPy DOPt])';
        break
    end
end

end

