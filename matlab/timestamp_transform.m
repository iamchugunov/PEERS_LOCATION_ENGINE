function [timestamp_sec] = timestamp_transform(timestamp_ttk)

timestamp_char = num2str(timestamp_ttk);

timestamp_seconds = str2double(timestamp_char(end-1:end));
timestamp_minutes = str2double(timestamp_char(end-3:end-2));
timestamp_hours = str2double(timestamp_char(end-5:end-4));

timestamp_sec = timestamp_hours * 3600 + timestamp_minutes * 60 + timestamp_seconds;
end

