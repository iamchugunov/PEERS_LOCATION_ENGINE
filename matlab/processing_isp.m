Folder = uigetdir;
folders = dir(Folder);
out.data = [];
out.mean = [];
out.std = [];
out.p1m = [];
out.r95 = [];
globaldata = [];
k = 0;
figure(1)
hold on
grid on
for i = 3:22
    [ d ] = process_one_folder( fullfile(Folder,folders(i).name) );
    for i = 1:1
        k = k + 1;
        out(k) = d(i);
        globaldata = [globaldata d(i).data];
    end
end
figure(2)
histogram(globaldata,1000)
