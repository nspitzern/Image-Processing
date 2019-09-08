function [newImg] =  tagConnectedComponents(img)

[rows, cols] = size(img);
newImg = zeros(rows, cols);
equals = [];
% initialize label number
label = 1;
% go over the image
for r = 1 : 1 : rows
    for c = 1 : 1 : cols
        % check if the current pixel is object pixel
        if img(r, c) == 1
            neighbours_count = [0, 0];
            if r > 1
                % check up
                if img(r - 1, c) == 1
                    neighbours_count(1) = 1;
                end
            end
            if c > 1
                % check left
                if img(r, c - 1) == 1
                    neighbours_count(2) = 1;
                end
            end
            % in case has 2 neighbours
            if sum(neighbours_count) == 2
                % check if both neighbours are not equal
                if not (newImg(r - 1, c) == newImg(r, c - 1))
                    equals = [equals; [newImg(r - 1, c), newImg(r, c - 1)]];
                end
                newImg(r, c) = newImg(r, c - 1);
            
            % in case of only one neighbour
            elseif sum(neighbours_count) == 1
                if neighbours_count(1) == 1
                    newImg(r, c) = newImg(r - 1, c);
                else
                     newImg(r, c) = newImg(r, c - 1);
                end
            % in case there are no neighbours
            else
                newImg(r, c) = label;
                label = label + 1;
            end
        end
    end
end
nMatrix = buildNeighbourMatrix(label, equals);
cv = createCV(nMatrix);
newImg = applyConnectedComponent(newImg, cv);
end

function [neighbourMatrix] = buildNeighbourMatrix(label, equals)
% the function builds the neighbours matrix
    neighbourMatrix = zeros(label, label);
    % initailize diag of matrix
    for i = 1 : label
        neighbourMatrix(i, i) = 1;
    end
    for i = 1 : 1 : size(equals, 1)
        couple = equals(i,:);
        neighbourMatrix(couple(1), couple(2)) = 1;
        neighbourMatrix(couple(2), couple(1)) = 1;
    end
end

function [cv] = createCV(nMat)
% the function creates the conversion vector
originMat = zeros(size(nMat));
tempMat = nMat;
while not (isequal(tempMat, originMat))
    % square the matrix
    originMat = tempMat;
    sqrMat = tempMat*tempMat;
    tempMat = min(sqrMat, 1);
end
cv = tempMat(1, :);
l = 2;
n = size(nMat, 1);
for i = 2 : n
    % find the index of the first zero in cv
    %zeroIndex = find(a==0, 1, 'first');
    if(cv(i) == 0)
        cv = cv + tempMat(i, :) * l;
        l = l + 1;
    end
end
end

function [resMat] = applyConnectedComponent(mat, cv)
% the function applies the conversion vector on the image
[rows, cols] = size(mat);
resMat = zeros(size(mat));
for r = 1 : 1 : rows
    for c = 1 : 1 : cols
        if not (mat(r, c) == 0)
            resMat(r, c) = cv(mat(r, c));
        end
    end
end
end