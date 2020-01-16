function [index1, index2] = siftMatch(descpt1, descpt2, num)
% Function: Match the SIFT descriptors between two images
%       index1 - indices of the matched features in the first set
%       index2 - indices of the matched features in the second set
%       num - number of valid matches
%       descpt1 - first descriptor set
%       descpt2 - second descriptor set
num1 = size(descpt1, 1);
num2 = size(descpt2, 1);
% Number of valid matches
nmatch = 0;
% Ratio for non-maximum suppression
r = 0.8;
% bhattacharyya co-efficient between one feature and the entire second feature set
dis = zeros(1, num2);
% Smallest bhattacharyya co-efficient between two features in each feature set
min_dis = zeros(1, num1);

% Compute bhattacharyya co-efficient
for i = 1: num1
    for j = 1: num2
        histogram1 = descpt1(i, 4:39)/sum(descpt1(i, 4:39));
        histogram2 = descpt2(j, 4:39)/sum(descpt2(j, 4:39));
        dis(j) = bhattacharyya(histogram1, histogram2);
    end
    [dis, ind_min] = sort(dis);
    min_dis(i) = dis(1);        % save the smallest distance for comparison
    if (dis(1) < r * dis(2))
        nmatch = nmatch + 1;    % one more valid match
        ind1(nmatch) = i;       % add the index of the matched feature
        ind2(nmatch) = ind_min(1);
    end
end
% Keep only the valid matches
ind1 = ind1(1: nmatch);
ind2 = ind2(1: nmatch);

% Valid matches fewer than required
if (nmatch < num)
    fprintf('There are only %d valid matches.\n', nmatch);
    % Return all valid matches
    index1 = ind1;
    index2 = ind2;
% Valid matches more than required
else
    % bhattacharyya co-efficient for valid matches
    val_dis = min_dis(ind1);
    % Get the index of distance for valid matches sorted ascendingly
    [~, ind_dis] = sort(val_dis);
    % Return the index of best [num] matches
    index1 = ind1(ind_dis(1: num));
    index2 = ind2(ind_dis(1: num));
end
end

