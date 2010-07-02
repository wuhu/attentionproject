% findROI(...)
%     computes the mean value for each region and returns the upper-left and lower-right
%     coordinates of the region with highest mean value (= Region Of Interest, ROI)
%       ROI:  vector with upper-left and lower-rigth coordinates of 
%             the region with the highest mean value [rowUL colUL rowLR colLR]

function [ROI, ROI_big, maxi] = findROI(numbRegions, x, y, blockCoordinates, map, ratio)

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

ROI_big(1) = round((ROI(1,1)) * ratio(1));
ROI_big(3) = round((ROI(1,3)+1) * ratio(1))-1;
ROI_big(2) = round((ROI(1,2)) * ratio(2));
ROI_big(4) = round((ROI(1,4)+1) * ratio(2))-1;