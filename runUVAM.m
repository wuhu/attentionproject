% runUVAM(imageName)
%   Main method for running an object recognition algorithm based on 
%   Lee et. al (2010). Bottom-up saliency is combined with top-down 
%   familiarity information.
%
%   calls:
%       getSalMap() --> Saliency Toolbox modified module
%       getFFmap()  
%       findROI()
%       getFBmap()
     

function runUVAM(imagePath)  

close all
clc

% % set path for saliency toolboy
% saliencyToolboxPath = '/media/Hippocampus/CNS/SS 2010/NI Project/SaliencyToolbox';
% addpath(genpath(saliencyToolboxPath));

% get input image
img = imread(imagePath);

% get saliency map
salMap = getSalMap(img);

% % get familiarity map
% famMap = getFFmap(img);

% while (...)
    % % compute UVAM
    % if size(salMap) == size(famMap)
    %     uvam = salMap + famMap;
    % end

    % compute region of interest (ROI)
    ROI = findROI(salMap, 32)

    % % compute descriptors for ROI and FB map
    % famMap = getFBmap(getDescriptors(ROI))

% end

% % display maps
% displayMap(img, salMap);
