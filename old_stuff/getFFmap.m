function FFfmap = getFFmap(objects, res) % resolution missing
%% Calculates the Feed-Forward Familiarity Map for keypoints given in objects 

% Initialize the Familiarity Map
FFfmap = zeros(res);

sigma_k = 0.25;

% Process every Keypoint given in objects 
for i = 1:size(objects, 1)
    
    % calculate the keypoint familiarity
    famValue = exp(-objects(i).dist/(2 * sigma_k^2)); % (dists are already squared)
    

    % add the familiarity value to the pixels within predetermined objects
    % pose
    FFfmap = add_ellipse(FFfmap, famValue, objects(i).loc(1), objects(i).loc(2), objects(i).xSize, objects(i).ySize, 0);
end


    
