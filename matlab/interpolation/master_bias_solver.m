function [X] = master_bias_solver(toa_m, posts, X0, h, dR)
    k= 0;
    for j = 1:length(toa_m)
        y = toa_m(:,j);
        if length(find(y)) == 4
            k = k + 1;
            Y = y;
            Y(1) = Y(1) + dR;
            [X(:,k), dop, nev, flag] = coord_solver2D(Y, posts, X0, h);
        end
    end
end

