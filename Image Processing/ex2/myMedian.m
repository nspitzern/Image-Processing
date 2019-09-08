function [newImg] = myMedian(img, rows, cols)

newImg = img;
%newImg = zeros(size(img));
% get the size of the image
[imgRows, imgCols] = size(img);
for i = 1:1:(imgRows - rows)
    for j = 1:1:(imgCols - cols)
        % get the median of the image in the borders of the filter
        median = myMedianCalc(img(i:1:i + rows - 1, j:1:j+cols - 1));
        % put the median value in the center of the filter
        newImg(i + floor(rows/2), j + floor(cols/2)) = median;
    end
end
end


% %%newImg = img;
% % get the size of the image
% [imgRows, imgCols] = size(img);
% newSrc = zeros(floor(rows/2) + imgRows + floor(rows/2), floor(cols/2) + imgCols + floor(cols/2));
% newSrc(floor(rows/2) + 1:1:imgRows + floor(rows/2), floor(cols/2) + 1:1: imgCols + floor(cols/2)) = img;
% newDst = zeros(floor(rows/2) + imgRows + floor(rows/2), floor(cols/2) + imgCols + floor(cols/2));
% newDts(floor(rows/2) + 1:1:imgRows + floor(rows/2), floor(cols/2) + 1:1: imgCols + floor(cols/2)) = img;
% %%for i = 1:1:(imgRows - rows)
%   %%  for j = 1:1:(imgCols - cols)
% for i = floor(rows/2)+1:1:imgRows 
%     for j = floor(cols/2) + 1:1:imgCols
%         % get the median of the image in the borders of the filter
%         %%median = myMedianCalc(img(i:1:i + rows - 1, j:1:j+cols - 1));
%         median = myMedianCalc(newSrc(i:1:i + rows - 1, j:1:j+cols - 1));
%         % put the median value in the center of the filter
%         %%newImg(i + floor(rows/2), j + floor(cols/2)) = median;
%         newDst(i + floor(rows/2), j + floor(cols/2)) = median;
%     end
% end
% newDst = newDst(floor(rows/2) + 1:1:imgRows + floor(rows/2), floor(cols/2) + 1:1: imgCols + floor(cols/2));
% newDst = uint8(newDst);
% end

function [calc] = myMedianCalc(A)
   % This function calculates the median of a given matrix
   
   % convert matrix to vector
   myVect = A(:);
   % sort the vector
   myVect = sort(myVect);
   % get the size of the vector
   mySize = size(myVect, 1);
   % return the median
   calc = myVect(floor(mySize/2));
end