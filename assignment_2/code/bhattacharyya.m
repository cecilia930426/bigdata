function bdist = bhattacharyya(histogram1, histogram2)
    % get number of bins 
    bins = size(histogram1, 2);
    % caculate bhattacharyya co-efficient 
    bcoeff = 0;
    for i=1:bins
        bcoeff = bcoeff + sqrt(histogram1(i) * histogram2(i));
    end
    % get the distance between the two distributions 
    bdist = sqrt(1 - bcoeff);
end