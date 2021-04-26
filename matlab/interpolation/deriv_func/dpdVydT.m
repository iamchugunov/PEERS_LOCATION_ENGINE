function [f] = dpdVydT(y,x,t,i,j, config)
    f = t * dpdydT(y,x,t,i,j, config);
end

