clear
clc
sigma = 3; % ? parameter
N=7;
threshold_LOG=0.75;
threshold_Gabor=0.75;
lambda = 10;
angle = pi/4;

% Convolve the 2D Laplacian of Gaussian filters from Question 2 b) with the input images
I = imread('Paolina.jpg');
% I = imread('tiger.jpg');
image = rgb2gray(I);

[even, odd] = make2DGabor(N, lambda, angle);
Gabor_odd = conv2(image, odd, 'same');
Gabor_even = conv2(image, even, 'same');
figure(2)
% subfigure(1, 2, 1);
imshow(Gabor_odd); 

output_odd = ZeroCrossFunc(Gabor_odd, threshold_Gabor);
output_even = ZeroCrossFunc(Gabor_even, threshold_Gabor);
figure(4)
imshow(I)
hold on
display = imoverlay(image, output_odd, [1,0,0]);
imshow(display)
figure(5)
imshow(output_odd)
% figure(6)
% imshow(output_odd + output_even)

                





