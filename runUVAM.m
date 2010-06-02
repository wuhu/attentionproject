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
saliencyToolboxPath = '/home/hu/UNI/SIFT/SaliencyToolbox';
addpath(genpath(saliencyToolboxPath));

% get input image
img = imread(imagePath);

% get saliency map
salMap = getSalMap(img);
figure(1)
image(salMap)
colormap(gray(255))
salMap = salMap/max(salMap(:));
% SIFT image
imagedescs = sift(img);

% % get familiarity map
% famMap = getFFmap(imagedescs);
figure(2)
imshow(img)
[upper_octaves_frames upper_octaves_descs] = imagedescs.get_descriptors_scales(3,100);
[indices, dists, ~] = matchAgainstDB(upper_octaves_descs, 0.5);
show_descriptors(upper_octaves_frames(:,indices),dists);

% while (...)
    % % compute UVAM
    % if size(salMap) == size(famMap)
    %     uvam = salMap + famMap;
    % end

    % compute region of interest (ROI)
    for i= 1:5
        ROI = findROI(salMap, 100);
        hold on
        scatter(ROI(1),ROI(2),'MarkerFaceColor', 'k');
        hold off
        [lower_octaves_frames lower_octaves_descs] = imagedescs.get_descriptors(ROI, 0, 3);
        [indices, ~, ~] = matchAgainstDB(lower_octaves_descs, 0.3);
        show_descriptors(lower_octaves_frames(:,indices),'r');
        salMap(ROI(1):ROI(3),ROI(2):ROI(4)) = zeros(ROI(3)-ROI(1)+1,ROI(4)-ROI(2)+1);
    end
    % % compute descriptors for ROI and FB map
    % famMap = getFBmap(getDescriptors(ROI))

% end

% % display maps
% displayMap(img, salMap);
