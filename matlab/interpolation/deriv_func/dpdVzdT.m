function [f] = dpdVzdT(y,x,t,i,j, config)
    f = t * dpdzdT(y,x,t,i,j, config);
end

