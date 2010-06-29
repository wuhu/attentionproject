function map = addFamValue(xc, yc, xr, yr, or, map, famVal)
% Draws an ellipse at given center location, radii and orientation

% initialize image matrix
%ellipse = zeros(480, 640);
pixels = max(size(map));

x=[];
y=[];

res = [500,500];

for t = 0:2*pi/pixels:2*pi
    curx = ceil(xc + xr*cos(t)*cos(or) + yr*sin(t)*sin(or));
    cury = ceil(yc + xr*cos(t)*sin(or) + yr*sin(t)*cos(or));
    
    if ( curx > res(2) || cury > res(1) || curx < 1 || cury < 1 )
        continue;
    end
    
    x = [x, curx];
    y = [y, cury];
    
    map(cury, curx) = map(cury, curx) + famVal;
end

%ellipse =[x;y];

%% Now we need to fill each line within the ellipse
% go verticaly through every point of the perimeter

min_y = min(y);
max_y = max(y);

% go through every row of the ellipse
for myY = min_y:max_y
    
    % find indicespoints which have the same Y coordinate
    row = find(y==myY);
    row = x(row);
    
    min_x = min(row);
    max_x = max(row);
    
    % mark every pixel in that column
    for myX = min_x:max_x
       map(myY, myX) = map(myY, myX) + famVal; 
    end
    
end

%% Attempt to implement a loop-free algorithm, it works so far, ceil(nx/y) =
%% x/y, but don't know how to put them into an matrix without using a loop
% t = 0:2*pi/pixels:2*pi;
% cost = cos(t);
% sint = sin(t);
% cosor = cos(or);
% sinor = sin(or);
% 
% nx = xc + xr*cost*cosor + yr*sint*sinor;
% ny = yc + xr*cost*sinor + yr*sint*cosor;