function show_descriptors(frames, dist, edgec, FIND_DIST)
    hold on
    for i = 1:length(frames(1,:))
        if dist(i) < FIND_DIST
            scatter(frames(1,i), frames(2,i),'MarkerEdgeColor', edgec, 'MarkerFaceColor', 'r');
        else
            scatter(frames(1,i),frames(2,i),'MarkerEdgeColor', edgec, 'MarkerFaceColor',[max([1-color(i),0.1]), max([1-color(i),0.1]), max([1-color(i),0.1])]);
        end
    end
    hold off    
end
    
