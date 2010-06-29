function map = add_gauss(map,weight,x,y,gsize)
    imsize = size(map);
    for i = 1:imsize(1)
        for j = 1:imsize(2)
            dist = sqrt((x-i)^2+(y-j)^2);
            map(i,j) = map(i,j) + weight * normpdf(dist,0,gsize);
        end
    end
end