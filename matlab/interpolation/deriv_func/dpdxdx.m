function [f] = dpdxdx(y,x,t,i,j, config)
    Sn = config.sigma_n;
    X = config.PostsENU;
    % производная частного (первое слагаемое в dp/dx
    f1 = 1/Sn^2 * y * 1/config.c * (R_t(x, t, X(:,i)) - (x_t(x,t) - X(1,i))^2/R_t(x, t, X(:,i)))/R_t(x, t, X(:,i))^2;
    % производная произведения (второе слагаемое слагаемое в dp/dx
    % сначала произодная частного во втором множителе
    f3 = (R_t(x, t, X(:,i)) - (x_t(x,t) - X(1,i))^2/R_t(x, t, X(:,i)))/R_t(x, t, X(:,i))^2;
    f2 = 1/Sn^2 * 1/config.c * ( 1/config.c * (x_t(x,t) - X(1,i))/R_t(x, t, X(:,i)) * (x_t(x,t) - X(1,i))/R_t(x, t, X(:,i)) + S_t(x, t, i, j, config) * f3);
    f = f1 - f2;
end

