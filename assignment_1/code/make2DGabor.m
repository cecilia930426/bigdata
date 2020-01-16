function [even, odd] = make2DGabor(N, lambda, angle)
% N is assumed to be odd, and so the origin (0,0) is positioned at indices
% (M+1,M+1) where N = 2*M + 1.
% lambda : wavelength of the Gabor filter
% angle : orientation of the Gabor filter
% Set sigma of Gaussian part of filter = wavelength lambda end
sigma = lambda;
ax = linspace(-(N - 1.) / 2., (N - 1.) / 2., N);
[x, y] = meshgrid(ax, ax);
% Rotation 
x_angle=x*cos(angle)+y*sin(angle);
y_angle=-x*sin(angle)+y*cos(angle);
even= exp(-0.5*(x_angle.^2+y_angle.^2)./sigma^2).*cos(2*pi/lambda*x_angle);
odd= exp(-0.5*(x_angle.^2+y_angle.^2)./sigma^2).*sin(2*pi/lambda*x_angle);
% figure(1)
% surf(x,y,even)
% figure(2)
% surf(x,y,odd)
% max(odd(:))
% imshow(odd.*255)
end