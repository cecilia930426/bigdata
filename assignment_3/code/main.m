%% Q1 constructing SIFT feature vectors
clc;
clear;

rgb1 = imread('assignment3/A3/assign3Datasets/horizontal/2.png');
image1 = single(rgb2gray(rgb1));
[keypoints1,features1] = sift(image1,'Levels',4,'PeakThresh',5);

rgb2 = imread('assignment3/A3/assign3Datasets/horizontal/3.png');
image2 = single(rgb2gray(rgb2));
[keypoints2,features2] = sift(image2,'Levels',4,'PeakThresh',5);

figure(1)
imshow(rgb2gray(rgb1));
hold on
plot(round(keypoints1(1,:)), round(keypoints1(2,:)), 'r*');

figure(2)
% subplot(1,2,1)
x=1:1:128;
bar(x, features1(:, 219))
title('histogram')

descpt1 = sift_my(rgb2gray(rgb1));
descpt2 = sift_my(rgb2gray(rgb2));

figure(8)
subplot(1,2,1)
imshow(rgb1);hold on;
viscircles(keypoints1(1:2,:)',keypoints1(3,:)');

theta = 45;
[keypoints11,~] = sift(imrotate(image1,theta,'crop'),'Levels',4,'PeakThresh',5);
subplot(1,2,2)
imshow(imrotate(rgb1,theta,'crop'));hold on;
viscircles(keypoints11(1:2,:)',keypoints11(3,:)');

figure(9)
subplot(1,2,1)
imshow(rgb1);hold on;
viscircles(fliplr(descpt1(:,1:2)).*descpt1(:,3),descpt1(:,3));

theta = 45;
descpt11 = sift_my(imrotate(rgb2gray(rgb1),theta,'crop'));
subplot(1,2,2)
imshow(imrotate(rgb1,theta,'crop'));hold on;
viscircles(fliplr(descpt11(:,1:2)).*descpt11(:,3),descpt11(:,3));

%% Q2 feature matching strategy
[indexPairs,matchmetric] = matchFeatures(features1',features2');
img1_points = keypoints1(1:2, indexPairs(:, 1))';
img2_points = keypoints2(1:2, indexPairs(:, 2))';

figure(10); ax = axes;
showMatchedFeatures(rgb1,rgb2,img1_points,img2_points,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');

num = 15; s=1;
[index1, index2] = siftMatch(descpt1, descpt2, num);
figure;
showMatchedFeatures(rgb2gray(rgb1), rgb2gray(rgb2), descpt1(index1, [2 1]).* descpt1(index1, 3), descpt2(index2, [2 1]).* descpt1(index1, 3)*s, 'montage');
title('Sift Matching');

%% Q3 RANSAC algorithm
[H_ransac,im1InlierCorrPts,im2InlierCorrPts] = transformRANSAC(img1_points,img2_points);
figure(11); ax = axes;
showMatchedFeatures(rgb1,rgb2,im1InlierCorrPts,im2InlierCorrPts,'montage','Parent',ax);
img2rgb = im2double(imread('assignment3/A3/assign3Datasets/horizontal/4.png'));
im2_transformed = transform_image(img2rgb, H_ransac);
figure(12)
imshow(im2_transformed)
%% Q4 create a panorama
clc;
clear;
numImages = 2;
imageSize = zeros(numImages,2);
rgb0 = imread('assignment3/A3/assign3Datasets/horizontal/0.png');
image0 = single(rgb2gray(rgb0));
imageSize(1,:) = size(image0);
tforms(numImages+1) = projective2d(eye(3));
xlim = ones(numImages+1,2);
ylim = ones(numImages+1,2);
 for i=1:numImages
    imageName1=strcat(num2str(i-1),'.png');
    rgb1 = imread(strcat('assignment3/A3/assign3Datasets/horizontal/', imageName1));
    image1 = single(rgb2gray(rgb1));
    [keypoints1,features1] = sift(image1,'Levels',4,'PeakThresh',5);
    
    imageName2=strcat(num2str(i),'.png');
    rgb2 = imread(strcat('assignment3/A3/assign3Datasets/horizontal/', imageName2));
    image2 = single(rgb2gray(rgb2));
    [keypoints2,features2] = sift(image2,'Levels',4,'PeakThresh',5);
    
    imageSize(i+1,:) = size(image2);
    
    [indexPairs,matchmetric] = matchFeatures(features1',features2');
    img1_points = keypoints1(1:2, indexPairs(:, 1))';
    img2_points = keypoints2(1:2, indexPairs(:, 2))';
    
    [H_ransac,im1InlierCorrPts,im2InlierCorrPts] = transformRANSAC(img1_points,img2_points);    
    tforms(i+1) = projective2d(inv(H_ransac)');
    tforms(i+1).T = tforms(i+1).T * tforms(i).T; 
 end

 % Compute the output limits  for each transform
for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);    
end

avgXLim = mean(xlim, 2);
[~, idx] = sort(avgXLim);
centerIdx = floor((numel(tforms)+1)/2);
centerImageIdx = idx(centerIdx);
Tinv = invert(tforms(centerImageIdx));
for i = 1:numel(tforms)    
    tforms(i).T = tforms(i).T * Tinv.T;
end

%%% Initialize the Panorama
for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
end
maxImageSize = max(imageSize);

% Find the minimum and maximum output limits 
xMin = min([1; xlim(:)]);
xMax = max([maxImageSize(2); xlim(:)]);
yMin = min([1; ylim(:)]);
yMax = max([maxImageSize(1); ylim(:)]);

% Width and height of panorama.
width  = round((xMax - xMin)/2);
height = round((yMax - yMin)/2);

% Initialize the "empty" panorama.
panorama = zeros([height width 3], 'like', rgb0);
% panorama = zeros([height width 3]);

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');  

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

% Create the panorama.
for i = 1:numImages+1
    imageNameI=strcat(num2str(i-1),'.png');
    I = imread(strcat('assignment3/A3/assign3Datasets/horizontal/', imageNameI));
    % Transform I into the panorama.
    warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);
    % Generate a binary mask.    
    mask = imwarp(true(size(I,1),size(I,2)), tforms(i), 'OutputView', panoramaView);
    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, mask);
end

figure(15)
imshow(panorama)



