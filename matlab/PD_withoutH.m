function [ X ] = PD_withoutH( XpT, PD, h_LA, Init )
    
    N = length(PD);
    
%     y = [PD; h_LA];
    y = PD;
%     X = [x0;y0;h_LA;T];
    X = Init
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
        H(:,4) = 1;
        
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


end

