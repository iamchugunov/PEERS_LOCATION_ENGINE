function [f] = dpdaxday(y,x,t,i,j, config)
    f = t^4/4 * dpdxdy(y,x,t,i,j, config);
end

