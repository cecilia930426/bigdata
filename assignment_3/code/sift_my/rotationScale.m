function imageOut = rotationScale(image, x0, y0, theta, s)
[Height,Width] = size(image);
centerX = floor(Width/2+1);
centerY = floor(Height/2+1);
dy = centerY-y0;
dx = centerX-x0;
% How much would the "rotate around" point shift if the 
% image was rotated about the image center. 
[angle, rho] = cart2pol(-dx,dy);
[newX, newY] = pol2cart(angle+angle*(pi/180), rho);
shiftX = round(-newX - dx);
shiftY = round(newY - dy);
% Pad the image to preserve the whole image during the rotation.
padX = abs(shiftX);
padY = abs(shiftY);
padded = padarray(image, [padY padX]);
% Rotate the image around the center.
rotation = imrotate(padded, theta, 'crop');
% Crop the image.
imageRot = rotation(padY+1-shiftY:end-padY-shiftY, padX+1-shiftX:end-padX-shiftX);
imageOut = imresize(imageRot, s);
% figure(1)
% imshow(imageOut)
end

