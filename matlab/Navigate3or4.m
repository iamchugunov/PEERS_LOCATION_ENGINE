function [ xla,yla,Hla,dT, DOP, NEV, err, flag ] = Navigate3or4( XpT, PD, h_LA, x0, y0, T )
    
    N = length(PD);
    
    y = [PD; h_LA];
    
    X = [x0;y0;h_LA;T];
    k = 0;
    while 1 % число итераций
        k = k + 1;
        H = zeros(N,3);
        Y = zeros(N,1);
        for j = 1:N
            D = norm(XpT(:,j) - X(1:3));
            H(j,:) = (X(1:3) - XpT(:,j))'/D;
            Y(j,1) = D + X(4); % "экстрапол€ци€" наблюдений
        end
        
        Y = [Y; h_LA];
        H = [H ones(N,1)];
        H = [H; 0 0 1 0];
        nev = y - Y;
        NEV = norm(nev);
        X_prev = X;
        X = X + H'*H\H'*nev;
        err = norm(X-X_prev);
        error1(k) = err;
        if err < 1e-3
            flag = true;
            break
        end
        if k > 10
            
                flag = 1;
                            
            break
        end
        
    end
%         plot(error1);
   if (err>1e8) || (norm(X([1 2])) > 1e5) 
       flag = 0;
   end
       xla = X(1); 
       yla = X(2);
       Hla = X(3);
       dT = X(4);
        
           
        
        % HDOP calculation %
        invHH = inv(H'*H);
        DOPx = abs(invHH(1,1));
        DOPy = abs(invHH(2,2));
        DOP = sqrt(DOPx + DOPy);
        if (N >= 3)
            GDOP=sqrt(trace(invHH));
            HDOP3=sqrt(trace(invHH(1:2,1:2)));
        end

end

