function f = ln_p(y,x,t,i,j,config)
    Sn = config.sigma_n;
    f = 1/Sn^2 * y * S_t(x, t, i, j, config) - 1/(2*Sn^2)*S_t(x, t, i, j, config)^2;
end

