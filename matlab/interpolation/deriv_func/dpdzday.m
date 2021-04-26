function [f] = dpdzday(y,x,t,i,j, config)
    f = t^2/2 * dpdydz(y,x,t,i,j, config);
end

