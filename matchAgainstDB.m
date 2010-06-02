% function [descriptor_indices, errors, desc_features] = matchAgainstDB(query_descriptors, matching_error)
%     global flann_index    
%     global flann_parameters
%     global descriptor_features
%     
%     % ANN search of descriptors in database
%     [results, distances] = flann_search(flann_index, single(query_descriptors), 1, flann_parameters);
%     
%     passed = distances >= matching_error; % find out which descriptor is below the required matching error
%     
%     results = results(passed);
%     nums = 1:length(query_descriptors); 
%     descriptor_indices = nums(passed); % the query descriptors that have passed
%     errors = distances(passed); % the corresponding errors
%     desc_features = descriptor_features(results); % features (size, orientation,.. relative to the object and object nr.)
% end

function [descriptor_indices, errors, desc_features] = matchAgainstDB(query_descriptors, matching_error)
    global descriptors1
    global descriptor_features
    
    d = descriptors1';
    
    % ANN search of descriptors in database
    [results, distances] = kNearestNeighbors(d,query_descriptors',1);
    results = results';
    distances = distances';
    passed = distances <= matching_error; % find out which descriptor is below the required matching error
    
    results = results(passed);
    nums = 1:length(query_descriptors); 
    descriptor_indices = nums(passed); % the query descriptors that have passed
    errors = distances(passed); % the corresponding errors
    desc_features = descriptor_features(results); % features (size, orientation,.. relative to the object and object nr.)
end