function [f] = dpdaxdT(y,x,t,i,j, config)
    Sn = config.sigma_n;
    X = config.PostsENU;
    f = dpdxdT(y,x,t,i,j, config) * t^2/2;
end

