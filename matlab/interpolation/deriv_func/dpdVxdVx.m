function [f] = dpdVxdVx(y,x,t,i,j, config)
    f = t^2 * dpdxdx(y,x,t,i,j, config);
end

