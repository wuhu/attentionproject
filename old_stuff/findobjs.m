function [found_objects] = findobjs(objs)
    %% Updates the Feed-Back Familiarity Map given in FBfmap with respect to
    %% keypoints given in objects
    Qth = 0.75; 
    found_objects =[];

    % cluster data
    ida = qtcluster(objs,Qth);
    idx = sort(ida);

    % compute size of clusters and update familiarity map accordingly
    cluster = zeros(1,2);
    
    for i = 1:length(idx)
        if idx(i) == cluster(1) && i ~= length(idx)
            cluster(2) = cluster(2) + 1;
        else
            if cluster(2) > 2
               % update the FBfmap with an -2, since the object has been
               % found
               found_objects = cat(2,found_objects,objs(ida == cluster(1)));
            end
            cluster = [idx(i), 1];
        end
    end
end


