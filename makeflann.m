load descrs

build_params.target_precision = 0.9;

[index,parameters] = flann_build_index(single(descriptors), build_params);

% suchen: [vector, distance] = flann_search(index,single(testset),k,parameters)
% am ende: flann_free_index(index)