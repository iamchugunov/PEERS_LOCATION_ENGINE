function [f] = dpdzdVz(y,x,t,i,j, config)
   f = t * dpdzdz(y,x,t,i,j, config);
end

