function [out] = cctagreader()

if nargin == 0
    [file, path] = uigetfile('*.*');
    filename = fullfile(path,file);  
end

    f = fopen(filename);
    k = 0;
   
    while feof(f)==0 
        s=fgetl(f);
        if contains(s,'A:')
            k = k + 1;
            S = split(s);
            out(1,k) = str2num(S{2}(3:end));
            out(2,k) = str2num(S{3}(3:end));
            out(3,k) = str2num(S{4}(3:end));
            out(4,k) = str2num(S{1}(3:11));
        end
    end
end
