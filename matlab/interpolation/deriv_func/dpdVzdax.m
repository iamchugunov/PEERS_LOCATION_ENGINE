function [f] = dpdVzdax(y,x,t,i,j, config)
    f = t^3/2 * dpdxdz(y,x,t,i,j, config);
end

