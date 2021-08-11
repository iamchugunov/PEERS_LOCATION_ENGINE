function [co, ti] = blinks_count_read()

if nargin == 0
    [file, path] = uigetfile('*.*');
    filename = fullfile(path,file);  
end

    f = fopen(filename);
    k1 = 0;
    k2 = 0;
   
    while feof(f)==0 
        
        s=fgetl(f);
        if contains(s,'BLINK')
            S = split(s);
            if S{3,1} == 'd121'
                k1 = k1 + 1;
                out1(:,k1) = [str2num(S{1,1}); str2num(S{5,1}); str2num(S{6,1})];
            elseif S{3,1} == 'cc15'
                k2 = k2 + 1;
                out2(:,k2) = [str2num(S{1,1}); str2num(S{5,1}); str2num(S{6,1})];
            end
        end
    end
    co = [size(out1,2);size(out2,2)];
    ti = [out1(1,end) - out1(1,1); out2(1,end) - out2(1,1)];
    
    
fclose(f);

end



