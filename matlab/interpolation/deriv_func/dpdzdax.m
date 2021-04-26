function [f] = dpdzdax(y,x,t,i,j, config)
    f = t^2/2 * dpdxdz(y,x,t,i,j, config);
end

