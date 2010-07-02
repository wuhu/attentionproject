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

    % set relevant parameters

    ERROR_UPPER_OCT = 2;  % threshold for detecting keypoint in upper octaves
    ERROR_LOWER_OCT = 2; % threshold for detecting keypoint in lower octaves
    ROI_SCALES      = 3;    % scales used within ROIs go from 0 to ROI_SCALES
    ROI_SIZE        = 32;   % size of a ROI in pixels
    MAXI_LIM        = 0.2;  % threshold of stopping for looking for next ROI
    FIND_DIST       = 0.05;  % if matching distance is <= FIND_DIST, object is marked as found
    MAP_SIZE        = [100,100];
    

    close all
    clc

    init % load object database
    %run('vlfeat/toolbox/vl_setup.m'); % init vlfeat

    % setup figure
    figure(1); clf;
    set(gcf,'DefaultAxesTickLength',[0.005 0.01]);
    set(gcf,'DefaultAxesTickDir','out')
    set(gcf,'DefaultAxesbox','off')
    set(gcf,'DefaultAxesLayer','top')
    set(gcf,'DefaultAxesFontSize',10)
    xSize = 25;
    ySize = 15;
    xLeft = (21-xSize)/2;
    yTop = (30-ySize)/2;
    set(gcf,'PaperUnits','centimeters','PaperPosition',[xLeft yTop xSize ySize],'Position',[1000-xSize*30 700-ySize*30 xSize*40 ySize*40])

    hImage = axes('position',[0.05 0.05 0.6 0.8]);
    hSaliency = axes('position',[0.7 0.05 0.25 0.425]);
    hFamiliarity = axes('position',[0.7 0.55 0.25 0.425]);

    % set path for saliency toolboy
    saliencyToolboxPath = '/home/hu/UNI/SIFT/SaliencyToolbox';
    addpath(genpath(saliencyToolboxPath));

    % get input image
    img = imread(imagePath);

    % get and display saliency map
    time = cputime;
    salMap = getSalMap(img, MAP_SIZE);
    salTime = cputime - time
    set(gcf,'CurrentAxes',hSaliency);
    image(salMap)
    %colormap(gray(255))
    salMap = salMap/max(salMap(:));
    
    image_size = zeros(1,2);
    image_size(1) = size(img,1);
    image_size(2) = size(img,2);

    ratio = image_size./MAP_SIZE;
    
    % SIFT image / get image descriptors
    time = cputime;
    imagedescs = sift(img);
    siftTime = cputime - time
    % get familiarity map
    % famMap = getFFmap(imagedescs);

    set(gcf,'CurrentAxes',hImage);
    imshow(img)

    % get descriptors from upper scale range
    [upper_octaves_frames upper_octaves_descs] = imagedescs.get_descriptors_scales(0, 100);

    time = cputime;
    % match descriptors against database
    [indices, dists, features] = matchAgainstDB(upper_octaves_descs, ERROR_UPPER_OCT);
    FFtime = cputime - time
    passed_keypoints = upper_octaves_frames(:,indices);
    
    % show found descriptors on image
    show_descriptors(passed_keypoints, dists,'k');
    
    % estimate object orientation, location and size from keypoints
    objects = estimate_objects(features,passed_keypoints, dists);
    found_objects = findobjs(objects);
    
    figure(1)
    
    % display found objects
    i = 0;
    done = [];
    for obj = found_objects'
       if sum(done == obj.label) == 0
           axes('position',[0.05+0.1*i 0.9 0.05 0.05]);
           imshow(['../coil-100/obj' num2str(obj.label) '__0.png'])
           title(['Object No. ' num2str(obj.label)])
           annotation('arrow',[0.075+0.1*i, 0.05 + 0.6*min(1,max(0,obj.loc(1)/size(img,2)))], [0.9, min(1,max(0,0.85-0.8*obj.loc(2)/size(img,1)))])
           annotation('ellipse',[min(1,max(0,0.6*obj.loc(1)/size(img,2))), min(1,max(0,0.85-0.8*obj.loc(2)/size(img,1)-0.8*obj.ySize/size(img,1))), 2*0.6*obj.xSize/size(img,2), 2*0.8*obj.ySize/size(img,1)],'EdgeColor','y','LineWidth',1)
           i = i+1;
           done(end+1) = obj.label;
       end
    end
 end

