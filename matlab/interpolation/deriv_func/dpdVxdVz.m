function [f] = dpdVxdVz(y,x,t,i,j, config)
    f = t^2 * dpdxdz(y,x,t,i,j, config);
end

