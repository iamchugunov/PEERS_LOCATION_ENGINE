function [out] = ALLreader2222222222(filename)

if nargin == 0
    [file, path] = uigetfile('*.*');
    filename = fullfile(path,file);  
end

    f = fopen(filename);
    k = 0;
    out(1).ID = 'beef010050b3c216';
    out(1).coord = [];
    out(1).k = 0;
    out(2).ID = 'beef010010b44a28';
    out(2).coord = [];
    out(2).k = 0;
    out(3).ID = 'beef010050b44b86';
    out(3).coord = [];
    out(3).k = 0;
    out(4).ID = 'beef010010b44a14';
    out(4).coord = [];
    out(4).k = 0;
    out(5).ID = 'beef010050b4451b';
    out(5).coord = [];
    out(5).k = 0;
    
    
    while feof(f)==0 
        s=fgetl(f);
        
        S = str2num(s);
        out(S(1)-1).k = out(S(1)-1).k + 1;
        out(S(1)-1).coord(out(S(1)-1).k) = S(2);
       
                               
                    
        
    end
    fclose(f);
end

