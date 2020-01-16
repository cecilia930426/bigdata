function transformedPoints = transformFor(img_points,H)
    transformedPoints = [(H(1,1:2)*img_points'+H(1,3))./(H(3,1:2)*img_points'+H(3,3));...
        (H(2,1:2)*img_points'+H(2,3))./(H(3,1:2)*img_points'+H(3,3))]';
end