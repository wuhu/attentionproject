function foundobj = show_descriptors(frames, features, color, edgec)
    hold on
    foundobj = [];
    if color == 'r'
        scatter(frames(1,:), frames(2,:),'MarkerFaceColor', 'b');
    else
        for i = 1:length(frames(1,:))
            if color(i) < 0.1
                scatter(frames(1,i), frames(2,i),'MarkerEdgeColor', edgec, 'MarkerFaceColor', 'r');
                foundobj(end+1) = features(i).object;
            else
                scatter(frames(1,i),frames(2,i),'MarkerEdgeColor', edgec, 'MarkerFaceColor',[max([1-color(i),0.1]), max([1-color(i),0.1]), max([1-color(i),0.1])]);
            end
        end
        
    end
    hold off
end