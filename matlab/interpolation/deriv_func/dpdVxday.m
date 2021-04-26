function [f] = dpdVxday(y,x,t,i,j, config)
    f = t^3/2 * dpdxdy(y,x,t,i,j, config);
end

