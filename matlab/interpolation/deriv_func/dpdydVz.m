function [f] = dpdydVz(y,x,t,i,j, config)
    f = t * dpdydz(y,x,t,i,j, config);
end

