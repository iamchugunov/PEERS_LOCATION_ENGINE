function [f] = dpdzdaz(y,x,t,i,j, config)
    f = t^2/2 * dpdzdz(y,x,t,i,j, config);
end

