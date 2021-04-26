function [f] = dpdTdT(y,x,t,i,j, config)
    Sn = config.sigma_n;
    f = - 1/Sn^2;
end

