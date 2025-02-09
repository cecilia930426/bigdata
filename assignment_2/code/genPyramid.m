function [pyramid, ImageDiff] = genPyramid(img, type, level)
%   generate Gaussian or Laplacian pyramid
%   img is the input image, convert to greyscale, will be forced to double. 
%	type can be 'gauss' or 'laplace'.
%	level is downsampling factor + 1. level = sigma
pyramid = cell(1,level+1);
ImageDiff = cell(1, level-2);
pyramid{1} = im2double(img);
% pyramid{1} = double(img);
for p = 2:(level + 1)
	pyramid{p} = pyramid_process(pyramid{p-1}, 0.5, level);
end
if strcmp(type,'gauss'), return; end
for p = 1:level
% 	pyramid{p} = pyramid{p}-pyramid_process(pyramid{p+1}, 2, level);
    pyramid{p} = pyramid{p}-imresize(pyramid{p+1}, 2);
    if p ==level
        pyramid(p+1)=[];
    end
end
for s = 1:level-2
    ImageDiff{s}(:,:,1) = imresize(pyramid{s},0.5); 
    ImageDiff{s}(:,:,2) = pyramid{s+1};
    ImageDiff{s}(:,:,3) = imresize(pyramid{s+2},2);
end
end