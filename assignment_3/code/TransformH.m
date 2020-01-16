function H = TransformH(img1_points,img2_points)
    N = length(img1_points);
    % Setting the P matrix 2Nx9
    P = [img1_points(1:N,:),ones(N,1),zeros(N,3),...
        -1*img2_points(1:N,1).*img1_points(1:N,:),...
        -1*img2_points(1:N,1);...
        zeros(N,3),-1*img1_points(1:N,:),-1*ones(N,1),...
        img2_points(1:N,2).*img1_points(1:N,:),...
        img2_points(1:N,2)];
    % SVD Decomposition
    [~,S,V] = svd(P);
    sigmas = diag(S);
    
    % Detecting minimum diagonal element
    if length(sigmas) >= 9
        minSigma = min(sigmas);
        [~,minCol] = find(S==minSigma);
        q = double(vpa(V(:,minCol)));
    elseif length(sigmas)<9
        q = double(vpa(V(:,9)));
    end
    % reshape the smallest eigen value
    H = reshape(q,[3,3])';
end
