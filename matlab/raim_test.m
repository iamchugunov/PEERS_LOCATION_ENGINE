function [delta,  X, nev] = raim_test(toa,SatPos)
    k = 0;
    for i = 2:length(toa)
        toa_c = toa(:,i);
        toa_p = toa(:,i-1);
        
        if prod(toa_c) && prod(toa_p) ~= 0
            d = toa(:,i) - toa(:,i-1);
            delta(1,i) = max(d) - min(d);
            if delta(1,i) < 6e-10
                k = k + 1;
                [X(:,k), a, nev(:,i)] = coord_solver2D(toa(:,i)*299792458, SatPos, [5;5;0], 1);
            else
%                 if max(d([1 2 3])) - min(d([1 2 3])) < 5e-10
%                     k = k + 1;
%                     X(:,k) = coord_solver2D(toa([1 2 3],i)*299792458, SatPos(:,[1 2 3]), [5;5;0], 1);
%                 end
%                 if max(d([1 3 4])) - min(d([1 3 4])) < 5e-10
%                     k = k + 1;
%                     X(:,k) = coord_solver2D(toa([1 3 4],i)*299792458, SatPos(:,[1 3 4]), [5;5;0], 1);
%                 end
%                 if max(d([1 2 4])) - min(d([1 2 4])) < 5e-10
%                     k = k + 1;
%                     X(:,k) = coord_solver2D(toa([1 2 4],i)*299792458, SatPos(:,[1 2 4]), [5;5;0], 1);
%                 end
%                 if max(d([2 3 4])) - min(d([2 3 4])) < 5e-10
%                     k = k + 1;
%                     X(:,k) = coord_solver2D(toa([2 3 4],i)*299792458, SatPos(:,[2 3 4]), [5;5;0], 1);
%                 end
            end
        else
            delta(1,i) = 0;
        end
    end
end

