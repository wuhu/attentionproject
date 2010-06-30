function [FBfmap, found_objects] = getFBfmap(FBfmap, objects, ratio)
    %% Updates the Feed-Back Familiarity Map given in FBfmap with respect to
    %% keypoints given in objects
    Qth = 0.2; 
    found_objects =[];
    while ~isempty(objects)
        % Quality threshold
        

        sigma_c = 0.1;
        
        current_o = [objects.label] == objects(1).label;
        
        if sum(current_o) > 1
            % cluster data
            objs = objects(current_o);
            ida = qtcluster(objs,Qth);
            idx = sort(ida);

            % compute size of clusters and update familiarity map accordingly
            cluster = zeros(1,2);
            
            for i = 1:length(idx)
                if idx(i) == cluster(1) && i ~= length(idx)
                    cluster(2) = cluster(2) + 1;
                else
                    o = find(ida == cluster(1),1);
                    if cluster(2) > 2
                       % update the FBfmap with an -2, since the object has been found
                       FBfmap = add_ellipse_abs(FBfmap, -2, ceil(objs(o).loc(1)/ratio(2)), ceil(objs(o).loc(2)/ratio(1)), ceil((objs(o).xSize)/ratio(2)), ceil((objs(o).ySize)/ratio(1)), 0);
                       found_objects = cat(1,found_objects,objs(o));
                    elseif cluster(2) == 2
                       % update the FBfmap with cluster Familiarity Value
                       oo = objs(ida == cluster(1));
                       dist = exp(-delta_dist(oo(1),oo(2))/(2 * sigma_c^2));
                       %FBfmap = add_gauss(FBfmap, dist, ceil(objs(o).loc(1)/ratio(2)), ceil(objs(o).loc(2)/ratio(1)), ceil((objs(o).xSize/3)/ratio(2)), ceil((objs(o).ySize/3)/ratio(1)), 0);
                       FBfmap = add_gauss(FBfmap, dist, ceil(objs(o).loc(1)/ratio(2)), ceil(objs(o).loc(2)/ratio(1)), ceil((objs(o).xSize/3)/ratio(2)));

                    end
                    cluster = [idx(i), 1];
                end
            end
        end
        
        objects(current_o) = [];
    end
end


