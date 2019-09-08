function [circles,cImg] = findCircles(img)

% get the edges of the circles
[edgeImg, tgTeta] = edgeDetect(img);
[rows, cols] = size(img);
max_R = floor(sqrt(rows^2 + cols^2));
tgTeta = -tgTeta;
count = getCountCirclesMat(edgeImg, max_R, tgTeta, rows, cols);
T = 70;
% initialize the circles matrix
circles = [];
for rad = 5 : max_R - 4
    for r = 5 : rows - 3
        for c = 5 : cols - 3
            if count(r, c, rad) > T
                if NMS(count, r, c, rad)
                    circles = [circles ; [r, c, rad]];
                end
            end
        end
    end
end
% create cImg
cImg = zeros(rows, cols, 3);
cImg(:, :, 1) = img;
cImg(:, :, 2) = img;
cImg(:, :, 3) = img;
cImg = printCircles(circles, img, cImg);
end

function [count] = getCountCirclesMat(edgeImg, max_R, tgTeta, rows, cols)
% the function returns the counting matrix of circles.
% For each edge point we count all the possible circle centers of each
% radius.

% initialize circle counter matrix
count = zeros(rows, cols, max_R);
for r = 1 : rows
    for c = 1 : cols
        % check if the current pixel is edge pixel on the pixel edge image
        if edgeImg(r, c) == 1
            % calculate for each circle center the radius of the circle and
            % count +1 for that center
            for center_y = 1 : rows
                for center_x = 1 : cols
                    radius = round(sqrt((center_x - c)^2 + (center_y - r)^2));
                    if radius <= max_R && radius >= 1
                        % add 1 to all pixels of the current circle
                        count(center_y, center_x, radius) = count(center_y, center_x, radius) + 1;
                    end
                end
            end
        end
    end
end
end

function [bool] = NMS(count, r, c, rad)
    % check if the current count is the max count of all neighbors.
    bool = false;
    if count(r, c, rad) == max(max(max(count(r - 2:r + 2, c - 2:c + 2, rad - 4:rad + 4))))
        bool = true;
    end
end

function [cImg] = printCircles(circles, img, cImg)
% get circles number
[rows, cols] = size(img);
num_circles = size(circles, 1);
for c = 1 : num_circles
    % get center x of current circle
    origin_x = circles(c, 1);
    % get center y of current circle
    origin_y = circles(c, 2);
    % get radius of current circle
    radius = circles(c, 3);
    fprintf('Circle %d: %d, %d, %d\n', c, origin_x, origin_y, radius);
end
% print the circles on the picture 
for r = 1 : rows
    for c = 1 : cols
        for n = 1 : num_circles
            center_y = circles(n, 1);
            center_x = circles(n, 2);
            rad = circles(n, 3);
            new_rad = round(sqrt((center_x - c).^2 + (center_y - r).^2));
            % check if the pixel is on the circle
            if new_rad == rad
                cImg(r, c, 1:3) = [1, 0, 0];
            end
        end
    end
end
end