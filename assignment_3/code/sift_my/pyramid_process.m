function imgout = pyramid_process(img, scale, sigma)
%   Image pyramid process
%   If img is M-by-N, then the size of imgout is ceil(M/2)-by-ceil(N/2). 
%   scale = 2(expand) or 0.5(reduce) 
kernelWidth = 5; 
% cw = .375; % kernel centre weight, same as MATLAB func impyramid.
% ker1d = [.25-cw/2 .25 cw .25 .25-cw/2];
% kernel = kron(ker1d,ker1d');
kernel = fspecial('gaussian',[kernelWidth, kernelWidth],2^sigma-2^(sigma-1));
img = im2double(img);
imgout = conv2(img, kernel,'same');
imgout = imresize(imgout, scale);
end
