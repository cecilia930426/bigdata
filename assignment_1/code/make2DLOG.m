function g = make2DLOG(N, sigma)
% N is assumed to be odd, and so the origin (0,0) is positioned at indices
% (M+1,M+1) where N = 2*M + 1.
% creates Laplacian of Gaussian with side length N and a sigma of sigma
ax = linspace(-(N - 1.) / 2., (N - 1.) / 2., N);
[xx, yy] = meshgrid(ax, ax);
kernel = exp(-0.5 * (xx.^2 + yy.^2) ./(sigma.^2));
LOG_t = kernel.*(xx.^2 + yy.^2 - 2* sigma^2)/(sigma^4 * sum(kernel(:)));
% make the filter sum to zero
LOG = LOG_t - sum(LOG_t(:))/N^2;
% the same as function g=fspecial('log',[3 3],0.5)
g=LOG;
% surf(xx,yy,g)
% max(g(:))
% imshow(g/max(g(:))*255)
% imshow(g.*255)
end