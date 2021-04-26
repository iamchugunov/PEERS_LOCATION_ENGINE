function [f] = dpdVzdaz(y,x,t,i,j, config)
    f = t^3/2 * dpdzdz(y,x,t,i,j, config);
end

