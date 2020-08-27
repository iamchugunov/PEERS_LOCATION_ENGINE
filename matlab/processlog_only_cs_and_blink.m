function [outCS, CS_filters, ToA, ToA_corr] = processlog_only_cs_and_blink()

if nargin == 0
    [file, path] = uigetfile('*.*');
    filename = fullfile(path,file);  
end

    f = fopen(filename);
    
    dw_unit = (1.0/499.2e6/128.0);
    T_max = 2^40 * dw_unit; % timer overflow, sec
    
    R_sec = zeros(4,1); % geometric distances from beginning of the log, R(1) = 0;
    
    sync_flag = zeros(4,1); % show which filters had started, sync_flag(1) = 0
    need_to_sync = zeros(4,1); % 1 if that anchor not been synchronized yet on this step
  
    for i = 1:4
        CS_filters(i).X = zeros(2,1);
        CS_filters(i).Dx = eye(2);
        CS_filters(i).T_rec = 0;
        CS_filters(i).T_tx = 0;
    end
    
    cur_seq = 1000; % current CS message
    cur_SN = 1000; % current blink message
    
    k_CS = 0;
    k_blink = 0;
    
    while feof(f)==0 
    
       s=fgetl(f);
        
       if contains(s,'New Master') 
           [N,R] = decode_New_Master(s);
           R_sec(N) = R;
       end
       
       if (contains(s,'CS_RX') ||  contains(s,'CS_TX'))
           
           if contains(s,'CS_RX') 
               [N, Seq, RxTx] = decode_CS_RX(s);
               need_to_sync(N) = 1;
           end
           
           if contains(s,'CS_TX')
               [N, Seq, RxTx] = decode_CS_TX(s);
           end

           if Seq ~= cur_seq
                k_CS = k_CS + 1;
                cur_seq = Seq;     
           end
           
           outCS(N,k_CS) = RxTx;
           
           for i = 2:4
               
              if outCS(1,k_CS)*need_to_sync(i)
                  
                  need_to_sync(i) = 0;
                  
                  if sync_flag(i)
                      % one step  
                      dt = outCS(1,k_CS) - CS_filters(i).T_tx; 
                      if dt < 0                     
                          dt = dt + T_max;                        
                      end                     
                      [CS_filters(i).X, CS_filters(i).Dx ] = CS_filter( CS_filters(i).X, CS_filters(i).Dx, dt, outCS(1,k_CS), outCS(i,k_CS), R_sec(i) );
                       CS_filters(i).T_rec = outCS(i,k_CS);
                       CS_filters(i).T_tx = outCS(1,k_CS);
                  else
                      % filter initialization
                      CS_filters(i).X(1) = outCS(i,k_CS) - outCS(1,k_CS) - R_sec(i);
                      CS_filters(i).T_rec = outCS(i,k_CS);
                      CS_filters(i).T_tx = outCS(1,k_CS);
                      sync_flag(i) = 1;
                  end
                  
              end
              
           end

       end
       
    if contains(s,'BLINK')
        [SN, N, T_blink] = decode_BLINK(s);
        
        if SN ~= cur_SN
                k_blink = k_blink + 1;
                cur_SN = SN;     
        end
        
        ToA(N,k_blink) = T_blink;
        
        if sync_flag(N)
            T_blink_corr = T_blink - (CS_filters(N).X(1) + CS_filters(N).X(2)*(T_blink - CS_filters(N).T_rec));
            ToA_corr(N,k_blink) = T_blink_corr;
        end
        
    end
       
    end
    fclose(f);    
    ToA_corr(1,:) = ToA(1,:);
end

function [N, Seq, Tx] = decode_CS_TX(s)
    a = strsplit(s);
    N = str2num(a{3}(1));
    Seq = str2num(a{5});
    Tx = str2num(a{7});
end

function [N, Seq, Rx] = decode_CS_RX(s)
     a = strsplit(s);
     N = str2num(a{4}(1));
     Seq = str2num(a{5});
     Rx = str2num(a{7});
end


function [N,R] = decode_New_Master(s)
    p3 = strfind(s,':');
    N = str2num(s(p3(1)+1));
    a = strsplit(s);
    R = str2num(a{15});
end

function [SN, N, T_blink] = decode_BLINK(s)
    a = strsplit(s);
    SN = str2num(a{4});
    N = str2num(a{7});
    T_blink = str2num(a{9});
end



