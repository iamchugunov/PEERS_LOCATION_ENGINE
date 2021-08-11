tag.tx = [];
tag.d = [];
tag.skipped = 0;
tag.sync_flag = 0;
tag.last_tx = 0;
tag.X = [0;0];
tag.Dx = eye(2);
tag.T_max = 17.207401025641026;
tag.count = 0;
tag.SV = [];
tag.nev = [];
tag.cord_count = 0;
tag.cord = [];
tag.tx_all = [];
tag.delta_all = [];
k = 0;

for i = 1:length(toa)
    
   [X1, dop, nev1, flag] = coord_solver2D(toa(:,i)*3e8, SatPos, [12;3;0], 1.5);
    X1(3) = X1(3) / 3e8;
    
   
   
   if flag
       
       k = k + 1;
       XX(:,k) = X1;
       
       if tag.sync_flag
                       
            dt = tx(i) - tag.last_tx;
            if dt < 0
                dt = dt + tag.T_max;
            end
            
            
            
            [X, Dx, nev, flag1 ] = CS_filter( tag.X, tag.Dx, dt, 0, X1(3) - tx(i), 0 );
            if flag1
                tag.skipped = 0;
                tag.count = tag.count + 1;
                tag.X = X;
                tag.Dx = Dx;
                tag.last_tx = tx(i);
                tag.SV(:,tag.count) = tag.X;
                tag.nev(:,tag.count) = X(1) - (X1(3) - tx(i));
                tag.tx_all(:,tag.count) = tx(i);
                tag.delta_all(:,tag.count) = X1(3) - tx(i);
            else
                tag.skipped = tag.skipped + 1;
                if tag.skipped == 5
                    tag.sync_flag = 0;
                    disp("sync_lost")
                    tag.count
                    tag.skipped = 0;
                end
            end
            
            
            dt = tx(i) - tag.last_tx;
            if dt < 0
                dt = dt + tag.T_max;
            end
            tag.cord_count = tag.cord_count + 1;
            tag.tx_cor(:,tag.cord_count) = tx(i) + (tag.X(1) + tag.X(2) * dt);
            tag.Ranges(:,tag.cord_count) = toa(:,i) - tag.tx_cor(:,tag.cord_count);
            [X, dop] = NavSolver_D(tag.Ranges(1:3,tag.cord_count) * 3e8, SatPos(:,1:3), [0;0], 1.5);
            if norm(X) < 1e4
                tag.cord(:,tag.cord_count) = X;
            else
                tag.cord(:,tag.cord_count) = tag.cord(:,tag.cord_count-1);
            end
            
       else
            if length(tag.d) == 5
                tag.d(1) = [];
                tag.tx(1) = [];
            end
            tag.d = [tag.d X1(3) - tx(i)];
            tag.tx = [tag.tx tx(i)];
            if length(tag.d) == 5
                [flag1, ax, delta] = make_initial_toa_tag(tag.tx, tag.d);
                if flag1
                    disp("synchronized")
                    tag.count
                    tag.X = [ax(1) + ax(2) * tag.tx(1); ax(2)];
                    tag.Dx = [2.45512825887635e-20,4.21003916489954e-20;4.21003916489954e-20,1.94387199405452e-19];
                    for j = 2:5
                        dt = tag.tx(j) - tag.tx(j-1);
                        if dt < 0
                            dt = dt + tag.T_max;
                        end
                        [tag.X, tag.Dx, nev, flag ] = CS_filter( tag.X, tag.Dx, dt, 0, tag.d(j), 0 );
                        tag.count = tag.count + 1;
                        tag.SV(:,tag.count) = tag.X;
                        tag.nev(:,tag.count) = nev;
                        tag.last_tx = tag.tx(j);
                        tag.tx_all(:,tag.count) = tx(i);
                        tag.delta_all(:,tag.count) = X1(3) - tx(i);
                    end
                    tag.sync_flag = 1;
                    tag.d = [];
                    tag.tx = [];
                end
            end
       end
            
   end
    
       
end

% X(1,:) = medfilt1(X(1,:)); 
% X(2,:) = medfilt1(X(2,:));
% X(3,:) = medfilt1(X(3,:));
