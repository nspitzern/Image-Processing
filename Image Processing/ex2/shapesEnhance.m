function [eImg, nImg] = shapesEnhance(img)
%
% we use myMedian filter of size 3x3. 
if isa(img, 'double') == false
    img = double(img)/255;
end
[rows, cols] = size(img);
m = [1,0,0,0,1;1,0,0,0,1;0,1,0,1,0;0,1,0,1,0;0,0,1,0,0];
% create the mask
mask = zeros(rows, cols);
% noise the mask
mask = imnoise(mask, 'salt & pepper', 0.003);
% make shapes in the mask
mask = conv2(mask, m, 'same');
mask = min(mask, 1);
% create noised image
nImg = max(mask, img);
% create enhanced image 
eImg = myMedian(nImg, 3, 3);
end

