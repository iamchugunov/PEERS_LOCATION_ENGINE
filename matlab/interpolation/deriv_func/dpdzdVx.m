function [f] = dpdzdVx(y,x,t,i,j, config)
    f = t * dpdxdz(y,x,t,i,j, config);
end

