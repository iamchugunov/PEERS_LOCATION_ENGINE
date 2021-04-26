function [f] = dpdVydVz(y,x,t,i,j, config)
    f = t^2 * dpdydz(y,x,t,i,j, config);
end



