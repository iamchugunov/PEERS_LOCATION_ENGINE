function [ OUT ] = checkpoint_average( data )
k = 0;
t = 0;
d = [];
while k < 60

for i = 1:3
    k = k + 1;
    d = [d data(k).data];
end
t = t+1;
OUT(t).data = d;
[ m, s, p1m, r95 ] = accuracy_meas( d );
d = [];
OUT(t).m = m;
OUT(t).s = s;
OUT(t).p1m = p1m;
OUT(t).r95 = r95;

end

