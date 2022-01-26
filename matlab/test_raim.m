k = 0;
for i = 1:length(tags(1).meas)
    nums = find(tags(1).meas(:,i));
    if length(nums) == 5
        k = k + 1;
        [X1{1}, dop, nev, flag] = coord_solver2D(tags(1).meas(nums,i)*299792458, SatPos(:,nums), [6.2;4.8;tags(1).meas(1,i)*299792458*0], 1);
        nevs(1,k) = nev;
        for j = 2:6
            nums1 = nums;
            nums1(j-1) = [];
            [X1{j}, dop, nev, flag] = coord_solver2D(tags(1).meas(nums1,i)*299792458, SatPos(:,nums1), [6.2;4.8;tags(1).meas(1,i)*299792458*0], 1);
            nevs(j,k) = nev;
        end
        [m, n] = min(nevs(:,k));
        X(:,k) = X1{n};
        NEV(k) = m;
        TOA(:,k) = tags(1).meas(nums,i);
    end
end

for i = 2:length(TOA)
    delta = TOA(:,i) - TOA(:,i-1);
    D(i) = std(delta);
end

