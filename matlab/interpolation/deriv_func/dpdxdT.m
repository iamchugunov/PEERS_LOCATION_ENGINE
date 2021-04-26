function [f] = dpdxdT(y,x,t,i,j, config)
    Sn = config.sigma_n;
    X = config.PostsENU;
    f = - 1/Sn^2 * 1/config.c * (x_t(x,t) - X(1,i))/R_t(x, t, X(:,i));
end

