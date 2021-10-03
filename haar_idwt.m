function [ signal ] = haar_idwt(approx, details)
% Q6
% this function implements inverse 1D haar wavelet transform up to the given level

% define the Haar wavelet "mother wavelet" (psi) and scaling function (phi)
% coefficients
g = 1/sqrt(2)*[1 -1]; % W0 psi coefficients
h = 1/sqrt(2)*[1 1]; % V0 phi coefficients

% level is given in details length
level = length(details);

% according to the instructions we compute c(i) = (a(i)?2)*g +(b(i)?2)*h, while
% a(i) = details of the i-th level, b(i) = approx of the i-th level, c(i)=
% the approx of the signal for the i-1 level [each iteration we set c(i) = b(i-1) i=i-1]
c = approx;

% iterate from the last level to level 1
for i = level:-1:1
    
    % each level the approx length grows by power of 2 
    %[length{approx(i)} = 2*length{approx(i+1)}]
    n = 2*length(c);

    %  a = detail of the i-th level
    a = details{i};
    
    % upsample a by factor 2
    a_up = zeros(1, n);
    a_up(1:2:end) = a;
    
    %  b = approx of the i-th level [equals c(i+1)]
    b = c;
    
    % upsample b by factor 2
    b_up = zeros(1, n);
    b_up(1:2:end) = b;
    
    % compute c(i) = (a(i)?2)*g +(b(i)?2)*h
    c = cconv(a_up, g, n) + cconv(b_up, h, n);
end

    % stop when we reach level 1 [ c(level 1) = approx of the original
    % signal]
    signal = c;
    
end

