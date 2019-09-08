function [newimg] = histShape(srcimg, destimg)

[srcRow, srcCol] = size(srcimg);
[destRow, destCol] = size(destimg);
% create the histograms
srchist = createHist(srcimg);
desthist = createHist(destimg);

% calculate accumulative histograms
Asrchist = accumulateHist(srchist);
Adesthist = accumulateHist(desthist);
% normalize the accumulated histograms
NAsrchist = Asrchist/(srcRow * srcCol);
NAdesthist = Adesthist/(destRow * destCol);

% create a conversion vector
CV = createConversionVector(NAsrchist, NAdesthist);
% replace the pixels in the new image, according to the conversion vector.
newimg = srcimg;
for r = 1:srcRow
    for c = 1:srcCol
        newimg(r,c) = (CV(srcimg(r,c)+1));
    end
end
end

function [hist] = createHist(srcimg)
% This function extracts a histogram from an image
%i = imread(srcimg);
i = srcimg;
% get the sizes of srcimg
[rows, cols] = size(srcimg);
% create matrix of zeros 1X256
hist = zeros(1,256);
for r = 1:rows
    for c = 1:cols
        % for each color we count the number of pixels in said color.
        % equals to hist[i]++
        hist(i(r,c)+1) = hist(i(r,c)+1)+1;
    end
end
end

function [Ahist] = accumulateHist(hist)
% The function calculates the histogram's accumulative histogram.
Ahist = hist;
for color = 2:256
    Ahist(color) = Ahist(color - 1) + hist(color);
end
end

function [CV] = createConversionVector(Nsrchist, Ndesthist)
% The function gets 2 normalized accumulative histograms and creates a
% conversion vector from them.
CV = zeros(1, 256);
s = 1;
d = 1;
while s <= 256
    if Nsrchist(s) <= Ndesthist(d)
        CV(s) = d + 1;
        s = s + 1;
    else
        d = d + 1;
    end
end
end