function result = getGaussKernel(sigma, Radius)
% Returns a gaussian kernet
% Calculating Gaussian value given Sigma
% By default a radius will be chosen to so kernel covers 99.7 % of data.
    if nargin < 2
        Radius = ceil(3*sigma);
    end
    side = 2*Radius+1;
    result = zeros(side);
    for i = 1:side
        for j = 1:side
            x = i-(Radius+1);
            y = j-(Radius+1);
            result(i,j)=(x^2+y^2)^0.5;
        end
    end
    result = exp(-(result .^ 2) / (2 * sigma * sigma));
    result = result / sum(result(:));
end
