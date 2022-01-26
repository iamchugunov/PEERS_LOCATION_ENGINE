function [tags] = peers_log_read_only_tags(filename)
    
    if nargin == 0
        [file, path] = uigetfile('*.*');
        filename = fullfile(path,file);  
    end

    f = fopen(filename);

    a = 0.9;
    time0 = 0;
    tags = [];
    
    visualization_mode = 1;
    
    if visualization_mode
        figure
        avatar_size = 0.7;
        set(gcf, 'Position', get(0, 'Screensize'));
        img = imread('map.png');
        % Flip the image upside down before showing it
%         imagesc([0 12.6], [0 12.6], flipud(img));
        imagesc([0 13], [0 6], flipud(img));
        set(gca,'ydir','normal');
        % NOTE: if your image is RGB, you should use flipdim(img, 1) instead of flipud.
 
        tail = 10;
 
        delay = 0.0001;
        grid on
        hold on
        daspect([1 1 1])
        axis([-2 14 -2 6])
        pause(delay)
    end
    
    while feof(f)==0 
        s=fgetl(f);
               
        if contains(s,"CLE: TAG")
           S = split(s);
           if 1 %str2num(S{5,1})
               time = str2num(S{1,1});
               if time0
                   fprintf('%f\n',time - time0)
               else
                   time0 = time; 
               end
               ID = S{4,1};
               x = str2num(S{6,1});
               y = str2num(S{7,1});
               z = str2num(S{8,1});
               N = str2num(S{9,1});
               toa = zeros(8,1);
               for m = 1:N
                   toa(str2num(S{10 + 2*(m - 1),1}),1) = str2num(S{11 + 2*(m - 1),1});
               end

               match_flag = 0;
               for i = 1:length(tags)
                   if strcmp(ID,tags(i).ID)
                       match_flag = 1;
                       break;
                   end
               end
               if match_flag == 1
                   tags(i).count = tags(i).count + 1;
                   tags(i).coords(:,tags(i).count) = [time;x;y;z];
                   tags(i).meas(:,tags(i).count) = toa;
                   
                   if std(tags(i).meas(1:4,end) - tags(i).meas(1:4,end-1)) < 1e-5 && x > 0 && y > 0 && x < 13 && y < 13 %&& norm(tags(i).pos(2:3,end) - [x;y]) < 1
                       
                       tags(i).fcount = tags(i).fcount + 1;
                       tags(i).pos(:,tags(i).fcount) = [time;x;y;z]; 
                       tags(i).pos(2,end) = a * tags(i).pos(2,end-1) + (1 - a) * tags(i).pos(2,end);
                       tags(i).pos(3,end) = a * tags(i).pos(3,end-1) + (1 - a) * tags(i).pos(3,end);
                       
                       if visualization_mode
                           if size(tags(i).pos,2) > tail %&& time - time0 > 3000
                               X = median(tags(i).pos(2,end-tail:end));
                               Y = median(tags(i).pos(3,end-tail:end));
                               set(tags(i).p,'XData',tags(i).pos(2,end-tail:end),'YData',tags(i).pos(3,end-tail:end));
                               set(tags(i).t,'Position',[tags(i).pos(2,end) tags(i).pos(3,end) 0] );
                               set(tags(i).img,'XData',[tags(i).pos(2,end) - avatar_size/2 tags(i).pos(2,end) + avatar_size/2], 'YData', [tags(i).pos(3,end) - avatar_size/2 tags(i).pos(3,end) + avatar_size/2])
                               title(num2str(time-time0))
                               pause(delay)
                           end
                       end
                       
                   end
               else
                   tag.ID = ID;
                   tag.count = 1;
                   tag.fcount = 1;
                   tag.coords = [time;x;y;z];
                   tag.pos = [time;x;y;z];
                   tag.meas = toa;
                   
                   if visualization_mode
                       tag.p = plot(tag.pos(2,1),tag.pos(3,1),'-','linewidth',2);
                       tag.t = text(tag.pos(2,1),tag.pos(3,1),tag.ID);
                       switch tag.ID
                           case '531c'
                               ph1 = 'photo/Таня.png';
                           case 'c8a9'
                               ph1 = 'photo/Саня.png';
                           case '552'
                               ph1 = 'photo/Наташа.png';
                           case 'c58a'
                               ph1 = 'photo/Никита.png';
                           case 'c50'
                               ph1 = 'photo/Варя.png';
                           otherwise
                               ph1 = 'photo/Никто.png';
                       end
                       img = imread(ph1);
                       tag.img = imagesc([tag.pos(2,1) - avatar_size/2 tag.pos(2,1) + avatar_size/2], [tag.pos(3,1) - avatar_size/2 tag.pos(3,1) + avatar_size/2], flipud(img));
                       set(gca,'ydir','normal');
                       pause(delay)
                   end
                   
                   if isempty(tags)
                       tags = tag;
                   else
                       tags(end+1) = tag;
                   end
               end
           end
        end

    end
    fclose(f);
end

