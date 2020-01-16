function transformedPoints = transformBack(img_points,H)
    iH=inv(H);
    transformedPoints = [(iH(1,1:2)*img_points'+iH(1,3))./(iH(3,1:2)*img_points'+iH(3,3));...
        (iH(2,1:2)*img_points'+iH(2,3))./(iH(3,1:2)*img_points'+iH(3,3))]';
end

