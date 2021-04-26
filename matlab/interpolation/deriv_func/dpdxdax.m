function [f] = dpdxdax(y,x,t,i,j, config)
    f = t^2/2 * dpdxdx(y,x,t,i,j, config);
end

