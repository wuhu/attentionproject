load descriptors
load descr_features

[index, params] = makeflann(1:800);
global flann_index
global flann_parameters
global descriptor_features

flann_index = index;
flann_parameters = params;
descriptor_features = features;

%imdesc = sift('img02.jpg');