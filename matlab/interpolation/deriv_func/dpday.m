function [f] = dpday(y,x,t,i,j, config)
    Sn = config.sigma_n;
    X = config.PostsENU;
    f = dpdy(y,x,t,i,j, config) * t^2/2;
end

