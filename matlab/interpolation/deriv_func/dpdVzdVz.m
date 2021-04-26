function [f] = dpdVzdVz(y,x,t,i,j, config)
    f = t^2 * dpdzdz(y,x,t,i,j, config);
end

