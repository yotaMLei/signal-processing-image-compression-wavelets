function [th_details, zero_count] = remove_coeffs(details, thresh)
% Q8
% this function sets to zero all the details coefficients with absolute value smaller
% or equal to thresh (AND is not equal to zero)

level = length(details);
th_details = details;
zero_count = 0;

for i = 1:level
    % zero the coeeficient if its absolute value smaller or equal to thresh AND it's not
    % equal to zero (numbers smaller than 1e-10 we treat as zero)
    zero_ind = (abs(details{i}) <= thresh) & (abs(details{i}) > 1e-10);
    th_details{i}(zero_ind) = 0;
    zero_count = zero_count + sum(zero_ind);
end

end

