function [out] = mdek_distande_read()

if nargin == 0
    [file, path] = uigetfile('*.*');
    filename = fullfile(path,file);  
end

    f = fopen(filename);
    k = 0;
   
    while feof(f)==0 
        
        s=fgetl(f);
        if contains(s,'=')
            k = k + 1;
            out(k) = str2num(s(strfind(s,'=')+1:end));
        end
    end
    
fclose(f);

end

