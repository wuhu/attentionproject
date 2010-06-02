function init
    load descriptors
    load descr_features

    % [index, params] = makeflann(1:length(descriptors));
    % global flann_index
    % global flann_parameters
    global descriptor_features
    global descriptors1
     % 
    % flann_index = index;
    % flann_parameters = params;

    descriptors1 = descriptors;
    descriptor_features = features;
end