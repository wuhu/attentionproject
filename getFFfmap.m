function map = getFFfmap(objects,res)
    sigma_k = 0.25;
    map = zeros(res);
    for object = objects
        famValue = exp(-object.dist/(2 * sigma_k^2)); % (dists are already squared)
        map = add_ellipse(map,famValue,object.loc(1),object.loc(2),object.xSize,object.ySize,0);
    end
   % map = map./max(map(:));
end