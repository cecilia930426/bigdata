clear
clc
sigma = 3; % ? parameter
N=15;
threshold_LOG=0.75;
threshold_Gabor=0.6;
lambda = 20;
angle = pi/4;

% Convolve the 2D Laplacian of Gaussian filters from Question 2 b) with the input images
I = imread('Paolina.jpg');
% I = imread('tiger.jpg');
image = rgb2gray(I);
filtered_signal=conv2(image,make2DLOG(N, sigma),'same');
% figure(1)
% imagesc(filtered_signal);
% figure(2)
% imshow(filtered_signal); 
% title('Blurred Image')

% zero-crossings use matlab edge
% k = fspecial('log', [10 10], 3.0);
% BW = edge(I,'zerocross', [], k);
% figure(3)
% imshow(BW)

% zero-crossings
% k = fspecial('log', [10 10], 3.0);
k = make2DLOG(N, sigma);
LoG = conv2(image, k, 'same');
figure(2)
imshow(LoG); 
output = ZeroCrossFunc(LoG, threshold_LOG);

figure(4)
imshow(I)
hold on
display = imoverlay(image, output, [1,0,0]);
imshow(display)
figure(5)
imshow(output)