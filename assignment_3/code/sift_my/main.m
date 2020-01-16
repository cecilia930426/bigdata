clc
clear
image = imread('manor.png');
image = rgb2gray(image);
% level = 6;
% [ImageGauss,~] = genPyramid(image, 'gauss', level);
% [ImageDoG, ImageDiff] = genPyramid(image, 'laplace', level); % or 'laplace'
% 
% %% Question 1,2
% % Draw composite figure
% I = ImageDoG;
% m = size(I{1}, 1);
% newI = I{1};
% for i = 2 : numel(I)
%     [q,p,~] = size(I{i});
%     I{i} = cat(1,repmat(zeros(1 , p),[m - q , 1]),I{i});
%     newI = cat(2,newI,I{i});
% end
% figure(1)
% imshow(newI,[]);       
% figure(2)
% imshow(newI);
% 
% %% Question 3
% thresh = 0.019;
% extrema = getExtrema(ImageDiff, thresh);
% figure(3)
% imshow(image);
% hold on
% % use a circle of a different color: 
% % blue (level 1), green (level 2), yellow (level 3), magenta (level 4), red (level 5).
% style = {'bo', 'go', 'yo', 'mo'};
% for i = 1:level-2
%     point = extrema((extrema(:,3) == 2^i),:);
%     plot(point(:,2) * 2^i, point(:,1)* 2^i, style{i});
%     hold on 
% end
% 
% %% Question 4
% % Calculating orientation of gradient in each scale
% GO = cell(1,level); % Gradient Orientation
% GM = cell(1,level);
% GX = cell(1,level);
% GY = cell(1,level);
% for i = 1:level
%     [row,col] = size(ImageGauss{i});
%     [tempM,tempO] = imgradient(ImageGauss{i});
%     [tempX,tempY] = imgradientxy(ImageGauss{i});
%     GO{i} = tempO;
%     GM{i} = tempM;
%     GX{i} = tempX;
%     GY{i} = tempY;
% end
% 
% % Calculating orientation and magnitude of pixels at key point vicinity
% % Fixing overflow key points near corners and edges
% % of image. 
% radius=8;
% n = 1;
% number = size(extrema, 1);
% Magnitude = cell(1, number);
% Orientation = cell(1, number);
% WeightedMagnitude = cell(1, number);
% X = cell(1, number);
% Y = cell(1, number);
% imagePatch = cell(1, number);
% for i = 1:level-2
%     imageSize = imresize(image, 2^(-i));
%     GradientOrientations = GO{i+1};
%     GradientMagnitudes = GM{i+1};
%     GradientX = GX{i+1};
%     GradientY = GY{i+1};
%     weights = getGaussKernel(4, radius);
%     [row,col] = size(GradientMagnitudes);
%     point = extrema((extrema(:,3) == 2^i),:);
%     for j = 1: size(point,1)
%         x = point(j, 1);
%         y = point(j, 2);
%         a=0;b=0;c=0;d=0;
%         if x-1-radius < 0
%             a = -(x-1-radius);
%         end
%         if y-1-radius < 0
%             b = -(y-1-radius);
%         end
%         if row-x-radius < 0
%             c = -(row-x-radius);
%         end
%         if col-y-radius < 0
%             d = -(col-y-radius);
%         end
%         patch = imageSize(x-radius+a:x+radius-c,y-radius+b:y+radius-d);
%         tempMagnitude = GradientMagnitudes(x-radius+a:x+radius-c,y-radius+b:y+radius-d);
%         tempWeightedMagnitude = GradientMagnitudes(x-radius+a:x+radius-c,y-radius+b:y+radius-d).*weights(1+a:end-c,1+b:end-d);
%         tempOrientation = GradientOrientations(x-radius+a:x+radius-c,y-radius+b:y+radius-d);
%         tempGradientX = GradientX(x-radius+a:x+radius-c,y-radius+b:y+radius-d);
%         tempGradientY = GradientY(x-radius+a:x+radius-c,y-radius+b:y+radius-d);
%         Magnitude{n} = tempMagnitude;
%         Orientation{n} = tempOrientation;
%         WeightedMagnitude{n} = tempWeightedMagnitude;
%         X{n} = tempGradientX;
%         Y{n} = tempGradientY;
%         imagePatch{n}= patch;
%         n = n+1;
%     end
% end
% figure(4)
% subplot(2,2,1)
% imshow(imagePatch{100}, [])
% title('Image patch')  
% subplot(2,2,2)
% imshow(Magnitude{100}, [])
% title('Image gradient magnitude')
% subplot(2,2,3)
% imshow(Magnitude{100}, []); hold on
% [x, y] = meshgrid(1:17, 1:17);
% quiver(x, y,  X{100}, Y{100});
% title('Image gradient orientation')
% subplot(2,2,4)
% imshow(WeightedMagnitude{100}, [])
% title('Weighted gradient magnitude')
% 
% 
% %% Question 5
% GHistogram = cell(1, number);
% peak = zeros(number,36);
% for n = 1:number
%     tempWeightedMagnitude = WeightedMagnitude{n};
%     tempOrientation = Orientation{n};
%     [wRows, wCols] = size(tempWeightedMagnitude);
%     gHist = zeros(1,36);
%     for i = 1:wRows
%         for j = 1:wCols
%             % Converting orientation calculation window
%             temp = tempOrientation(i,j);
%             if temp < 0
%                 temp = 360 + temp;
%             end
%             bin = floor(temp/10)+1;
%             gHist(bin) = gHist(bin) + tempWeightedMagnitude(i,j);
%         end
%     end
%     GHistogram{n} = gHist;
%     [Maxima,MaxIdx] = findpeaks(gHist);
%     strongest = max(Maxima);
%     location = find(gHist==strongest);
%     peak(n,:) = [gHist(location:end),gHist(1:location-1)];
% end
% 
% peak_align = zeros(number, 39);
% peak_align(:,1:3) = extrema;
% peak_align(:,4:39) = peak;
% 
% figure(5)
% subplot(1,2,1)
% x=1:1:36;
% bar(x, GHistogram{20}*255)
% title('histogram')
% subplot(1,2,2)
% bar(x, peak(20,:)*255)
% title('peak-aligned histogram')

%% Question 6
x0 = 100;y0 = 100; theta = 20; s = 1;
image2 = rotationScale(image, x0, y0, theta, s);
figure(6)
imshow(image2)
%% Question 7
% Match the SIFT descriptor accross two images
descpt1 = sift(image);
descpt2 = sift(image2);
num = 15;  
[index1, index2] = siftMatch(descpt1, descpt2, num);
figure;
showMatchedFeatures(image, image2, descpt1(index1, [2 1]).* descpt1(index1, 3), descpt2(index2, [2 1]).* descpt1(index1, 3)*s, 'montage');
title('Sift Matching');


