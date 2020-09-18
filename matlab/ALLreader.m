function [out] = ALLreader(filename)

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
    out(6).ID = 'beef010010b3c28e';
    out(6).coord = [];
    out(6).k = 0;
    out(7).ID = 'dead010010b44811';
    out(7).coord = [];
    out(7).k = 0;
    out(8).ID = 'dead010010b44980';
    out(8).coord = [];
    out(8).k = 0;
    out(9).ID = 'dead010050b44907';
    out(9).coord = [];
    out(9).k = 0;
    out(10).ID = 'dead010010b44426';
    out(10).coord = [];
    out(10).k = 0;
    
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




