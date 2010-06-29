function show_descriptors(frames, dist, edgec)
    hold on
    for i = 1:length(frames(1,:))
       scatter(frames(1,i),frames(2,i),'MarkerEdgeColor', edgec, 'MarkerFaceColor',[max([1-color(i),0.1]), max([1-color(i),0.1]), max([1-color(i),0.1])]);
    end
    hold off    
end
    
