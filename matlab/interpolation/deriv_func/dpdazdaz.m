function [f] = dpdazdaz(y,x,t,i,j, config)
    f = t^4/4 * dpdzdz(y,x,t,i,j, config);
end

