function [rd] = get_non_zeros_toa_from_log(tags)
    meas = tags.meas;
    k = 0;
    for i = 1:length(meas)
        if meas(1,i) ~= 0 && meas(2,i) ~= 0
           k = k + 1;
           rd(k) = meas(2,i) - meas(1,i);
        end
    end
end

