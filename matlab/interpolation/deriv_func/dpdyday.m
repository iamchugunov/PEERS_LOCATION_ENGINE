function [f] = dpdyday(y,x,t,i,j, config)
    f = t^2/2 * dpdydy(y,x,t,i,j, config);
end

