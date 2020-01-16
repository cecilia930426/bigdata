clc
clear
sigma = 2;
g = make2DLOG(100, sigma);
subplot(1, 3, 1)
imshow(g/max(g(:))*255);title('sigma = 2')
sigma = 5;
g = make2DLOG(100, sigma);
subplot(1, 3, 2)
imshow(g/max(g(:))*255);title('sigma = 5')
sigma = 10;
g = make2DLOG(100, sigma);
subplot(1, 3, 3)
imshow(g/max(g(:))*255);title('sigma = 10')

figure(2)
lambda = 5;
[even, odd] = make2DGabor(100, lambda, 0);
subplot(1, 3, 1)
imshow(odd/max(odd(:))*255);title('lambda = 5')
lambda = 10;
[even, odd] = make2DGabor(100, lambda, 0);
subplot(1, 3, 2)
imshow(odd/max(odd(:))*255);title('lambda = 10')
lambda = 15;
[even, odd] = make2DGabor(100, lambda, 0);
subplot(1, 3, 3)
imshow(odd/max(odd(:))*255);title('lambda = 15')
