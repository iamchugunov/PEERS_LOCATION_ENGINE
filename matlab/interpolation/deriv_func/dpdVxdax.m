function [f] = dpdVxdax(y,x,t,i,j, config)
    f = t^3/2 * dpdxdx(y,x,t,i,j, config);
end

