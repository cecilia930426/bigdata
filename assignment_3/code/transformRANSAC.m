function [A_ransac,im1InlierCorrPts,im2InlierCorrPts] = transformRANSAC(img1_points,img2_points)
    % Intialization
    N_pts = length(img1_points);  % total number of points
    k = 5;       %number of correspondences
    e = 0.5;     %outlier ratio = number of outliers/total number points
                 %              = 1- number of inliers/total number of points
    p = 0.99; % probability that a point is an inlier
    N_iter = round(log10(1-p)/log10(1-(1-e)^k)); % number of iterations
    %distThreshold = sqrt(5.99*sigma) %sigma = expected uncertainty
    %inlierThreshold = 0
    
    % Determination of Inliers
    im1InlierCorrPts = [];
    im2InlierCorrPts = [];
    nmatchedInliers = 0;
    maxMatchedInliers = 0;
    for i = 1:N_iter
        % Random sample
        randIndexes = randi(N_pts,5,1);
        im1pts = img1_points(randIndexes,:);
        im2pts = img2_points(randIndexes,:);
        
        % Homography Matrix estimation
        H = TransformH(im1pts,im2pts);
        % Forward Transformation Error
        im1ptsFor = transformFor(img1_points,H);
        errorForward = sum((im1ptsFor-img2_points).^2,2).^0.5;
        totalForwardError = sum(errorForward);
        % Backward Transformation Error
        im2ptsBack = transformBack(img2_points,H);
        errorBackward = sum((im2ptsBack-img1_points).^2,2).^0.5;
        totalBackwardError = sum(errorBackward);
        % Total Geometric Error
        totalError = totalForwardError + totalBackwardError;
        
        % Expected Error Distribution Std Dev
        sigma = sqrt(totalError/(2*N_pts));
%         distThreshold = sqrt(5.99)*sigma;
%         distThreshold = sqrt(sigma);
        distThreshold = 10;
        % Determining number of inliers
        logic1Inlier = errorForward<distThreshold;
        logic2Inlier = errorBackward<distThreshold;
        im1Inliers = logic1Inlier.*img1_points;
        im2Inliers = logic2Inlier.*img2_points;
        matchedInliers = im1Inliers(:,1)>0 & im2Inliers(:,1)>0; 
        nMatchedInliers = nnz(matchedInliers); 
        im1MatchedInliers = im1Inliers(matchedInliers,:); 
        im2MatchedInliers = im2Inliers(matchedInliers,:); 
        % Updating Prarameters
        if nMatchedInliers > maxMatchedInliers
            e = (1-nMatchedInliers/N_pts);
            N_iter = round(log10(1-p)/log10(1-(1-e)^k));
            im1InlierCorrPts = im1MatchedInliers;
            im2InlierCorrPts = im2MatchedInliers;
            maxMatchedInliers = nMatchedInliers;
            A_ransac_best = H;
        end 
    end
    % Final Homography Estimation
    A_ransac = TransformH(im1InlierCorrPts,im2InlierCorrPts);
%     A_ransac = A_ransac/sum(A_ransac(:));
end
