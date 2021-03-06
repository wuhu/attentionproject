% possibleROIs(...)
%   Divides an input map into regions of size k-by-k 

function [numbRegions, x, y, blockCoordinates] = possibleROIs(map, maxSize)

% get size of the map
[i,j] = size(map);

% compute best block size < maxSize 
x = 0;
y = 1;
while x ~= y
    [x,y] = bestblk([i j], maxSize);
    maxSize = maxSize-1;
end

% compute total number of blocks in image

numbRegions = (i*j)/(x*y);

begInd = zeros(length(numbRegions),2); % vector for upper-left  indices
endInd = zeros(length(numbRegions),2); % vector for lower-right indices

% compute upper-left and lower-right coordinates for each region
p = 1;
for m = 1:x:i
    for n = 1:y:j
        begInd(p,1) = m;
        begInd(p,2) = n;
        endInd(p,1) = m+x-1;
        endInd(p,2) = n+y-1;
        p = p + 1;
    end
end

% coordinates of each block: [colUL rowUL colLR rowLR]
blockCoordinates = cat(2, begInd, endInd);

end