clear
descriptors = zeros(129,0);
features = struct;

for i = 1:100 % objects in DB
    for j = 0%:5:355 % object orientations
        file = ['coil-100/obj' num2str(i) '__' num2str(j) '.png']; % read image

        image = im2double(rgb2gray(imread(file)));

        [frames,descriptor] = siftmex(image); % find descriptors
        descriptors(:,end + 1: end + size(descriptor,2)) = descriptor;
        
        % to get the image shape take the keypoint, substract xLoc and
        % yLoc, multiply by xSize and ySize and rotate by -orientation
        for frame = frames
            features(end + 1).xLoc = frame(1) - size(image,1)/2;
            features(end + 1).yLoc = frame(2) - size(image,2)/2;
            features(end + 1).xSize = size(image,1)/frame(4);
            features(end + 1).ySize = size(image,2)/frame(4);
            features(end + 1).orientation = frame(3);
            features(end + 1).object = i;
        end
    end
end

save('descriptors','descriptors');
save('descr_features','descriptor_features');