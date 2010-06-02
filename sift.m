
classdef sift
    properties
        frames
        descriptors
        xmax
        ymax
    end
    methods
        function obj = sift(image)
            image = im2double(rgb2gray(image));
            [obj.frames,obj.descriptors] = siftmex(image);
            [obj.ymax obj.xmax] = size(image);
        end
        function [frames descriptors] = get_descriptors(obj, xmin, xmax, ymin, ymax, smin, smax)
            i = obj.frames(1,:) > xmin & obj.frames(1,:) < xmax & obj.frames(2,:) > ymin & obj.frames(2,:) < ymax & obj.frames(3,:) > smin & obj.frames(3,:) < smax;
            frames = obj.frames(i);
            descriptors = obj.descriptors(i);
        end
        function [frames descriptors] = get_descriptors_scales(obj, smin, smax)
            i = obj.frames(3,:) > smin & obj.frames(3,:) < smax;
            frames = obj.frames(i);
            descriptors = obj.descriptors(i);
        end
    end
end