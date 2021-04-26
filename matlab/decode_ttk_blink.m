function [timestamp, Tag_ID] = decode_ttk_blink(curr_str, ID_set)

blink_flag = 'BLINK ';
if contains(curr_str,blink_flag)
    timestamp = str2double(curr_str(2:9));
    for k = 1:size(ID_set,1)
        if contains(curr_str,ID_set(k,:))
            Tag_ID = k;
        end
    end 
    
else
    timestamp = 0;
    Tag_ID = 0;
end



end

