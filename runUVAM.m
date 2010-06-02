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
[indices, dists, features] = matchAgainstDB(upper_octaves_descs, 0.5);
foundobjs = [];
foundobj = show_descriptors(upper_octaves_frames(:,indices),features, dists,'k');
foundobjs(end+1:end+length(foundobj)) = foundobj;
% while (...)
    % % compute UVAM
    % if size(salMap) == size(famMap)
    %     uvam = salMap + famMap;
    % end

    % compute region of interest (ROI)
    maxi = 1;
    
    while(maxi >= 0.1)
        [ROI maxi] = findROI(salMap, 16);
        size(salMap)
        size(img)
        hold
        rectangle('Position',[ROI(2),ROI(1),ROI(4)-ROI(2)+1,ROI(3)-ROI(1)+1]);
        hold off
        [lower_octaves_frames lower_octaves_descs] = imagedescs.get_descriptors(ROI, 0, 3);
        [indices, dists, features] = matchAgainstDB(lower_octaves_descs, 0.3);
        foundobj = show_descriptors(lower_octaves_frames(:,indices),features,dists,'r');
        foundobjs(end+1:end+length(foundobj)) = foundobj;
        salMap(ROI(1):ROI(3),ROI(2):ROI(4)) = zeros(ROI(3)-ROI(1)+1,ROI(4)-ROI(2)+1);
    end
    done = [];
    for obj = foundobjs
        if(isempty(find(done == obj, 1)))
           figure
           imshow(['../coil-100/obj' num2str(obj) '__0.png'])
           title(['object nr. ' num2str(obj)])
        end
        done(end+1) = obj;
    end
    % % compute descriptors for ROI and FB map
    % famMap = getFBmap(getDescriptors(ROI))

% end

% % display maps
% displayMap(img, salMap);
