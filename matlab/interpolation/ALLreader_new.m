function [anchors, tags, cs_packets] = ALLreader_new(filename)

if nargin == 0
    [file, path] = uigetfile('*.*');
    filename = fullfile(path,file);  
end

    f = fopen(filename);

    anchors = [];
    tags = [];
    cs_packets = zeros(8,1);
    
    current_seq = 1000;
    
    while feof(f)==0 
        s=fgetl(f);
        
        if contains(s,"New Anchor")
           S = split(s);
           N = str2num(S{4,1});
           anchors(N + 1).ID = S{5,1};
           anchors(N + 1).pos = [str2num(S{6,1}); str2num(S{7,1}); str2num(S{8,1})];
           anchors(N + 1).master = str2num(S{10,1});
           anchors(N + 1).counter = 0;
           anchors(N + 1).rx_tx = zeros(8,1);
           anchors(N + 1).filtred_CS = [];
           anchors(N + 1).MasterID = [];
        end
        
    
        
        if contains(s,"CS_TX")
           flag_lost_seq = 1;
           S = split(s);
           if str2num(S{5,1}) ~= current_seq
              if current_seq == 255
                  current_seq = -1;
              end
              if (str2num(S{5,1}) - current_seq) == 1 || current_seq == 1000  
                current_seq = str2num(S{5,1});
                for i = 1:length(anchors)
                    anchors(i).counter = anchors(i).counter + 1;
                end
              else
                  flag_lost_seq = 0;
              end
           end
          if flag_lost_seq
           ID = S{3,1};
           for i = 1:length(anchors)
               if strcmp(anchors(i).ID,ID)
                   break;
               end
           end
           anchors(i).rx_tx(:,anchors(i).counter) = [str2num(S{1,1}); str2num(S{5,1}); str2num(S{6,1}); 0; 0; 0; 0; 0];
           cs_packets(1,anchors(i).counter) = str2num(S{6,1});
          end
        end
        
        if contains(s,"CS_RX")
            flag_lost_seq = 1;
           S = split(s);
           if str2num(S{5,1}) ~= current_seq
              if current_seq == 255
                  current_seq = -1;
              end
              if (str2num(S{5,1}) - current_seq) == 1 || current_seq == 1000  
                current_seq = str2num(S{5,1});
                for i = 1:length(anchors)
                    anchors(i).counter = anchors(i).counter + 1;
                end
              else
                  flag_lost_seq = 0;
              end
           end
              if flag_lost_seq
           ID = S{3,1};
           for i = 1:length(anchors)
               if strcmp(anchors(i).ID,ID)
                   break;
               end
           end
           anchors(i).MasterID = S{4,1};
           anchors(i).rx_tx(:,anchors(i).counter) = [str2num(S{1,1}); str2num(S{5,1}); 0; str2num(S{6,1}); 0; 0; 0; 0];
           cs_packets(i,anchors(i).counter) = str2num(S{6,1});
              end
        end
        
        if contains(s,"CLE: CSS") && ~contains(s,"sync lost")
           S = split(s);
           ID = S{6,1};
           for i = 1:length(anchors)
               if strcmp(anchors(i).ID,ID)
                   break;
               end
           end
           for master = 1:length(anchors)
               if strcmp(anchors(master).ID,anchors(i).MasterID)
                   break;
               end
           end
           anchors(i).rx_tx(3,anchors(i).counter) = anchors(master).rx_tx(3,anchors(i).counter);
           anchors(i).rx_tx(5,anchors(i).counter) = str2num(S{7,1});
           anchors(i).rx_tx(6,anchors(i).counter) = str2num(S{8,1}) * str2num(S{4,1});
           anchors(i).rx_tx(7,anchors(i).counter) = str2num(S{9,1}) * str2num(S{4,1});
           anchors(i).rx_tx(8,anchors(i).counter) = str2num(S{10,1});
        end
        
        if contains(s,"BLINK")
           S = split(s);
           ID = S{4,1};
           match_flag = 0;
           for i = 1:length(tags)
               if strcmp(tags(i).ID,ID)
                   match_flag = 1;
                   break
               end
           end
           if match_flag == 0
               i = length(tags) + 1;
               tags(i).ID = ID;
               tags(i).SN = 1000;
               tags(i).counter = 0;
               tags(i).meas = zeros(8,1);
               tags(i).corrected_meas = zeros(8,1);
               tags(i).coords = zeros(4,1);
               tags(i).sn = 1;
           end
           
           if tags(i).SN ~= str2num(S{5,1})
               delta = str2num(S{5,1}) - tags(i).SN;
               if delta < -240
                   delta = delta + 255;
               end
               if delta > 0 || tags(i).SN == 1000
                    tags(i).SN = str2num(S{5,1});
                    tags(i).counter = tags(i).counter + 1;
               end
           end
           
           anchorID = S{3,1};
           for j = 1:length(anchors)
               if strcmp(anchors(j).ID,anchorID)
                   break;
               end
           end
           tags(i).meas(j,tags(i).counter) = str2num(S{6,1});
           tags(i).sn(1,tags(i).counter) = str2num(S{5,1});
% tags(i).meas(j,tags(i).counter) = str2num(S{1,1});
        end
        
        if contains(s,"CLE: TAG")
           S = split(s);
           ID = S{4,1};
%            if str2num(S{5,1})
            if 1
               for i = 1:length(tags)
                    if strcmp(tags(i).ID,ID)
                        break
                    end
               end
               tags(i).coords(:,tags(i).counter) = [str2num(S{1,1}); str2num(S{6,1}); str2num(S{7,1}); str2num(S{8,1})];
               N = str2num(S{9,1});
               for m = 1:N
                   tags(i).corrected_meas(str2num(S{10 + 2*(m - 1),1}) + 1,tags(i).counter) = str2num(S{11 + 2*(m - 1),1});
               end
           end
        end
              

                

    end
    fclose(f);
end






