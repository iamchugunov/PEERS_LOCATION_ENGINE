function [f] = dpdydaz(y,x,t,i,j, config)
    f = t^2/2 * dpdydz(y,x,t,i,j, config);
end

