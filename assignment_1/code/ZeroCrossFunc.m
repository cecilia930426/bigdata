function output = ZeroCrossFunc(LoG, threshold)
% LoG is the Convolve the 2D Laplacian of Gaussian filters with the input images
% threshold is the boundary we set 
ABS = abs(LoG);
thres = mean(ABS(:)) * threshold;
output = zeros(size(LoG));
[h, w] = size(LoG);
for y = 2:1:(h-1)
    for x = 2:1:(w-1)
        patch = LoG(y-1:y+1, x-1:x+1);
        p=LoG(y,x);
        maxP = max(patch(:));
        minP = min(patch(:));
        if p>0
            if minP < 0
                zeroCross = true;
            else
                zeroCross = false;
            end
        else
            if maxP > 0
                zeroCross = true;
            else
                zeroCross = false;
            end
        end
        if((maxP - minP) > thres) && zeroCross
            output(y, x) = 1;
        end
    end
end
end