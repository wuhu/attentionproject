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
     

function runUVAMsal(imagePath)  

    % set relevant parameters

    ERROR_UPPER_OCT = 2;  % threshold for detecting keypoint in upper octaves
    ERROR_LOWER_OCT = 2; % threshold for detecting keypoint in lower octaves
    ROI_SCALES      = 3;    % scales used within ROIs go from 0 to ROI_SCALES
    ROI_SIZE        = 32;   % size of a ROI in pixels
    MAXI_LIM        = 0.05;  % threshold of stopping for looking for next ROI
    FIND_DIST       = 0.3;  % if matching distance is <= FIND_DIST, object is marked as found
    MAP_SIZE        = [576, 768];
    

    close all
    clc

    init % load object database
    run('vlfeat/toolbox/vl_setup.m'); % init vlfeat

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
    colormap(gray(255))
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
    %[upper_octaves_frames upper_octaves_descs] = imagedescs.get_descriptors_scales(ROI_SCALES+1, 100);

    %time = cputime;
    % match descriptors against database
    %[indices, dists, features] = matchAgainstDB(upper_octaves_descs, ERROR_UPPER_OCT);
    %FFtime = cputime - time
    %passed_keypoints = upper_octaves_frames(:,indices);
    
    % show found descriptors on image
    %show_descriptors(passed_keypoints, dists,'k');
    
    % estimate object orientation, location and size from keypoints
    %objects = estimate_objects(features,passed_keypoints, dists);
    
    % compute ffMap (needs to be improved)
    %ffmap = mark_obj(imgr,objects,FIND_DIST);
    %FFfmap = getFFfmap(objects, size(salMap),ratio);

    %UAmap = FFfmap./2 + salMap;

    maxi = 1;
    count = 0;
    time = cputime;
    found_objects = [];
    objects = [];
    [numbRegions, x, y, blockCoordinates] = possibleROIs(salMap, ROI_SIZE);
     
    while(maxi >= MAXI_LIM)
        count = count + 1;
        
        % find ROI on saliency map (change to UA map)
        [ROI maxi] = findROI(numbRegions, x, y, blockCoordinates, salMap);
        ROI_big(1) = ROI(1,1) * ratio(1);
        ROI_big(3) = ROI(1,3) * ratio(1);
        ROI_big(2) = ROI(1,2) * ratio(2);
        ROI_big(4) = ROI(1,4) * ratio(2);
        
        % display ROI on figure
        set(gcf,'CurrentAxes',hImage);
        hold on
        rectangle('Position',[ROI_big(2),ROI_big(1),ROI_big(4)-ROI_big(2)+1,ROI_big(3)-ROI_big(1)+1]);
        hold off
        
        % get descriptors from lower scale range inside current ROI
        [lower_octaves_frames lower_octaves_descs] = imagedescs.get_descriptors(ROI_big, 0, 1000);
        % match descriptors against database
        [indices, dists, features] = matchAgainstDB(lower_octaves_descs, ERROR_LOWER_OCT);
        passed_keypoints = lower_octaves_frames(:,indices);
        show_descriptors(passed_keypoints,dists,'r');
        % estimate pose of new objects
        new_objects = estimate_objects(features,passed_keypoints, dists);
        % add new objects
       
        interesting_objs = [];
        if isempty(objects) && ~isempty(new_objects)
            objects = new_objects;
        elseif ~isempty(new_objects)
            n_o_labels = [new_objects.label];
            while ~isempty(n_o_labels)
                old = objects([objects.label] == n_o_labels(1));
                if size(old) > 0
                    new = new_objects([new_objects.label] == n_o_labels(1));
                    [salMap newly_found_objects] = getFBfmapsal(salMap,[old, new],ratio, FIND_DIST);
                    found_objects = cat(1, found_objects, newly_found_objects);

                end
                n_o_labels(n_o_labels == n_o_labels(1)) = [];
            end
        end
        
        
        objects = [objects,new_objects];
        
%         figure(3)
%         hold on
%         gazeSequence(img, ROI, count);
%         hold off
        % inhibition of return at ROI location
        salMap(ROI(1):ROI(3),ROI(2):ROI(4)) = ones(ROI(3)-ROI(1)+1,ROI(4)-ROI(2)+1) * -2;
        
        % update display of UA map
        figure(1)
        set(gcf,'CurrentAxes',hFamiliarity);
        imagesc(salMap);
        
    end
    FBtime = cputime - time
    figure(1)
    
    
    % display found objects
    i = 0;
    for obj = found_objects'
       axes('position',[0.05+0.1*i 0.9 0.05 0.05]);
       imshow(['../coil-100/obj' num2str(obj.label) '__0.png'])
       title(['Object No. ' num2str(obj.label)])
       annotation('arrow',[0.075+0.1*i, 0.05 + 0.6*min(1,max(0,obj.loc(1)/size(img,2)))], [0.9, min(1,max(0,0.85-0.8*obj.loc(2)/size(img,1)))])
       annotation('ellipse',[min(1,max(0,0.6*obj.loc(1)/size(img,2))), min(1,max(0,0.85-0.8*obj.loc(2)/size(img,1)-0.8*obj.ySize/size(img,1))), 2*0.6*obj.xSize/size(img,2), 2*0.8*obj.ySize/size(img,1)],'EdgeColor','y','LineWidth',1)
       i = i+1;
    end
 end

