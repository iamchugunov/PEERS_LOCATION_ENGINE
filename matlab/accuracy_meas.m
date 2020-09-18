function [ m, s, p1m, r95 ] = accuracy_meas( data )

    m = mean(data);
    s = std(data);
    p1m = length(find(data>1))/length(data);
    a = sort(data);
    r95 = a(round(0.95*length(a)));
    r95 = a(round(0.9*length(a)));


end

