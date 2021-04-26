function [f] = dpdVx(y,x,t,i,j, config)
    Sn = config.sigma_n;
    X = config.PostsENU;
    f = dpdx(y,x,t,i,j, config) * t;
end

