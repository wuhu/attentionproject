function load_db
    load descriptors_best
    load descr_features_best
    load desctree

    % [index, params] = makeflann(1:length(descriptors));
    % global flann_index
    % global flann_parameters
    
    global descriptor_features
    global descriptors1
    global desc_tree
     
    % flann_index = index;
    % flann_parameters = params;

    descriptors1 = descriptors;
    descriptor_features = features;
    desc_tree = desctree;
end