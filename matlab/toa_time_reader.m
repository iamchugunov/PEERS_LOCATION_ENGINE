function [tags, SatPos] = toa_time_reader(filename)

    SatPos(:,1) = [12.05; 4.8; 3.0];
    SatPos(:,2) = [12.05; 0.0; 3.0];
    SatPos(:,3) = [0.0; 0.0; 3.0];
    SatPos(:,4) = [0.0; 4.8; 3.0];
    
if nargin == 0
    [file, path] = uigetfile('*.*');
    filename = fullfile(path,file);  
end

    f = fopen(filename);
    
    tags(1).name = 'cc15';
    tags(2).name = 'cf0';
    tags(1).cord_count = 0;
    tags(2).cord_count = 0;
    tags(1).bl_count = 0;
    tags(2).bl_count = 0;
    tags(1).sn = [];
    tags(2).sn = [];
    tags(1).cords = [];
    tags(2).cords = [];
    tags(1).toa = [];
    tags(2).toa = [];
    tags(1).tx = [];
    tags(2).tx = [];
    
    
    
    while feof(f)==0 
        s=fgetl(f);
        [out] = replace_kovichki(s);
        S = jsondecode(out);
        
        switch S.type
            case "BLINK"
                switch S.sender
                    case 'cc15'
                        N = 1;
                    case 'cf00'
                        N = 2;
                end
                num = find(tags(N).sn == S.sn);
                if isempty(num)
                    flag = 0;
                else
                    if tags(N).bl_count - num(end) > 30
                        flag = 0;
                    else
                        num = num(end);
                        flag = 1;
                    end
                end
                
                if flag == 0
                    tags(N).bl_count = tags(N).bl_count + 1;
                    num = tags(N).bl_count;
                end
                tags(N).sn(num) = S.sn;
                tags(N).toa(S.anchor_number,num) = S.corrected_timestamp;
                
                
            case "TOA_BLINK_TIME"
                switch S.receiver
                    case 'cc15'
                        N = 1;
                    case 'cf00'
                        N = 2;
                end
                num = find(tags(N).sn == S.sn);
                if isempty(num)
                    flag = 0;
                else
                    if tags(N).bl_count - num(end) > 20
                        flag = 0;
                    else
                        num = num(end);
                        flag = 1;
                    end
                end
                
                if flag == 0
                    tags(N).bl_count = tags(N).bl_count + 1;
                    num = tags(N).bl_count;
                end
                tags(N).sn(num) = S.sn;
                tags(N).tx(1,num) = S.timestamp;
                
            case "tag"
                
        end
                
        
         
              

                

    end
    fclose(f);
end








