figure
figure
        img = imread('map.png');
        % Flip the image upside down before showing it
        imagesc([0 12.6], [0 12.6], flipud(img));
        set(gca,'ydir','normal');
grid on
hold on
daspect([1 1 1])
axis([0 13 0 13])
for i = 1:length(tags)
    plot(tags(i).pos(2,:),tags(i).pos(3,:),'.')
end
legend

figure
subplot(121)
grid on
hold on
ylim([0 13])
for i = 1:length(tags)
    plot(tags(i).pos(1,:),tags(i).pos(2,:),'-')
end
subplot(122)
grid on
hold on
ylim([0 13])
for i = 1:length(tags)
    plot(tags(i).pos(1,:),tags(i).pos(3,:),'-')
end