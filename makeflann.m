function [index, parameters] = makeflann(range)
    load descriptors

    build_params.target_precision = 0.9;

    [index,parameters] = flann_build_index(single(descriptors(:,range)), build_params);

    % suchen: [vector, distance] = flann_search(index,single(testset),k,parameters)
    % am ende: flann_free_index(index)
end