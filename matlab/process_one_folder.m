function [ d ] = process_one_folder( folder )
if nargin == 0
folder = uigetdir;
end

mode = 'my';

S = split(folder);
TruePos = [str2num(S{2});str2num(S{3});str2num(S{4})];
files = dir(folder);

switch mode
    case 'ttk'
        for i = 1:length(files)
            if contains(files(i).name,'CCtag')
                break;
            end
        end
        filename = fullfile(folder,files(i).name);
        out = cctagreader2(filename);
    case 'my'
        for i = 1:length(files)
            if contains(files(i).name,'ALL')
                break;
            end
        end
        filename = fullfile(folder,files(i).name);
        out = ALLreader(filename);
end
for i = 1:length(out)
figure(1)
plot(TruePos(1),TruePos(2),'xk','linewidth',2)
plot(out(1).coord(1,:),out(1).coord(2,:),'.')
for i = 1:1
    d(i).data = [];
    for j = 1:size(out(i).coord,2)
        d(i).data(j) = norm(out(i).coord(:,j) - TruePos);
    end
    d(i).mean = NaN;
    d(i).std = NaN;
    d(i).p1m = NaN;
    d(i).r95 = NaN;
    if ~isnan(d(i).data)
        d(i).data(find(d(i).data > 2)) = [];
    end
    
    if length(d(i).data) > 120
        d(i).data = d(i).data(20:end);
        [ m, s, p1m, r95 ] = accuracy_meas( d(i).data );
        d(i).mean = m;
        d(i).std = s;
        d(i).p1m = p1m;
        d(i).r95 = r95;
    end
    
        
end


end

