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
        out(4,k) = str2num(S{4});
        out(5,k) = str2num(S{5});
        out(6,k) = str2num(S{6});
    end
    
fclose(f);

end



