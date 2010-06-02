function show_descriptors(siftobj, key_indices)
    hold on
    frames = siftobj.frames(:,key_indices);
    scatter(frames(1,:),frames(2,:),'MarkerFaceColor','k');
    hold off
end