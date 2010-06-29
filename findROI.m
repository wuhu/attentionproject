% findROI(...)
%     computes the mean value for each region and returns the upper-left and lower-right
%     coordinates of the region with highest mean value (= Region Of Interest, ROI)
%       ROI:  vector with upper-left and lower-rigth coordinates of 
%             the region with the highest mean value [rowUL colUL rowLR colLR]

function [ROI, maxi] = findROI(numbRegions, x, y, blockCoordinates, map)

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

maxi = max(meanVal);
% return ROI 
ROI = blockCoordinates(meanVal == maxi,:);
