function map = mark_obj(map, features,keyframe,dists)
    for i = 1:length(features)
        relscale =  keyframe(3,i) / features(i).scale;
        yz = floor(keyframe(3,i) * features(i).ySize /2);
        xz = floor(keyframe(3,i) * features(i).xSize /2);
        xy = keyframe([1,2],i) - features(i).loc * relscale;
        xyl = floor(rot2d(xy',keyframe([1,2],i)',-rad2deg(features(i).orientation-keyframe(4,i))));
        map = add_ellipse(map,exp(-dists(i)^2 *5)/((keyframe(3,i)/2)^2*pi),xyl(1),xyl(2),xz,yz,0);
    end
end