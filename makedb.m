% script for creating a descriptor database for the COIL-100 objects

clear
descriptors = zeros(128,0);
features = struct([]);


DB_PATH = '../coil-100/obj';
N = 100;

for i = 1:N% objects in DB
    for j = 0%:5:355 % object orientations
        file = [DB_PATH num2str(i) '__' num2str(j) '.png']; % read image

        image = im2double(rgb2gray(imread(file)));

        [frames,descriptor] = siftmex(image); % find descriptors
        descriptors(:,end + 1: end + size(descriptor,2)) = descriptor;
        
        % to get the image shape take the keypoint, substract xLoc and
        % yLoc, multiply by xSize and ySize and rotate by -orientation
        for frame = frames
            ind = length(features) + 1;
            features(ind).xSize = size(image,1)/frame(3);
            features(ind).ySize = size(image,2)/frame(3);
            features(ind).loc = frame([1,2]) - size(image)'/2;
            features(ind).orientation = frame(4);
            features(ind).object = i;
            features(ind).scale = frame(3);
        end
    end
end
desctree = vl_kdtreebuild(descriptors);
save('desctree','desctree')
save('descriptors','descriptors');
save('descr_features','features');
