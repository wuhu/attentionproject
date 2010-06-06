function map = add_ellipse(map,weight,y,x,ysize,xsize,rot)
    N = max(xsize,ysize);
    cosdrot = cosd(rot);
    sindrot = sind(rot);
    for i = 0:2*N
        for j = 0:2*N
            if i+x-N >0 && i+x-N< size(map,1) && j + y-N > 0 && j+y-N < size(map,2) 
                if ((((i-N)*cosdrot-(j-N)*sindrot))^2)/xsize^2+((((j-N)*cosdrot+(i-N)*sindrot))^2)/ysize^2 <= 1
                    map(i+x-N,j+y-N) = map(i+x-N,j+y-N) + weight;
                end
            end
        end
    end
end