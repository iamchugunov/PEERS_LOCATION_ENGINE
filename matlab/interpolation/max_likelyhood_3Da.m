function [X, R, nev] = max_likelyhood_3Da(y, config, X0)
    addpath("deriv_func")   
    N = size(y,2);
%     t0 = min(min(y));
    t0 = max(y(:,1)) - 1;
%     t0 = 0;
    
    X = zeros(9 + N,1);
    X(1:9) = X0;
    X(10:end) = max(y)-10;
    
%     dpdX = zeros(9 + N, 1);
%     dp2d2X = zeros(9 + N, 9 + N);
    
    k = 0;
    while 1
        dpdX = zeros(9 + N, 1);
        dp2d2X = zeros(9 + N, 9 + N);
        for j = 1:N
            for i = 1:size(y,1)
                if y(i,j)
                    t_k = (y(i,j) - t0)*1e-9;
                    d = [ dpdx(y(i,j),X,t_k,i,j, config);
                         dpdVx(y(i,j),X,t_k,i,j, config);
                         dpdax(y(i,j),X,t_k,i,j, config);
                         dpdy(y(i,j),X,t_k,i,j, config);
                         dpdVy(y(i,j),X,t_k,i,j, config);
                         dpday(y(i,j),X,t_k,i,j, config);
                         dpdz(y(i,j),X,t_k,i,j, config);
                         dpdVz(y(i,j),X,t_k,i,j, config);
                         dpdaz(y(i,j),X,t_k,i,j, config);];
                    dpdX(1:9) = dpdX(1:9) + d;
                    dpdX(9 + j) = dpdX(9 + j) +  dpdT(y(i,j),X,t_k,i,j, config);

                    dd = zeros(9 + N, 9 + N);

                    dd(1,1) = dpdxdx(y(i,j),X,t_k,i,j, config);
                    dd(1,2) = dpdxdVx(y(i,j),X,t_k,i,j, config);
                    dd(2,1) = dd(1,2);
                    dd(1,3) = dpdxdax(y(i,j),X,t_k,i,j, config);
                    dd(3,1) = dd(1,3);
                    dd(1,4) = dpdxdy(y(i,j),X,t_k,i,j, config);
                    dd(4,1) = dd(1,4);
                    dd(1,5) = dpdxdVy(y(i,j),X,t_k,i,j, config);
                    dd(5,1) = dd(1,5);
                    dd(1,6) = dpdxday(y(i,j),X,t_k,i,j, config);
                    dd(6,1) = dd(1,6);
                    dd(1,7) = dpdxdz(y(i,j),X,t_k,i,j, config);
                    dd(7,1) = dd(1,7);
                    dd(1,8) = dpdxdVz(y(i,j),X,t_k,i,j, config);
                    dd(8,1) = dd(1,8);
                    dd(1,9) = dpdxdaz(y(i,j),X,t_k,i,j, config);
                    dd(9,1) = dd(1,9);
                    dd(1,9 + j) = dpdxdT(y(i,j),X,t_k,i,j, config);
                    dd(9 + j, 1) = dd(1,9 + j);

                    dd(2,2) = dpdVxdVx(y(i,j),X,t_k,i,j, config);
                    dd(2,3) = dpdVxdax(y(i,j),X,t_k,i,j, config);
                    dd(3,2) = dd(2,3);
                    dd(2,4) = dpdydVx(y(i,j),X,t_k,i,j, config);
                    dd(4,2) = dd(2,4);
                    dd(2,5) = dpdVxdVy(y(i,j),X,t_k,i,j, config);
                    dd(5,2) = dd(2,5);
                    dd(2,6) = dpdVxday(y(i,j),X,t_k,i,j, config);
                    dd(6,2) = dd(2,6);
                    dd(2,7) = dpdzdVx(y(i,j),X,t_k,i,j, config);
                    dd(7,2) = dd(2,7);
                    dd(2,8) = dpdVxdVz(y(i,j),X,t_k,i,j, config);
                    dd(8,2) = dd(2,8);
                    dd(2,9) = dpdVxdaz(y(i,j),X,t_k,i,j, config);
                    dd(9,2) = dd(2,9);
                    dd(2,9 + j) = dpdVxdT(y(i,j),X,t_k,i,j, config);
                    dd(9 + j, 2) = dd(2,9 + j);

                    dd(3,3) = dpdaxdax(y(i,j),X,t_k,i,j, config);
                    dd(3,4) = dpdydax(y(i,j),X,t_k,i,j, config);
                    dd(4,3) = dd(3,4);
                    dd(3,5) = dpdVydax(y(i,j),X,t_k,i,j, config);
                    dd(5,3) = dd(3,5);
                    dd(3,6) = dpdaxday(y(i,j),X,t_k,i,j, config);
                    dd(6,3) = dd(3,6);
                    dd(3,7) = dpdzdax(y(i,j),X,t_k,i,j, config);
                    dd(7,3) = dd(3,7);
                    dd(3,8) = dpdVzdax(y(i,j),X,t_k,i,j, config);
                    dd(8,3) = dd(3,8);
                    dd(3,9) = dpdaxdaz(y(i,j),X,t_k,i,j, config);
                    dd(9,3) = dd(3,9);
                    dd(3,9 + j) = dpdaxdT(y(i,j),X,t_k,i,j, config);
                    dd(9 + j, 3) = dd(3,9 + j);

                    dd(4,4) = dpdydy(y(i,j),X,t_k,i,j, config);
                    dd(4,5) = dpdydVy(y(i,j),X,t_k,i,j, config);
                    dd(5,4) = dd(4,5);
                    dd(4,6) = dpdyday(y(i,j),X,t_k,i,j, config);
                    dd(6,4) = dd(4,6);
                    dd(4,7) = dpdydz(y(i,j),X,t_k,i,j, config);
                    dd(7,4) = dd(4,7);
                    dd(4,8) = dpdydVz(y(i,j),X,t_k,i,j, config);
                    dd(8,4) = dd(4,8);
                    dd(4,9) = dpdydaz(y(i,j),X,t_k,i,j, config);
                    dd(9,4) = dd(4,9);
                    dd(4,9 + j) = dpdydT(y(i,j),X,t_k,i,j, config);
                    dd(9 + j, 4) = dd(4,9 + j);

                    dd(5,5) = dpdVydVy(y(i,j),X,t_k,i,j, config);
                    dd(5,6) = dpdVyday(y(i,j),X,t_k,i,j, config);
                    dd(6,5) = dd(5,6);
                    dd(5,7) = dpdzdVy(y(i,j),X,t_k,i,j, config);
                    dd(7,5) = dd(5,7);
                    dd(5,8) = dpdVydVz(y(i,j),X,t_k,i,j, config);
                    dd(8,5) = dd(5,8);
                    dd(5,9) = dpdVydaz(y(i,j),X,t_k,i,j, config);
                    dd(9,5) = dd(5,9);
                    dd(5,9 + j) = dpdVydT(y(i,j),X,t_k,i,j, config);
                    dd(9 + j, 5) = dd(5,9 + j);

                    dd(6,6) = dpdayday(y(i,j),X,t_k,i,j, config);
                    dd(6,7) = dpdzday(y(i,j),X,t_k,i,j, config);
                    dd(7,6) = dd(6,7);
                    dd(6,8) = dpdVzday(y(i,j),X,t_k,i,j, config);
                    dd(8,6) = dd(6,8);
                    dd(6,9) = dpdaydaz(y(i,j),X,t_k,i,j, config);
                    dd(9,6) = dd(6,9);
                    dd(6,9 + j) = dpdaydT(y(i,j),X,t_k,i,j, config);
                    dd(9 + j, 6) = dd(6,9 + j);

                    dd(7,7) = dpdzdz(y(i,j),X,t_k,i,j, config);
                    dd(7,8) = dpdzdVz(y(i,j),X,t_k,i,j, config);
                    dd(8,7) = dd(7,8);
                    dd(7,9) = dpdzdaz(y(i,j),X,t_k,i,j, config);
                    dd(9,7) = dd(7,9);
                    dd(7,9 + j) = dpdzdT(y(i,j),X,t_k,i,j, config);
                    dd(9 + j, 7) = dd(7,9 + j);

                    dd(8,8) = dpdVzdVz(y(i,j),X,t_k,i,j, config);
                    dd(8,9) = dpdVzdaz(y(i,j),X,t_k,i,j, config);
                    dd(9,8) = dd(8,9);
                    dd(8,9 + j) = dpdVzdT(y(i,j),X,t_k,i,j, config);
                    dd(9 + j, 8) = dd(8,9 + j);

                    dd(9,9) = dpdazdaz(y(i,j),X,t_k,i,j, config);
                    dd(9,9 + j) = dpdazdT(y(i,j),X,t_k,i,j, config);
                    dd(9 + j, 9) = dd(9,9 + j);

                    dd(9 + j,9 + j) = dpdTdT(y(i,j),X,t_k,i,j, config);

                    dp2d2X = dp2d2X + dd;

                end
            end
        end
        X_prev = X;
        X = X - inv(dp2d2X) * dpdX;
        k = k + 1;
%         norm(X - X_prev)
        nev(1,k) = norm(X - X_prev);
        nev(2,k) = norm(X(1:4) - X_prev(1:4));
        if norm(X - X_prev) < 0.5 || k > 10
            R = dp2d2X;
            break;
        end
        
    end
    
    
end

