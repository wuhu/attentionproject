function gazeSequence(img, ROI, count)
    
    global formerROI
    
    if count == 1
        gazeMap = ones(size(img));
        imshow(gazeMap)
        rectangle('Position',[ROI(2),ROI(1),ROI(4)-ROI(2)+1,ROI(3)-ROI(1)+1],'EdgeColor','r','FaceColor', [0, 0, 0]);
        text(floor((ROI(2)+((ROI(4)-ROI(2)+1)/3))), floor((ROI(1)+((ROI(3)-ROI(1)+1)/3))),sprintf('%d', count),'Color','r');
        formerROI = [ROI(2), ROI(1)];
    else
        step = count/30;    
        rectangle('Position',[ROI(2),ROI(1),ROI(4)-ROI(2)+1,ROI(3)-ROI(1)+1], 'FaceColor', [0+step, 0+step, 0+step]);
        text(floor((ROI(2)+((ROI(4)-ROI(2)+1)/3))), floor((ROI(1)+((ROI(3)-ROI(1)+1)/2))),sprintf('%d', count),'Color','r');
        %arrow(formerROI, [ROI(2),ROI(1)])
        formerROI = [ROI(2), ROI(1)];
    end
end