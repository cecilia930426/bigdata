function g = make2DGaussian(N, sigma)
% N is assumed to be odd, and so the origin (0,0) is positioned at indices
% (M+1,M+1) where N = 2*M + 1.
% creates gaussian kernel with side length N and a sigma of sigma
ax = linspace(-(N - 1.) / 2., (N - 1.) / 2., N);
[xx, yy] = meshgrid(ax, ax);
kernel = exp(-0.5 * (xx.^2 + yy.^2) /(sigma.^2));
g = kernel./sum(kernel(:));
% the same as this function h = fspecial('gaussian',[3,3],0.5)
% surf(xx,yy,g)
% max(g(:))
% % imshow(g/max(g(:))*255)
% imshow(g.*255)
end