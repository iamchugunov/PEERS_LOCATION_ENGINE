function [f] = dpdydVx(y,x,t,i,j, config)
    f = t * dpdxdy(y,x,t,i,j, config);
end

