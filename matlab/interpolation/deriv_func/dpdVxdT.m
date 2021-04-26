function [f] = dpdVxdT(y,x,t,i,j, config)
    f = t * dpdxdT(y,x,t,i,j, config);
end

