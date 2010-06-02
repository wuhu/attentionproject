function show_descriptors(frames, color)
    hold on
    if color == 'r'
        scatter(frames(1,:), frames(2,:),'MarkerFaceColor', 'r');
    else
        for i = 1:length(frames(1,:))
            scatter(frames(1,i),frames(2,i),'MarkerEdgeColor','k', 'MarkerFaceColor',[max([1-color(i),0.1]), max([1-color(i),0.1]), max([1-color(i),0.1])]);
        end
    end
    hold off
end