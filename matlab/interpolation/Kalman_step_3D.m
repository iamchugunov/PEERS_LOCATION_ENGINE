function [X, D_x] = Kalman_step_3D(y, X_prev, D_x, dt, D_n, D_ksi)
            
            F1 = [1 dt dt^2; 0 1 dt; 0 0 1];
            F = zeros(9,9);
            F(1:3,1:3) = F1;
            F(4:6,4:6) = F1;
            F(7:9,7:9) = F1;
            
            G = zeros(9,3);
            G(3,1) = dt;
            G(6,2) = dt;
            G(9,3) = dt;
            
            H = eye(9);
            

            X_ext = F * X_prev; % экстраполяция вектора состояния
            D_x_ext = F * D_x * F' + G * D_ksi * G'; % экстраполяция матрицы дисперсий ошибок фильтрации
            M = H*D_x_ext*H' + D_n; % вычисление матрицы M
            K = D_x_ext * H' * inv(M); % вычисление матрицы КУ 
            D_x = D_x_ext - K * H * D_x_ext; % оценка матрицы дисперсий ошибок фильтрации
            discr = y - H*X_ext; % вычисление невязки
            if norm(discr([1 3])) < 1e4
                X = X_ext + K*discr; % оценка вектора состояния
            else
                X = X_ext;
            end
end

