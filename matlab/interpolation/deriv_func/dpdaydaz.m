function [f] = dpdaydaz(y,x,t,i,j, config)
    f = t^4/4 * dpdydz(y,x,t,i,j, config);
end

