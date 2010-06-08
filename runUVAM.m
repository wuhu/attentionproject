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

figure(1); clf;
set(gcf,'DefaultAxesTickLength',[0.005 0.01]);
set(gcf,'DefaultAxesTickDir','out')
set(gcf,'DefaultAxesbox','off')
set(gcf,'DefaultAxesLayer','top')
set(gcf,'DefaultAxesFontSize',10)
xSize = 30;
ySize = 25;
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'PaperUnits','centimeters','PaperPosition',[xLeft yTop xSize ySize],'Position',[1000-xSize*30 700-ySize*30 xSize*40 ySize*40])

hImage = axes('position',[0.05 0.05 0.6 0.8]);
hSaliency = axes('position',[0.7 0.05 0.25 0.425]);
hFamiliarity = axes('position',[0.7 0.55 0.25 0.425]);
%hUA = axes('position',[l2 b2 w h2]);

% set relevant parameters
ERROR_UPPER_OCT = 0.3;  % threshold for detecting keypoint in upper octaves
ERROR_LOWER_OCT = 0.2; % threshold for detecting keypoint in lower octaves
ROI_SCALES      = 3;    % scales used within ROIs go from 0 to ROI_SCALES
ROI_SIZE        = 32;   % size of a ROI in pixels
MAXI_LIM        = 0.1;  % threshold of stopping for looking for next ROI
FIND_DIST       = 0.05;  % if matching distance is <= FIND_DIST, object is marked as found

% set path for saliency toolboy
saliencyToolboxPath = '/home/hu/UNI/SIFT/SaliencyToolbox';
addpath(genpath(saliencyToolboxPath));

% get input image
img = imread(imagePath);
imgr = zeros(size(img,1),size(img,2)); % im2double(rgb2gray(img));

% get and display saliency map
time = cputime;
salMap = getSalMap(img);
salTime = cputime - time
set(gcf,'CurrentAxes',hSaliency);
image(salMap)
colormap(gray(255))
salMap = salMap/max(salMap(:));

% SIFT image / get image descriptors
time = cputime;
imagedescs = sift(img);
siftTime = cputime - time
% get familiarity map
% famMap = getFFmap(imagedescs);

set(gcf,'CurrentAxes',hImage);
imshow(img)
[upper_octaves_frames upper_octaves_descs] = imagedescs.get_descriptors_scales(ROI_SCALES+1, 100);
time = cputime;
[indices, dists, features] = matchAgainstDB(upper_octaves_descs, ERROR_UPPER_OCT);
FFtime = cputime - time
passed_keypoints = upper_octaves_frames(:,indices);
show_descriptors(passed_keypoints, dists,'k', FIND_DIST);
objects = estimate_objects(features,passed_keypoints, dists);
ffmap = mark_obj(imgr,objects,FIND_DIST);

UAmap = ffmap + salMap;

% while (...)
    % % compute UVAM
    % if size(salMap) == size(famMap)
    %     uvam = salMap + famMap;
    % end

    % compute region of interest (ROI)
    maxi = 1;
    count = 0;
    time = cputime;
    while(maxi >= MAXI_LIM)
        count = count + 1;
        [ROI maxi] = findROI(salMap, ROI_SIZE);
        set(gcf,'CurrentAxes',hImage);
        hold on
        rectangle('Position',[ROI(2),ROI(1),ROI(4)-ROI(2)+1,ROI(3)-ROI(1)+1]);
        hold off
        [lower_octaves_frames lower_octaves_descs] = imagedescs.get_descriptors(ROI, 0, ROI_SCALES);
        [indices, dists, features] = matchAgainstDB(lower_octaves_descs, ERROR_LOWER_OCT);
        passed_keypoints = lower_octaves_frames(:,indices);
        show_descriptors(passed_keypoints,dists,'r', FIND_DIST);
        new_objects = estimate_objects(features,passed_keypoints, dists);
        if(~isempty(new_objects))
            objects(end+1:end+length(new_objects)) = new_objects;
        end
%         figure(3)
%         hold on
%         gazeSequence(img, ROI, count);
%         hold off
        UAmap = mark_obj(UAmap,new_objects,FIND_DIST);
        salMap(ROI(1):ROI(3),ROI(2):ROI(4)) = ones(ROI(3)-ROI(1)+1,ROI(4)-ROI(2)+1) * -2;
        figure(1)
        set(gcf,'CurrentAxes',hFamiliarity);
        imagesc(UAmap);
    end
    FBtime = cputime - time
    figure(1)
    i = 0;
    found_objects = objects([objects.dist] < FIND_DIST);
    [~, m, ~] = unique([found_objects.label]);
    found_objects = found_objects(m);
    for obj = found_objects
       axes('position',[0.05+0.1*i 0.9 0.05 0.05]);
       imshow(['../coil-100/obj' num2str(obj.label) '__0.png'])
       title(['Object No. ' num2str(obj.label)])
       annotation('arrow',[0.075+0.1*i, 0.05 + 0.6*min(1,max(0,obj.loc(1)/size(img,2)))], [0.9, min(1,max(0,0.85-0.8*obj.loc(2)/size(img,1)))])
       annotation('ellipse',[min(1,max(0,0.6*obj.loc(1)/size(img,2))), min(1,max(0,0.85-0.8*obj.loc(2)/size(img,1)-0.8*obj.ySize/size(img,1))), 2*0.6*obj.xSize/size(img,2), 2*0.8*obj.ySize/size(img,1)],'EdgeColor','y','LineWidth',1)
       i = i+1;
    end
    
    
    % % compute descriptors for ROI and FB map
    % famMap = getFBmap(getDescriptors(ROI))

 end

% % display maps
% displayMap(img, salMap);
