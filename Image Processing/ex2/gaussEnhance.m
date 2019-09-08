function [eImg, nImg] = gaussEnhance (img)
%
% the function uses 9 filters:
% three of the filters are myMedian filter of square sizes 3,5 and 7.
% we used vertical and horizontal masks to highlight the enterance of the
% house, and the sky.
% we also used diagonal filters to highlight the house roof (both
% directions).
% we used 2 average filters of square sizes 5 and 7 to give the pixel's
% surrounding a role in the pixel value (give it more volume).
[rows, cols] = size(img);
mean = 0;
var = 0.004;
% apply noise to the image
nImg = imnoise(img, 'gaussian', mean, var);
% create masks
mask1=conv2(nImg,eye(7) / 7,'same');
mask2=conv2(nImg,ones(7,1)/7,'same');
mask3=conv2(nImg,ones(1,9) / 9,'same');
mask4=conv2(nImg,flipud(eye(7)) / 7,'same');
mask5 = myMedian(nImg, 3, 3);
mask6=conv2(nImg, ones(9,1) / 9,'same');
mask7=conv2(nImg,eye(5)/5,'same');
mask8 = myMedian(nImg, 5, 5);
mask9 = myMedian(nImg, 7, 7);
eImg = zeros(rows, cols);
% go over the picture and apply the best filter for each pixel
for r = 1 : rows
    for c = 1 : cols
        % create masks array
        convArr = [mask1(r, c), mask2(r, c),mask3(r, c),mask4(r, c),mask5(r, c),mask6(r, c),mask7(r, c),mask8(r, c),mask9(r, c)];
        % create error array
        errArr = abs(convArr - nImg(r, c));
        % choose the minimum error
        [bestVal, bestIndex] = min(errArr);
        eImg(r, c) = convArr(bestIndex);
    end
end
end