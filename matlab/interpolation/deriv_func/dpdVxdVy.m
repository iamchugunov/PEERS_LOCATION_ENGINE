function [f] = dpdVxdVy(y,x,t,i,j, config)
    f = t^2 * dpdxdy(y,x,t,i,j, config);
end

