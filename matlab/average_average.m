function [ data ] = average_average( OUT, nums )
    data = [];
    for i = 1:length(nums)
        data = [data OUT(nums(i)).data];
    end

end

