% estimate the position, size and orientation of an object, given a
% keypoint
function objects = estimate_objects(features, keyframes, dists)
    objects = struct([]);
    for i = 1:length(features)
        relscale =  keyframes(3,i) / features(i).scale;
        objects(i).ySize = floor(keyframes(3,i) * features(i).ySize /2);
        objects(i).xSize = floor(keyframes(3,i) * features(i).xSize /2);
        xy = keyframes([1,2],i) - features(i).loc * relscale;
        objects(i).loc = floor(rot2d(xy',keyframes([1,2],i)',-rad2deg(features(i).orientation-keyframes(4,i))));
        objects(i).label = features(i).object; 
        objects(i).or = features(i).orientation-keyframes(4,i);
        objects(i).dist = dists(i);
    end
end
