function map = mark_obj(map, features,keyframe,dists)
    for i = 1:length(features)
        xl = floor(keyframe(1,i) - features(i).xLoc);
        yl = floor(keyframe(2,i) - features(i).yLoc);
        yz = floor(keyframe(3,i) * features(i).ySize /2);
        xz = floor(keyframe(3,i) * features(i).xSize /2);
        %map = add_ellipse(map,0.02,xl,yl,xz,yz,0);
        map = add_ellipse(map,exp(-dists(i)^2 *5)/((keyframe(3,i)/2)^2*pi),xl,yl,xz,yz,0);
    end
end