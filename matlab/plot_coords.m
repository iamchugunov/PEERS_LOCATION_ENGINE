function [  ] = plot_coords( in )

    figure
    hold on
    for i = 1:length(in)
        plot(in(i).coord(1,:),in(i).coord(2,:),'.')
    end
    grid on
    


end

