function [X] = approx1(cord, T)

    N = size(cord, 2);
    T = T - min(T);
    X = cord(1,:);
    Y = cord(2,:);
    
    A = zeros(3,3);
    A(1,1) = N;
    for i = 1:N
    A(1,2) = A(1,2) + T(i);
    A(2,2) = A(2,2) + T(i)^2;
    A(2,3) = A(2,3) + T(i)^3;
    A(3,3) = A(3,3) + T(i)^4;
    end
    A(2,1) = A(1,2);
    A(1,3) = A(2,2);
    A(3,1) = A(2,2);
    A(3,2) = A(2,3);
    
    bx = [0;0;0];
    by = [0;0;0];
    for i = 1:N
        bx(1) = bx(1) + X(i);
        bx(2) = bx(2) + T(i)*X(i);
        bx(3) = bx(3) + T(i)^2*X(i);
        by(1) = by(1) + Y(i);
        by(2) = by(2) + T(i)*Y(i);
        by(3) = by(3) + T(i)^2*Y(i);
    end
    ax = A\bx;
    ay = A\by;
    X = [ax(1);ax(2);ax(3);ay(1);ay(2);ay(3)];
    flag = 1;
end

