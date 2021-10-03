function [synth] = haar_image_idwt(wt, level)
% Q15
% this function synthesizes an image from a given haar wavelet transform wt
% of a given level.
% the 2D inverse haar wavelet transform of level 3 is done by first
% selecting the bottom left 1/64 part of the wavelet transform and then
% applying the level 1 1D idwt on the columns and then on the rows of the result
% (size is incresed by factor of 4). second is applying the 1D level 1 idwt
% in the same way on the bottom left quarter of the wavelet tranform (size 
% is increased by a total factor of 16). the last stage is applying the 1D level 1
% idwt in the same way on the bottom left quarter of the result of 
% the second stage (size is increased by a total factor of 64).



[n_rows, n_cols] = size(wt);

% intialize the synthesized image
synth = zeros(n_rows, n_cols);

tmp_wt = wt;
details = cell(1);

% iterate over the wavelet transform untill reaching level 1
for j=level:-1:1

% select the bottom left 1/64 part of the wavelet transform 
% (according to the level 3)   
index_rows_1 = n_rows - n_rows/(2^(j-1));
index_rows_2 = n_rows - n_rows/(2^j);
index_columns_1 = n_cols/(2^j);
index_columns_2 = n_cols/(2^(j-1));    
     
    % applying the 1D level 1 idwt on the columns
    for i=1:index_columns_2
        % select the approx in the bottom half of the column
        approx = tmp_wt((index_rows_2 + 1):n_rows,i);
        % select the details in the upper half of the column
        details{1} = tmp_wt((index_rows_1 + 1):index_rows_2,i);
        % perform 1D level 1 idwt with the approx and details and
        % update the matching column on the synthesized image
        synth((index_rows_1 + 1):n_rows, i) = haar_idwt(approx, details);
    end
    
    % applying the 1D level 1 idwt on the rows of the result
    for i=1:(n_rows - index_rows_1)
        % select the approx in the left half of the row
        approx = synth(index_rows_1 + i ,1:index_columns_1);
        % select the details in the right half of the row
        details{1} = synth(index_rows_1 + i ,(index_columns_1+1):index_columns_2);
        % perform 1D level 1 idwt with the approx and details and
        % update the matching row on the synthesized image
        synth(index_rows_1 + i, 1:index_columns_2) = haar_idwt(approx, details);
    end

   

% place the synthesized image at the bottom left part (1/16 or 1/4 according to the
% level) of the wavelet transform and continue to the next iteration
tmp_wt((index_rows_1 + 1):n_rows, 1:index_columns_2) = synth((index_rows_1 + 1):n_rows, 1:index_columns_2);

end