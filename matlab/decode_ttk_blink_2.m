function [SeqNum, Tag_ID] = decode_ttk_blink_2(curr_str, ID_set)

blink_flag = 'BLINK ';
if contains(curr_str,blink_flag)
    SeqNum = str2double(curr_str(37:39));
    for k = 1:size(ID_set,1)
        if contains(curr_str,ID_set(k,:))
            Tag_ID = k;
        end
    end 
    
else
    SeqNum = 'No BLINK';
    Tag_ID = 'No BLINK';
end


