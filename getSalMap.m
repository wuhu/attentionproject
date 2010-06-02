% getSalMap(inputImage, saliencyParams) 
%   Compute and return saliency map. A modified and cut-down version of 
%   runSaliency.
%       inputImage: the file name of the image relative to IMG_DIR,
%                   or the image data themselves,
%                   or an initialized Image structure (see initializeImage);
%       saliencyParams: the saliency parameter set for the operations.
%               
% runSaliency(inputImage)
%    Uses defaultSaliencyParams as parameters.

function map = getSalMap(inputImage,varargin)


% initialize the Image structure if necessary
if (isa(inputImage,'struct'))
  img = inputImage;
else
  img = initializeImage(inputImage);
end

% check that image isn't too huge
img = checkImageSize(img,'Prompt');

% use the default saliency parameters if the user didn't specify any
if isempty(varargin)
  params = defaultSaliencyParams(img.size,'dyadic');
else
  params = varargin{1};
end

% make sure that we don't use color features if we don't have a color image
if (img.dims == 2)
  params = removeColorFeatures(params);
end

% create the saliency map
[salmap,salData] = makeSaliencyMap(img,params);

map = salmap.data;
map = imresize(map, salmap.origImage.size(1:2),'bilinear');
map = 255*mat2gray(map);
