function [f] = dpdzdVy(y,x,t,i,j, config)
    f = t * dpdydz(y,x,t,i,j, config);
end

