function [out] = RTDoAreader(filename)

if nargin == 0
    [file, path] = uigetfile('*.*');
    filename = fullfile(path,file);  
end

    f = fopen(filename);

    anchors = [];
    tags = [];
    
    current_seq = 0;
    k = 1;
    while feof(f)==0 
        s=fgetl(f);
        
        if contains(s,"CS_RX	1aa6083cf91cf00")
            S = split(s);
            if str2num(S{5,1}) > current_seq
                k = k + 1;
                current_seq = str2num(S{5,1});
            end
            
            ID = S{4,1};
            rx = str2num(S{6,1});
            switch ID
                case "1aa6083cf91ccb4"
                    m = 1;
                case "1aa6083cf91cc15"
                    m = 2;
            end
            if str2num(S{5,1}) < current_seq
                out(m,k-1) = rx;
            else
                out(m,k) = rx;
            end
        end
        
        
              

                

    end
    fclose(f);
end






