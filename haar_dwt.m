function [ approx, details ] = haar_dwt( signal, level )
% Q4
% this function implements 1D haar wavelet transform up to the given level

% make sure signal is a row vector
signal = signal(:).';

% define the Haar wavelet "mother wavelet" (psi) and scaling function (phi)
% coefficients
g = 1/sqrt(2)*[1 -1]; % W0 psi coefficients
h = 1/sqrt(2)*[1 1]; % V0 phi coefficients

% initial values for approximation and detalils 
approx = signal;
details = cell(1,level);

% iterate untill reaching the given level
for i = 1:level
    n = length(approx); %length of the cyclic convolution

    % calculate approx{i-1} * g[-n] and then downsample by 2 to get details{i} 
    f_g = cconv(approx, wrev(g), n);
    % The first element of cconv(f,wrev(g)) = f[n]g[0] + f[0]g[1] is
    % different from the theoretical calculations. In the theory the first element of 
    % the convolution (f*g[-n]) = f[0]g[0] + f[1]g[1] and the last
    % element is f[n]g[0] + f[0]g[1]. therefore we need to shift the
    % downsample by 1 so we take indexes 2,4,6,8,...
    details{i} = f_g(2:2:end);
    
    % calculate approx{i-1} * h[-n] and then downsample by 2 to get approx{i} 
    f_h = cconv(approx, wrev(h), n);
    approx = f_h(2:2:end);
end

end

