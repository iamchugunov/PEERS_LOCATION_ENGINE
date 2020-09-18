function [ OUT ] = checkpoint_average( data )
k = 0;
t = 0;
d = [];
while k < 120

for i = 1:6
    k = k + 1;
    d = [d data(k).data];
end
t = t+1;
OUT(t).data = d;
if length(d) > 50
    [ m, s, p1m, r95 ] = accuracy_meas( d );
    OUT(t).m = m;
    OUT(t).s = s;
    OUT(t).p1m = p1m;
    OUT(t).r95 = r95;
else
    OUT(t).m = NaN;
    OUT(t).s = NaN;
    OUT(t).p1m = NaN;
    OUT(t).r95 = NaN;
end
d = [];


end

