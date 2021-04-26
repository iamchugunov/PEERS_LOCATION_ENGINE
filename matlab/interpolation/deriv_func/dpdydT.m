function [f] = dpdydT(y,x,t,i,j, config)
    Sn = config.sigma_n;
    X = config.PostsENU;
    f = - 1/Sn^2 * 1/config.c * (y_t(x,t) - X(2,i))/R_t(x, t, X(:,i));
end

