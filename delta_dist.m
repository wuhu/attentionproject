%% compute the delta-distance that is used for QT-clustering
function dist_value = delta_dist(oi,oj)
    delta_size = abs( (oi.xSize + oi.ySize) / 2 - (oj.xSize + oj.ySize) / 2 );
    delta_or = abs( oi.or - oj.or );
    size_avg = ( (oi.xSize + oi.ySize) / 2 + (oj.xSize + oj.ySize) / 2 ) / 2;
    delta_xy = sqrt( (oi.loc(1) - oj.loc(1))^2 + (oi.loc(2) - oj.loc(2))^2 );
    dist_value = delta_xy/size_avg + delta_size/size_avg + delta_or/pi;
end
