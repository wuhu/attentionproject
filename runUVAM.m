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

    %% relevant parameters

    ERROR_UPPER_OCT = 200;  % threshold for detecting keypoint in upper octaves (not used in paper)
    ERROR_LOWER_OCT = 200; % threshold for detecting keypoint in lower octaves (not used in paper)
    ROI_SCALES      = 3;    % scales used within ROIs go from 0 to ROI_SCALES (value in paper: 3 (lowest octave, assuming that an octave consists of three scales))
    ROI_SIZE        = 4;   % size of a ROI in pixels (value in paper: 32)
    MAXI_LIM        = 0;  % threshold for UA-map value in ROI at which feedback loop will be stopped (not used in paper)
    ITERATION_LIM   = 50; % number of maximum iterations of the feedback loop (not used in paper)
    QT              = 0.5; % quality threshold for QT-clustering (value in paper: 0.75)
    SIGMA_K         = 0.25; % sigma parameter for update of feed-forward familiarity map (value in paper: 0.25)
    SIGMA_C         = 0.25; % sigma parameter for update of feed-back familiarity map (value in paper: ??)
    MAP_SIZE        = [100,100]; % size of attention maps (with a sufficient size, this value should have neglectable influence on the results)
    SAL_WEIGHT      = 0.5; % weight of the saliency map in comparison to the familiarity map (value in paper: 0.5 (implicit, since they do not use weighting))
    USE_SALIENCY    = 1; % use saliency map?
    USE_FAM         = 0; % use familiarity map?
    DISPLAY         = 1; % graphical output?
    VL_FEAT_PATH    = '../vlfeat-0.9.8/toolbox/vl_setup.m';
    SALIENCY_PATH   = '/home/hu/UNI/SIFT/SaliencyToolbox';

    %% initialization
    
    close all
    clc

    % initialize vlfeat (for nearest neighbor matching)
    run(VL_FEAT_PATH); 
    % initialize saliency toolbox
    addpath(genpath(SALIENCY_PATH));
    
    % initialize figure (returns axis handles)
    if DISPLAY
        [hImage hSaliency hFamiliarity] = init_figure;
    end
    
    % load object database
    load_db

    % get input image
    img = imread(imagePath);
    
    % display image
    if DISPLAY
        set(gcf,'CurrentAxes',hImage);
        imshow(img) 
    end
    
    % compute ratio between map and image (to switch between sizes)
    [image_size(1) image_size(2) ~] = size(img);
    ratio = image_size./MAP_SIZE;

    %% saliency map
    if USE_SALIENCY
        % get and display saliency map
        time = cputime; % TIME
        salMap = getSalMap(img, MAP_SIZE);
        salMap = salMap/max(salMap(:));
        salTime = cputime - time % TIME

        % display
        if DISPLAY
            set(gcf,'CurrentAxes',hSaliency);
            imagesc(salMap)
        end
    end

    %% SIFT analysis
    % SIFT image / get image descriptors
    time = cputime; % TIME
    imagedescs = sift(img);
    siftTime = cputime - time % TIME

    %% feed-forward familiarity map
    if USE_FAM
        % get descriptors from upper scale range
        [upper_octaves_frames upper_octaves_descs] = imagedescs.get_descriptors_scales(ROI_SCALES+1, 100);

        time = cputime;
        % match descriptors against database
        [indices, dists, features] = matchAgainstDB(upper_octaves_descs, ERROR_UPPER_OCT);
        FFtime = cputime - time
        passed_keypoints = upper_octaves_frames(:,indices);

        % show found descriptors on image
        if DISPLAY
            show_descriptors(passed_keypoints, dists,'k');
        end

        % estimate object orientation, location and size from keypoints (for
        % FF-map generation and later clustering
        objects = estimate_objects(features,passed_keypoints, dists);

        % compute feed-forward familiarity map
        FFfmap = getFFfmap(objects, MAP_SIZE, SIGMA_K, ratio);
    else
        objects = [];
    end

    %% main feedback loop    
    
    % create unified attention map (weighted sum of saliency map and familiarity map)
    if USE_SALIENCY && USE_FAM
        UAmap = (1-SAL_WEIGHT)*FFfmap + (SAL_WEIGHT)*salMap;
    elseif USE_FAM
        UAmap = FFfmap;
    else
        UAmap = salMap;
    end

    maxi = 1;
    it = 0;
    time = cputime;
    found_objects = [];
    [numbRegions, x, y, blockCoordinates] = possibleROIs(UAmap, ROI_SIZE);

    while(maxi >= MAXI_LIM && it < ITERATION_LIM)
        it = it + 1;
        
        % find ROI on UA map
        [ROI ROI_big maxi] = findROI(numbRegions, x, y, blockCoordinates, UAmap, ratio);

        % display ROI on image
        if DISPLAY
            set(gcf,'CurrentAxes',hImage);
            hold on
            rectangle('Position',[ROI_big(2),ROI_big(1),ROI_big(4)-ROI_big(2)+1,ROI_big(3)-ROI_big(1)+1]);
            hold off
        end
        
        if USE_FAM
            % get descriptors from lower scale range inside current ROI
            [lower_octaves_frames lower_octaves_descs] = imagedescs.get_descriptors(ROI_big, 0, ROI_SCALES);
        else
            [lower_octaves_frames lower_octaves_descs] = imagedescs.get_descriptors(ROI_big, 0, 9999);
        end
        
        % match descriptors against database
        [indices, dists, features] = matchAgainstDB(lower_octaves_descs, ERROR_LOWER_OCT);
        passed_keypoints = lower_octaves_frames(:,indices);
        if DISPLAY
            show_descriptors(passed_keypoints,dists,'r');
        end
        % estimate pose of new objects
        new_objects = estimate_objects(features,passed_keypoints, dists); % (not necessary for all, should be changed for performance)
        if isempty(objects)
            objects = new_objects
            new_objects = [];
        end
        % add new objects
       
        if ~isempty(new_objects) % if we have found new descriptors ..
            n_o_labels = [new_objects.label];
            while ~isempty(n_o_labels)
                oldis = find([objects.label] == n_o_labels(1)); % .. look if we had found descriptors before, that seem to belong to the same object as what we found now ..
                old = objects(oldis);
                if size(old) > 0
                    newis = find([new_objects.label] == n_o_labels(1));
                    new = new_objects(newis);

                    [UAmap newly_found_objects ois] = getFBfmap(UAmap,[old, new],QT,SIGMA_C,ratio,USE_FAM); % .. and cluster them (i.e. update the familiarity map and find new objects)

                    if ~isempty(newly_found_objects) % if we foud something new ..
                        found_objects = cat(1, found_objects, newly_found_objects(1)); % .. remember that ..
                        for i = 1:length(newly_found_objects) % .. and exclude the corresponding descriptors from future clustering
                            nis = newis(ois(ois > length(oldis)));
                            olis = oldis(ois(ois <= length(oldis)));
                            objects(olis) = [];
                            new_objects(nis) = [];
                        end
                    end
                end
                n_o_labels(n_o_labels == n_o_labels(1)) = [];
            end
        end
        
        % remember newly found descriptors that were not conclusive
        objects = [objects,new_objects];

        % inhibite return to ROI location by updating UAmap
        UAmap(ROI(1):ROI(3),ROI(2):ROI(4)) = ones(ROI(3)-ROI(1)+1,ROI(4)-ROI(2)+1) * -2;
        
        % update display of UA map
        if DISPLAY
            set(gcf,'CurrentAxes',hFamiliarity);
            imagesc(UAmap);
        end
    end
    FBtime = cputime - time

    
    %% display found objects
    if DISPLAY
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
 end
