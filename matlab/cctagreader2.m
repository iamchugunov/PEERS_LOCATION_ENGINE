function [out] = cctagreader2(filename)

if nargin == 0
    [file, path] = uigetfile('*.*');
    filename = fullfile(path,file);  
end

    f = fopen(filename);
    k = 0;
    out(1).ID = 'beef010010945997';
    out(1).coord = [];
    out(1).k = 0;
    out(2).ID = 'beef010050b4451b';
    out(2).coord = [];
    out(2).k = 0;
    out(3).ID = 'beef010050b44b86';
    out(3).coord = [];
    out(3).k = 0;
    
    while feof(f)==0 
        s=fgetl(f);
        if contains(s,'A:')
            S = split(s);
            ID = S{1}(16:end);
            
                for i = 1:length(out)
                   if out(i).ID == ID
                       break;
                   end
                end
                               
                    out(i).k = out(i).k + 1;
                    out(i).coord(:,out(i).k) = [str2num(S{2}(3:end)); str2num(S{3}(3:end)); str2num(S{4}(3:end))];
                
                               
                    
        end
    end
    fclose(f);
end


