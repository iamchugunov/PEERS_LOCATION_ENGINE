function [f] = dpdVydVy(y,x,t,i,j, config)
    f = t^2 * dpdydy(y,x,t,i,j, config);
end

