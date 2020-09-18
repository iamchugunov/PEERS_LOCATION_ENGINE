function [ X ] = PD_2D( XpT, PD, h, Init )
    
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
            D = norm(XpT(:,j) - [X(1:2);h]);
            H(j,:) = [(X(1:2) - XpT(1:2,j))'/D 1];
            
            Y(j,1) = D + X(3); % "экстрапол€ци€" наблюдений
        end
        
        
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



