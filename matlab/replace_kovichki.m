function [out] = replace_kovichki(s)
    while strfind(s,"b'\")
    a = strfind(s,"b'\");
    nums0 = [];
    numsi = strfind(s,"'");
    b = find(numsi >= a(1));
    s_end = numsi(b(2));
    name = s(a(1):s_end);
    name = [name(9:10) name(5:6)];
    s = replace(s, s(a(1):s_end), "'aaaa'");
    a = strfind(s,'aaaa');
    s(a(1):a(1)+3) = name;
    end
%     s(nums0) = [];
%     nums0 = [];
    nums = strfind(s,"'");
%     for i = 1:length(nums)
%         nums1 = strfind(s(1:nums(i)),"'");
%         nums0 = [nums0 nums1(end-1) nums1(end)];
%     end
%     s(nums0) = '"';
    s(nums) = '"';
    out = s;
end

