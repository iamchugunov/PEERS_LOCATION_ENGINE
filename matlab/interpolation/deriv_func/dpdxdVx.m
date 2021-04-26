function [f] = dpdxdVx(y,x,t,i,j, config)
    f = t * dpdxdx(y,x,t,i,j, config);
end

