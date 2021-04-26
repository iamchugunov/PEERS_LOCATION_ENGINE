function [f] = dpdVz(y,x,t,i,j, config)
    Sn = config.sigma_n;
    X = config.PostsENU;
    f = dpdz(y,x,t,i,j, config) * t;
end

