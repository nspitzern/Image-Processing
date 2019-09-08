function nImg = createTiledImage(bigImage, smallImage)

% create the new Image
nImg = zeros(size(bigImage));
[rows, cols] = size(bigImage);
[smallRows, smallCols] = size(smallImage);

% get number of tiles
rIndex = rows / smallRows;
cIndex = cols / smallCols;

for r = 1 : rIndex
    for c = 1 : cIndex
        % cut a part of the big image in the size of small image
        changeArea = bigImage(((r - 1) * smallRows) + 1 : (r * smallRows), ((c - 1) * smallCols) + 1 : (c * smallCols));
        % equal the histogram of the small area to the histogram of the cut
        % area
        newArea = histShape(smallImage, changeArea);
        nImg(((r - 1) * smallRows) + 1 : (r * smallRows), ((c - 1) * smallCols) + 1 : (c * smallCols)) = newArea;
    end
end
nImg = uint8(nImg);
end