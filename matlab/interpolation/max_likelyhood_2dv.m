function [X, R, nev] = max_likelyhood_2dv(y, config, X0)
    addpath("deriv_func")   
    N = size(y,2);
%     t0 = min(min(y));
%     t0 = max(y(:,1)) - 1;
    t0 = 0;
    
    X = zeros(4 + N,1);
    X(1:4) = X0([1 2 4 5]);
    h = X0(7);
    X(5:end) = max(y)-10;
    
%     dpdX = zeros(9 + N, 1);
%     dp2d2X = zeros(9 + N, 9 + N);
    
    k = 0;
    while 1
        dpdX = zeros(4 + N, 1);
        dp2d2X = zeros(4+ N, 4 + N);
        for j = 1:N
            for i = 1:size(y,1)
                if y(i,j) > 0
                    t_k = (y(i,j) - t0)*1e-9;
                    X_9 = zeros(9,1);
                    X_9(1) = X(1);
                    X_9(2) = X(2);
                    X_9(4) = X(3);
                    X_9(5) = X(4);
                    X_9(7) = h;
                    X_9(10:9+N) = X(5:end);
                    
                    d = [ dpdx(y(i,j),X_9,t_k,i,j, config);
                         dpdVx(y(i,j),X_9,t_k,i,j, config);
                         dpdy(y(i,j),X_9,t_k,i,j, config);
                         dpdVy(y(i,j),X_9,t_k,i,j, config);];
                    dpdX(1:4) = dpdX(1:4) + d;
                    dpdX(4 + j) = dpdX(4 + j) +  dpdT(y(i,j),X_9,t_k,i,j, config);

                    dd = zeros(4 + N, 4 + N);

                    dd(1,1) = dpdxdx(y(i,j),X_9,t_k,i,j, config);
                    dd(1,2) = dpdxdVx(y(i,j),X_9,t_k,i,j, config);
                    dd(2,1) = dd(1,2);
                    dd(1,3) = dpdxdy(y(i,j),X_9,t_k,i,j, config);
                    dd(3,1) = dd(1,3);
                    dd(1,4) = dpdxdVy(y(i,j),X_9,t_k,i,j, config);
                    dd(4,1) = dd(1,4);
                    dd(1,4 + j) = dpdxdT(y(i,j),X_9,t_k,i,j, config);
                    dd(4 + j, 1) = dd(1,4 + j);

                    dd(2,2) = dpdVxdVx(y(i,j),X_9,t_k,i,j, config);
                    dd(2,3) = dpdydVx(y(i,j),X_9,t_k,i,j, config);
                    dd(3,2) = dd(2,3);
                    dd(2,4) = dpdVxdVy(y(i,j),X_9,t_k,i,j, config);
                    dd(4,2) = dd(2,4);
                    dd(2,4 + j) = dpdVxdT(y(i,j),X_9,t_k,i,j, config);
                    dd(4 + j, 2) = dd(2,4 + j);


                    dd(3,3) = dpdydy(y(i,j),X_9,t_k,i,j, config);
                    dd(3,4) = dpdydVy(y(i,j),X_9,t_k,i,j, config);
                    dd(4,3) = dd(3,4);
                    dd(3,4 + j) = dpdydT(y(i,j),X_9,t_k,i,j, config);
                    dd(4 + j, 3) = dd(3,4 + j);

                    dd(4,4) = dpdVydVy(y(i,j),X_9,t_k,i,j, config);
                    dd(4,4 + j) = dpdVydT(y(i,j),X_9,t_k,i,j, config);
                    dd(4 + j, 4) = dd(4,4 + j);

                    dd(4 + j,4 + j) = dpdTdT(y(i,j),X_9,t_k,i,j, config);

                    dp2d2X = dp2d2X + dd;
                    
                else

                end
            end
        end
        X_prev = X;
%         plot(X(1),X(3),'v')
        X = X - inv(dp2d2X) * dpdX;
        k = k + 1;
        nev(1,k) = norm(X - X_prev);
        nev(2,k) = norm(X(1:4) - X_prev(1:4));
        if norm(X - X_prev) < 0.5 || k > 10
            R = dp2d2X;
            X0(1) = X(1);
            X0(2) = X(2);
            X0(4) = X(3);
            X0(5) = X(4);
            X0(10:9+N) = X(5:end);
            X = X0;
%             lnrho = 0;
%             for j = 1:N
%                 for i = 1:size(y,1)
%                     if y(i,j) > 0
%                         t_k = (y(i,j) - t0)*1e-9;
%                         lnrho = lnrho + ln_p(y(i,j),X,t_k,i,j,config)/config.sigma_n^2;
%                     end
%                 end
%             end
            
            break;
        end
        
    end
    
    
end



