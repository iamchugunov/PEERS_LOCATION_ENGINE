classdef ToAEKF_const_per
    
    properties (Access = public) % атрибуты класса
        X; % вектор состояния
        Dx; % матрица дисперсий ошибок фильтрации
        sigma_n; % СКО шума наблюдения ToA отметок
        sigma_ksi; % СКО формирующего шума по скорости
        c; % скорость света
        D_ksi; % матрица формирующих шумов
        y_prev;
        dt_raw;
        dt_fil;
    end
    
    methods (Access = public)
        function obj = ToAEKF_const_per(X0, y, config) % конструктор
           obj.X = X0;
           obj.Dx = eye(length(X0));
           obj.sigma_n = config.sigma_n; % м
           obj.sigma_ksi = config.sigma_ksi; % м/с
           obj.D_ksi = eye(2)*config.sigma_ksi^2;
           obj.y_prev = y;
        end
 
        
        function obj = Update(obj, y, dt, config) % загрузка новых измерений = обновление фильтра
            
            X_prev = obj.X;
            Dx = obj.Dx;
            
            dt_all = (y - obj.y_prev)/config.c;
            dt_fil = obj.make_delta( dt_all, X_prev, config );
            obj.dt_raw = mean(dt_all);
            obj.dt_fil = mean(dt_fil);
            
%             dt = obj.dt_fil;
            
            F = [1 dt 0 0 0 ;
                 0 1 0 0 0;
                 0 0 1 dt 0;
                 0 0 0 1 0
                 0 0 0 0 1];
             
            G = [0 0; dt 0; 0 0; 0 dt; 0 0];
            
            D_n = config.sigma_n^2 * eye(size(y,1));
            
            X_ext = F * X_prev;
            X_ext(5) =  X_ext(5) + dt*config.c;

            D_x_ext = F * Dx * F' + G * obj.D_ksi * G';
            dS = obj.make_dS(X_ext, config);
            S = obj.make_S(X_ext, config);
            K = D_x_ext * dS' * inv(dS*D_x_ext*dS' + D_n);
            Dx = D_x_ext - K * dS * D_x_ext;
            X_prev = X_ext + K*(y - S);
            
            obj.X = X_prev;
            obj.Dx = Dx;
            obj.y_prev = y;
            
        end
        
        function [ S ] = make_S( obj, X, config )
            for i = 1:size(config.posts,2)
                S(i,1) = sqrt((X(1,1) - config.posts(1,i))^2 + (X(3,1) - config.posts(2,i))^2 + (config.hei - config.posts(3,i))^2) + X(5,1);
            end
        end


        function [ dS ] = make_dS( obj, X, config )
            for i = 1:size(config.posts,2)
                d = sqrt((X(1,1) - config.posts(1,i))^2 + (X(3,1) - config.posts(2,i))^2 + (config.hei - config.posts(3,i))^2);
                dS(i,1) = (X(1,1) - config.posts(1,i))/d;
                dS(i,2) = 0;
                dS(i,3) = (X(3,1) - config.posts(2,i))/d;
                dS(i,4) = 0;
                dS(i,5) = 1;
            end
        end

        function [ delta ] = make_delta( obj, y, X, config )
            X = obj.X;
            for i = 1:length(y)
                x = config.posts(:,i);
                delta(i,1) = y(i)/(1 + (X(2)*(X(1) - x(1)) + X(4)*(X(3) - x(2)))/(config.c*sqrt((X(1) - x(1))^2 + (X(3) - x(2))^2 + (config.hei - x(3))^2)));
            end
        end
        
    end
    
    
    
end



