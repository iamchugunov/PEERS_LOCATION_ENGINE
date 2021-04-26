clear all
close all
clc

[file, path] = uigetfile('D:\TTK1000_EVAL_RELEASE_1.2\RTLS\TTK1000_EVAL_RELEASE_1.2\Software\TTK1000_Release_1.1\Logs\*.*');
fid = fopen([path file]);
% fid = fopen('D:\MATLAB Scripts\TTK Processing\logs\20200828-101012.log');
%{
ID_set = ['deca0100d48200b4';
          'deca0100d481cc12';
          'deca0100d450c8a9'];
%}
    ID_set = ['beef010050b3c216';
              'beef010010b44a28';
              'beef010050b44b86';
              'beef010010b44a14';
              'beef010050b4451b';
              'beef010010b3c28e';
              'dead010010b44811';
              'dead010010b44980';
              'dead010050b44907';
              'dead010010b44426'];
Seq_Log = cell(1,size(ID_set,1));
k = 1;
while feof(fid) ~= 1
data = fgetl(fid);
[stamp_log(k,1) ID_log(k,1)] = decode_ttk_blink(data, ID_set);

[SeqNum, Tag_ID] = decode_ttk_blink_2(data, ID_set);
if length(Tag_ID) == 1
if ~isempty(Seq_Log{Tag_ID})
    if Seq_Log{Tag_ID}(end,1) ~= SeqNum
        Seq_Log{Tag_ID}(end + 1,1) = SeqNum;
    end
else
   Seq_Log{Tag_ID} = [Seq_Log{Tag_ID}; SeqNum]; 
end
end
k = k + 1;
end

fclose(fid);

nonzero_ind = find(stamp_log(:,1));
stamp_log = stamp_log(nonzero_ind,1);
ID_log = ID_log(nonzero_ind,1);

stamp_log_top(1,1) = stamp_log(1,1);
stamp_log_sec_top(1,1) = timestamp_transform(stamp_log_top(1,1));
ID_log_top(1,1) = ID_log(1,1);
prev_stamp = stamp_log(1,1);
q = 2;
for k = 2 : size(stamp_log,1)
    if stamp_log(k,1) ~= prev_stamp
    stamp_log_top(q,1) = stamp_log(k,1);
    stamp_log_sec_top(q,1) = timestamp_transform(stamp_log_top(q,1));
    ID_log_top(q,1) = ID_log(k,1);
    q = q + 1;
    end
    prev_stamp = stamp_log(k,1);
end

IDs_found = unique(ID_log_top);
Tag_log = cell(length(ID_log_top),1);

for m = 1 : length(ID_log_top)
for p = 1:length(IDs_found)
    if ID_log_top(m) == IDs_found(p)
        Tag_log{p,1} = [Tag_log{p,1}; ID_log_top(m) stamp_log_sec_top(m)];
    end
end
end

%{
figure(1)
plot(stamp_log_top,'o')
figure(2)
plot(ID_log_top,'o')
figure(3)
plot(stamp_log_sec_top,'o')
%}

% figure
% plot(Tag_log{1,1}(:,2))
% hold on
% plot(Tag_log{2,1}(:,2))
% plot(Tag_log{3,1}(:,2))
% grid on

T =  (stamp_log_sec_top(end)-stamp_log_sec_top(1));
for i = 1:length(Seq_Log)
    a(i,1) = T;
    a(i,2) = length(Seq_Log{1,i});
    a(i,3) = T/length(Seq_Log{1,i});
    a(i,4) = 100*(a(i,3)/0.1 - 1);
end
a

