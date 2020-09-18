function [out] = mylogreader()

if nargin == 0
    [file, path] = uigetfile('*.*');
    filename = fullfile(path,file);  
end

    f = fopen(filename);
    k = 0;
   
    while feof(f)==0 
        k = k + 1;
        s=fgetl(f);
        S = split(s);
        out(1,k) = str2num(S{1});
        out(2,k) = str2num(S{2});
        out(3,k) = str2num(S{3});
        N = str2num(S{4});
        for i = (1:2:2*N) + 4
            K = str2num(S{i});
            out(3+K,k) = str2num(S{i+1});
        end
    end
    
fclose(f);

end



