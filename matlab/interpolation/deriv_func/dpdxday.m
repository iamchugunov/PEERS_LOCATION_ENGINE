function [f] = dpdxday(y,x,t,i,j, config)
    f = t^2/2 * dpdxdy(y,x,t,i,j, config);
end

