function map = add_gauss(map,weight,x,y,gsize)
    imsize = size(map);
    dist = zeros(imsize);
    for i = 1:imsize(1)
        for j = 1:imsize(2)
            dist(i,j) = sqrt((x-i)^2+(y-j)^2);
        end
    end
    map = map + normpdf(dist,0,gsize/5) * weight*5;
end