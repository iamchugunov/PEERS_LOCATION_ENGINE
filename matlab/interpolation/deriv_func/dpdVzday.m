function [f] = dpdVzday(y,x,t,i,j, config)
    f = t^3/2 * dpdydz(y,x,t,i,j, config);
end

