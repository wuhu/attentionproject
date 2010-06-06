image = imread('images_no_rotation/img01.jpg');

imm = sift(image);

init
imageg = im2double(rgb2gray(image));
[a,b,c]=matchAgainstDB(imm.descriptors,0.1);
map = zeros(576,768);
xl = floor(imm.frames(1,198) - c(1).xLoc)
yl = (imm.frames(2,198) - c(1).yLoc)
yz = floor(imm.frames(3,198) * c(1).ySize)
xz = floor(imm.frames(3,198) * c(1).xSize)
mmap = add_ellipse(imageg,0.3,xl,yl,xz/2,yz/2,0);
imshow(mmap)