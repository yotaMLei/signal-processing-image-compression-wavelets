function [ wt ] = haar_image_dwt(image, level)
% Q13
% this function computes the haar wavelet transform of a given image on the rows
% and the columns up to the given level.
% the 2D haar wavelet transform up to level 3 is done by first applying
% 1D level 1 dwt on the rows and then on the columns. second is applying 
% the 1D level 1 dwt in the same way on the bottom left quarter of the result
% (size is smaller by factor 4). the last step is applying the 1D level 1 dwt in the
% same way on the bottom left quarter of the result of the second stage (size is smaller by factor 8).

[n_rows, n_cols] = size(image);
% initialize the wavelet transform size
wt = zeros(n_rows, n_cols);

index_rows = 0;
index_columns = n_cols;
tmp_image = image;

% iterate on the image until the desired level
for j=1:level

    % applying the 1D level 1 dwt on the rows
    for i=1:(n_rows - index_rows)
        [approx, details] = haar_dwt(tmp_image(i,:), 1);
        % update the matching row on the wavelet transform image (wt) and
        % place the approx at the left half of the row and the details at
        % the right half of the row
        wt(index_rows + i, 1:index_columns) = cat(2, approx, details{1});
    end

    % applying the 1D level 1 dwt on the columns of the result (wt)
    for i=1:index_columns
        [approx, details] = haar_dwt(wt((index_rows+1):n_rows, i), 1);
        % update the matching column on the wavelet transform image (wt) and
        % place the approx at the bottom half of the column and the details
        % at top half of the column
        wt((index_rows+1):n_rows, i) = cat(2, details{1}, approx);
    end

% update index_rows and index_columns to select the bottom left quarter 
% of the result. each iteration the number of rows and columns is reduced 
% by factor of 2
index_rows = n_rows - n_rows/(2^j);
index_columns = n_cols/(2^j);

% update tmp_image to the bottom left quarter of the result and continue 
% to the next iteration
tmp_image = wt(index_rows+1:end, 1:index_columns);

end

