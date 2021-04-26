function [f] = dpdaxdaz(y,x,t,i,j, config)
    f = t^4/4 * dpdxdz(y,x,t,i,j, config);
end

