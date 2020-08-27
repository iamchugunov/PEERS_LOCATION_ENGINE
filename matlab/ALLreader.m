function [out] = ALLreader(filename)

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
       
            S = split(s);
            ID = S{1};
            
                for i = 1:length(out)
                   if out(i).ID == ID
                       break;
                   end
                end
                               
                    out(i).k = out(i).k + 1;
                    out(i).coord(:,out(i).k) = [str2num(S{2}); str2num(S{3}); str2num(S{4})];
                
                               
                    
        
    end
    fclose(f);
end




