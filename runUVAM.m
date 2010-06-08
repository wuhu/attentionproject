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

init

% set relevant parameters
ERROR_UPPER_OCT = 0.5;  % threshold for detecting keypoint in upper octaves
ERROR_LOWER_OCT = 0.25; % threshold for detecting keypoint in lower octaves
ROI_SCALES      = 3;    % scales used within ROIs go from 0 to ROI_SCALES
ROI_SIZE        = 32;   % size of a ROI in pixels
MAXI_LIM        = 0.1;  % threshold of stopping for looking for next ROI
FIND_DIST       = 0.1;  % if matching distance is <= FIND_DIST, object is marked as found

% set path for saliency toolboy
saliencyToolboxPath = '/home/hu/UNI/SIFT/SaliencyToolbox';
addpath(genpath(saliencyToolboxPath));

% get input image
img = imread(imagePath);
imgr = zeros(size(img,1),size(img,2)); % im2double(rgb2gray(img));

% get and display saliency map
salMap = getSalMap(img);
figure(1)
image(salMap)
colormap(gray(255))
salMap = salMap/max(salMap(:));

% SIFT image / get image descriptors
imagedescs = sift(img);

% get familiarity map
% famMap = getFFmap(imagedescs);

figure(2)
imshow(img)
[upper_octaves_frames upper_octaves_descs] = imagedescs.get_descriptors_scales(ROI_SCALES+1, 100);
[indices, dists, features] = matchAgainstDB(upper_octaves_descs, ERROR_UPPER_OCT);
foundobjs = [];
foundobj = show_descriptors(upper_octaves_frames(:,indices),features, dists,'k', FIND_DIST);
foundobjs(end+1:end+length(foundobj)) = foundobj;
ffap = mark_obj(imgr,features,upper_octaves_frames(:,indices),dists);

% while (...)
    % % compute UVAM
    % if size(salMap) == size(famMap)
    %     uvam = salMap + famMap;
    % end

    % compute region of interest (ROI)
    maxi = 1;
    count = 0;
    while(maxi >= MAXI_LIM)
        count = count + 1;
        [ROI maxi] = findROI(salMap, ROI_SIZE);
        figure(2)
        hold on
        rectangle('Position',[ROI(2),ROI(1),ROI(4)-ROI(2)+1,ROI(3)-ROI(1)+1]);
        hold off
        [lower_octaves_frames lower_octaves_descs] = imagedescs.get_descriptors(ROI, 0, ROI_SCALES);
        [indices, dists, features] = matchAgainstDB(lower_octaves_descs, ERROR_LOWER_OCT);
        foundobj = show_descriptors(lower_octaves_frames(:,indices),features,dists,'r', FIND_DIST);
        foundobjs(end+1:end+length(foundobj)) = foundobj;
        figure(3)
        hold on
        gazeSequence(img, ROI, count);
        hold off
        %ffap = mark_obj(ffap,features,lower_octaves_frames(:,indices),dists);
        salMap(ROI(1):ROI(3),ROI(2):ROI(4)) = zeros(ROI(3)-ROI(1)+1,ROI(4)-ROI(2)+1);
    end
    done = [];
    for obj = foundobjs
        if(isempty(find(done == obj, 1)))
           figure
           imshow(['../coil-100/obj' num2str(obj) '__0.png'])
           title(['Object No. ' num2str(obj)])
        end
        done(end+1) = obj;
    end
    figure
    imshow(ffap);
    
    
    % % compute descriptors for ROI and FB map
    % famMap = getFBmap(getDescriptors(ROI))

 end

% % display maps
% displayMap(img, salMap);
