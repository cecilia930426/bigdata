function extrema = getExtrema(A, thresh)
%   A is a cell  
%   A{level}(:,:,1) DoG of level-1, A{level}(:,:,2) DoG of level, A{level}(:,:,3) DoG of level+1
extrema = [];
octave = size(A, 2);
for sigma = 1:octave
    [height, width, ~]=size(A{sigma});
    for row = 2:height-1
        for col = 2:width-1
            center = A{sigma}(row, col,2);
%             if center < thresh
%                 continue;
%             end
            A{sigma}(row, col, 2) = A{sigma}(row, col-1, 2);
            compare = A{sigma}(row-1:row+1, col-1:col+1,:);
            maxValue = max(compare(:));
            minValue = min(compare(:));
            if center < minValue - thresh
                extrema = [extrema;[row, col, 2^sigma]];
            end
            if center > maxValue + thresh
                extrema = [extrema;[row, col, 2^sigma]];
            end
            A{sigma}(row, col, 2) = center;
        end
    end
end

