function [f] = dpdydVy(y,x,t,i,j, config)
    f = t * dpdydy(y,x,t,i,j, config);
end

