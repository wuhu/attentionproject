clear
bcks = dir('backgrounds');
objs = dir('objects');

for imm = 1:100
    bckno = randi([3,length(bcks)]);

    img = im2double(imread(['backgrounds/' bcks(bckno).name]));
    
    %numo = randi([3,5]);

    for os = 1:4

        obno = randi([3,length(objs)]);

        [cdata,~,alpha] = imread(['objects/' objs(obno).name]);
        
        cdata = im2double(cdata);
        alpha = im2double(alpha);
        
        imsize = size(img);

        rotate = rand(1) * 360;
        scale = rand(1) * 1.4 + 0.6;


        cdata = imresize(cdata, scale);
        cdata = imrotate(cdata, rotate);
        alpha = imresize(alpha, scale);
        alpha = imrotate(alpha, rotate);

        objsize = size(cdata);

        xlocation = randi([0,imsize(2)-floor(objsize(2))]);
        ylocation = randi([0,imsize(1)-floor(objsize(1))]);

        for i = 1:objsize(1)
            for j = 1:objsize(2)
                if alpha(i,j) ~= 0
                   img(i+ylocation,j+xlocation,:) = ((1-alpha(i,j))*img(i+ylocation,j+xlocation,:) + alpha(i,j)*cdata(i,j,:));
                end
            end
        end
    end

    imwrite(img,['test_images/' num2str(imm) '.jpg'],'jpg');
end