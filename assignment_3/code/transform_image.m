function transformedImage = transform_image(img,H)
    tform = projective2d(inv(H)');
    transformedImage = imwarp(img,tform);
%     figure(1)
%     imshow(transformedImage)    
end

