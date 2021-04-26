function [f] = dpdayday(y,x,t,i,j, config)
    f = t^4/4 * dpdydy(y,x,t,i,j, config);
end

