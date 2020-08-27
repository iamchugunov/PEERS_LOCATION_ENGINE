function [ d ] = process_one_folder( folder )
if nargin == 0
folder = uigetdir;
end
S = split(folder);
TruePos = [str2num(S{2});str2num(S{3});str2num(S{4}) - 1];
files = dir(folder);
for i = 1:length(files)
    if contains(files(i).name,'CCtag')
        break;
    end
end
filename = fullfile(folder,files(i).name);
out = cctagreader2(filename);
for i = 1:length(out)
    for j = 51:length(out(i).coord)
        d(i).data(j-50) = norm(out(i).coord(:,j-50) - TruePos);
    end
    d(i).data(find(d(i).data > 2)) = [];
    [ m, s, p1m, r95 ] = accuracy_meas( d(i).data );
    d(i).mean = m;
    d(i).std = s;
    d(i).p1m = p1m;
    d(i).r95 = r95;
end



end

