function [f] = dpdx(y,x,t,i,j, config)
    Sn = config.sigma_n;
    X = config.PostsENU;
    f = 1/Sn^2 * y * 1/config.c * (x_t(x, t) - X(1,i))/R_t(x, t, X(:,i)) - 1/Sn^2 * S_t(x, t, i, j, config) * 1/config.c * (x_t(x, t) - X(1,i))/R_t(x, t, X(:,i));
end

