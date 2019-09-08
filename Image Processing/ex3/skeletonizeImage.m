function [newImg] = skeletonizeImage(img)

[rows, cols] = size(img);
% get the distance matrix
distImg = getDistanceImg(img);
newImg = zeros(rows, cols);
% get the seleton
newImg = setSkeleton(distImg, newImg, rows, cols);
end

function [newImg] = getDistanceImg(img)
% the function creates the matrix of distances
[rows, cols] = size(img);
newImg = img;
% when we don't change pixels anymore changeFlag will be false and we stop
% iterating.
changeFlag = 1;
iter_num = 1;
while not (changeFlag == 0)
    % initialize params
    changeFlag = 0;
    % go over the picture
    for r  = 1 : 1 : rows
        for c = 1 : 1 : cols
            % check if the cuurent pixel equals i
            if not (newImg(r, c) == iter_num)
                continue
            end
            % initialize neighbours checkers
            changeLeft = 1;
            changeRight = 1;
            changeUp = 1;
            changeDown = 1;
            
            if r > 1
            % check up
                if not(newImg(r - 1,c) == iter_num)
                    changeUp = 0;
                end
            end
            if r < rows
                % check down
                if not(newImg(r + 1, c) == iter_num)
                    changeDown = 0;
                end
            end
            if c > 1
                % check left
                if not(newImg(r, c - 1) == iter_num)
                    changeLeft = 0;
                end
            end
            if c < cols
                % check right
                if not(newImg(r, c + 1) == iter_num)
                    changeRight = 0;
                end
            end
            % check if all 4 neighboors equal to i
            if (changeLeft == 1 && changeRight == 1 && changeUp == 1 && changeDown == 1)
                newImg(r, c) = newImg(r, c) + 1;
                changeFlag = 1;
            end
        end
    end
    iter_num = iter_num + 1;
end
end

function [newImg] = setSkeleton(img, newImg, rows, cols)
% the function sets the skeleton according to the disctance image
    for r  = 1 : 1 : rows
        for c = 1 : 1 : cols
            % initialize neighbours checkers
            checkLeft = 1;
            checkRight = 1;
            checkUp = 1;
            checkDown = 1;
            if r > 1
            % check up
                if not(img(r - 1,c) <= img(r, c))
                    checkUp = 0;
                end
            end
            if r < rows
                % check down
                if not(img(r + 1, c) <= img(r, c))
                    checkDown = 0;
                end
            end
            if c > 1
                % check left
                if not(img(r, c - 1) <= img(r, c))
                    checkLeft = 0;
                end
            end
            if c < cols
                % check right
                if not(img(r, c + 1) <= img(r, c))
                    checkRight = 0;
                end
            end
            % check if all 4 neighboors equal to i and the pixel is not
            % background
            if(checkLeft == 1 && checkRight == 1 && checkUp == 1 && checkDown == 1 && img(r,c)~=0)
                newImg(r, c) =  1;
            end
        end
    end
end