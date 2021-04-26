function [f] = dpdaxdax(y,x,t,i,j, config)
    f = t^4/4 * dpdxdx(y,x,t,i,j, config);
end

