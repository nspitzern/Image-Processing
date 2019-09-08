function [newImg, tgTeta] = edgeDetect(img) 

% smooth the image
img = conv2(img, [1 2 1; 2 4 2; 1 2 1]./16, 'same');
[rows, cols] = size(img);
newImg = zeros(size(img));
% calculate gradiant
sx = conv2(img, [-1, 0, 1; -2, 0, 2; -1, 0, 1], 'same');
sy = conv2(img, [1, 2, 1; 0, 0, 0; -1, -2, -1], 'same');
s = sqrt(sx.^2 + sy.^2);
TH = 1.3;
TL = 0.1;
sx(sx == 0) = 0.0001;
tgTeta = (sy./sx);
% apply NMS to get edges of the circles
temp = applyEdges(s, tgTeta, newImg, rows, cols);
for r = 1 : rows
    for c = 1 : cols
        T = getThreshold(TL, TH, r, c, newImg);
        if temp(r, c) > T
            newImg(r, c) = 1;
        else
            newImg(r, c) = 0;
        end
    end
end

for r = rows : -1 : 1
    for c = cols : -1 : 1
        T = getThreshold(TL, TH, r, c, newImg);
        if temp(r, c) > T
            newImg(r, c) = 1;
        else
            newImg(r, c) = 0;
        end
    end
end

for r = rows : -1 : 1
    for c = 1 : cols
        T = getThreshold(TL, TH, r, c, newImg);
        if temp(r, c) > T
            newImg(r, c) = 1;
        else
            newImg(r, c) = 0;
        end
    end
end

for r = 1 : rows
    for c = cols : -1 : 1
        T = getThreshold(TL, TH, r, c, newImg);
        if temp(r, c) > T
            newImg(r, c) = 1;
        else
            newImg(r, c) = 0;
        end
    end
end
end

function [newImg] = applyEdges(s, tgTeta, newImg, rows, cols)
% call NMS over the image 2 times
for r = 1 : rows
    for c = 1 : cols
        newImg = NMS(s, tgTeta, newImg, r, c);
    end
end
% 
% for r = rows : -1 : 1
%     for c = cols : -1 : 1
%         newImg = NMS(s, tgTeta, newImg, r, c);
%     end
% end
end

function [newImg] = NMS(s, tgTeta, newImg, r, c)
    % check first case - neighbors: left and right
    if -0.4142 <= tgTeta(r, c) && tgTeta(r, c) <= 0.4142
        if checkNeighbors([r, c - 1], [r, c + 1], [r, c], s)
            newImg(r, c) = s(r, c);
        else
            newImg(r, c) = 0;
        end
    % check second case - neighbors: lower left and upper right
    elseif 0.4142 < tgTeta(r, c) && tgTeta(r, c) <= 2.4142
        if checkNeighbors([r + 1, c - 1], [r - 1, c + 1], [r, c], s)
            newImg(r, c) = s(r, c);
        else
            newImg(r, c) = 0;
        end
    % check third case - neighbors: up and down
    elseif 2.4142 < abs(tgTeta(r, c))
        if checkNeighbors([r - 1, c], [r + 1, c], [r, c], s)
            newImg(r, c) = s(r, c);
        else
            newImg(r, c) = 0;
        end
    % check fourth case - neighbors: upper left and lower right
    elseif -2.4142 <= tgTeta(r, c) && tgTeta(r, c) < -0.4142
        if checkNeighbors([r - 1, c - 1], [r + 1, c + 1], [r, c], s)
            newImg(r, c) = s(r, c);
        else
            newImg(r, c) = 0;
        end
    end
end

function [validity] = validLocation(i, j, mat)
% check if the location of a given cell is valid
    validity = true;
    [rows, cols] = size(mat);
    if i < 1 || j < 1
        validity = false;
    elseif i > rows || j > cols
        validity = false;
    end
end

function [greater] = checkNeighbors(neighbor1, neighbor2, current, mat)
% check if current cell's value is bigger than its neighbors - if it is
% return true, else return false
    greater = true;
    % check validity for first neighbor
    if validLocation(neighbor1(1), neighbor1(2), mat)
        % check if current cell is bigger
        if mat(current(1), current(2)) < mat(neighbor1(1), neighbor1(2))
            greater = false;
        end
    end
    % check validity for second neighbor
    if validLocation(neighbor2(1), neighbor2(2), mat)
        % check if current cell is bigger
        if mat(current(1), current(2)) < mat(neighbor2(1), neighbor2(2))
            greater = false;
        end
    end
end

function [T] = getThreshold(TL, TH, r, c, edgeImg)
% % the function returns the proper threshold for a given cell
    neighbors = getNeighbors(r, c, edgeImg);
    check = false;
    
    % check if one of the neighbors is edge
    for i = 1 : size(neighbors, 1)
        if edgeImg(neighbors(i, 1), neighbors(i, 2)) == 1
            check = true;
        end
    end
    if ~check
        % if I don't have an edge neighbor
        T = TH;
    else
        % if I have an edge neighbor
        T = TL;
    end
end

function [n] = getNeighbors(i, j, mat)
    % the function returns a vector of all valid neighbors for a given cell
    n = [];
    % make vector of all neighbrs
    m = [i + 1, j];
    m = [m; i + 1, j + 1];
    m = [m; i + 1, j - 1];
    m = [m; i - 1, j];
    m = [m; i - 1, j - 1];
    m = [m; i - 1, j + 1];
    m = [m; i, j + 1];
    m = [m; i, j - 1];
    % filter unvalid neighbors
    for i = 1 : size(m)
        if validLocation(m(i, 1), m(i, 2), mat)
            n = [n; m(i,:)];
        end
    end
end