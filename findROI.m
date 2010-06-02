% findROI(map)
%     Divides an input map into regions of size k-by-k, computes the mean
%     value for each region and returns the upper-left and lower-right
%     coordinates of the regions with highest mean value (= Region
%     Of Interest, ROI)
%       map:  input map, m-by-n matrix
%       maxSize: a scalar; maximal size of a region
%       ROI:  vector with upper-left and lower-rigth coordinates of 
%             the region with the highest mean value [rowUL colUL rowLR colLR]

function ROI = findROI(map, maxSize)

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

% coordinates of each block: [rowUL colUL rowLR colLR]
blockCoordinates = cat(2, begInd, endInd);

% compute mean within each region
meanVal = zeros(numbRegions,1);
for block = 1:numbRegions
    sum = 0;
    for m = 1:x
        for n = 1:y
            sum = sum + map((blockCoordinates(block,1)+m-1), (blockCoordinates(block,2)+n-1));
        end
    end
    meanVal(block) = sum/(x*y);
end

% return ROI 
ROI = blockCoordinates(find(meanVal == max(meanVal)),:);