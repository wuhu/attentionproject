function map = getFFfmap(objects,res,sigma_k,ratio)
    map = zeros(res);
    for object = objects
        famValue = exp(-object.dist/(2 * sigma_k^2)); % (dists are already squared)
        map = add_ellipse(map,famValue,ceil(object.loc(1)/ratio(2)),ceil(object.loc(2)/ratio(1)),ceil((object.xSize/3)/ratio(2)),ceil((object.ySize/3)/ratio(1)),0);
        %map = add_gauss(map,famValue,ceil(object.loc(1)/ratio(2)),ceil(object.loc(2)/ratio(1)),ceil((object.ySize)/ratio(1)));
    end
   % map = map./max(map(:));
end