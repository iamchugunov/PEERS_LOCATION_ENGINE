tail = 30;
x = coords(1,1:tail);
y = coords(2,1:tail);
z = coords(3,1:tail);
tag = plot3(x,y,z,'k','linewidth',2)
hold on
grid on
view(3)
axis([0 4 0 4 0 2.5])
daspect([1 1 1])
pause(1)
for i = (tail+1):length(coords)
    x(1:end-1) = x(2:end);
    x(end) = coords(1,i);
    y(1:end-1) = y(2:end);
    y(end) = coords(2,i);
    z(1:end-1) = z(2:end);
    z(end) = coords(3,i);
    set(tag,'XData',x,'YData',y,'ZData',z)
    pause(T(i)-T(i-1))
end
    