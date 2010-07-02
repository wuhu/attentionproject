%% sift class 
% create an instance using an image, will perform SIFT analysis and save found keypoints & descriptors
% descriptors can then be accessed using ROIs and scale ranges.
classdef sift
    properties
        frames
        descriptors
        xmax
        ymax
    end
    methods
        % constructor
        function obj = sift(image)
            image = im2double(rgb2gray(image));
            [obj.frames,obj.descriptors] = siftmex(image);
            [obj.ymax obj.xmax] = size(image);
        end
        % get descriptors in ROI if they are on a scale between smin and smax
        function [frames descriptors] = get_descriptors(obj, ROI, smin, smax)
            i = obj.frames(1,:) > ROI(2) & obj.frames(1,:) < ROI(4) & obj.frames(2,:) > ROI(1) & obj.frames(2,:) < ROI(3) & obj.frames(3,:) >= smin & obj.frames(3,:) < smax;
            frames = obj.frames(:,i);
            descriptors = obj.descriptors(:,i);
        end
        % get descriptors if they are on a scale between smin and smax
        function [frames descriptors] = get_descriptors_scales(obj, smin, smax)
            i = obj.frames(3,:) > smin & obj.frames(3,:) < smax;
            frames = obj.frames(:,i);
            descriptors = obj.descriptors(:,i);
        end
    end
end
