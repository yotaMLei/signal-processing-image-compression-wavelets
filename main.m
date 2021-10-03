%% Main code
clc;
close all;
clear all;

%% Q1

f = [0, 1, 2, 1, 0, -1, -2, 1, 1, 5, 5, 3, 2, 3, 3, 3];

% stem plot of the signal f
figure(1);
stem(f);
title('Q1 Original signal');

%% Q5

% apply level 3 dwt on f
[approx, details] = haar_dwt(f, 3);

% plot approx and details of level 1,2,3
figure(2);
subplot(2,2,1);
stem(approx);
title('Q2 Level 3 approximation');
axis ([0 8 -3 9])

subplot(2,2,2);
stem(details{1});
title('Level 1 details');
axis ([0 8 -3 3])

subplot(2,2,3);
stem(details{2});
title('Level 2 details');
axis ([0 8 -3 3])

subplot(2,2,4);
stem(details{3});
title('Level 3 details');
axis ([0 8 -3 3])

%% Q7

% plot reconstructed signal f with idwt from the approx and details
f_rec1 = haar_idwt(approx, details);
figure(3);
stem(f_rec1);
title('Q7 Reconstructed signal');

% compute squared error of the reconstruction
SE1 = sum((f-f_rec1).^2);

%% Q9

% perform thresholding on the details coefficients with thershold 0.8
[th_details, zero_count] = remove_coeffs(details, 0.8);

% plot reconstructed signal f with idwt from the approx and the thresholded details
f_rec2 = haar_idwt(approx, th_details);
figure(4);
stem(f_rec2);
title('Q9 Reconstructed signal after threshold');

% compute squared error of the reconstruction
SE2 = sum((f-f_rec2).^2); 

%% Q10

% compute squared error and zero count as function of threshold
thresh = 0:0.01:10;
n_thresh = length(thresh);
zero_count_vec = zeros(1, n_thresh);
SE_vec = zeros(1, n_thresh);

for i=1:n_thresh
    % reconstruct the signal from details <= thresh
    [details_temp, zero_count_vec(i)] = remove_coeffs(details, thresh(i));
    f_rec = haar_idwt(approx, details_temp);
    % compute squared error
    SE_vec(i) = sum((f-f_rec).^2); 
end

figure(5);
subplot(2,1,1);
plot(thresh, SE_vec);
title('Q10 Squared Error against threshold');
xlabel('threshold');
ylabel('Squared Error');

subplot(2,1,2);
plot(thresh, zero_count_vec);
title('Zero count against threshold');
xlabel('threshold');
ylabel('zero count');

%% Q14

% read the image and show
I = imread('lena.png');
figure(6);
imshow(I);
title('Q14 original image');

% show the 2D dwt of the image of level 3
wt = haar_image_dwt(I,3);
figure(7);
imshow(wt);
title('Q14 wavelet transform of the image');

figure(8);
imshow(mat2gray(wt));
title('Q14 wavelet transform of the image - grayscale');

%% Q16

% reconstruct the image from the wavelet transform
I_rec = haar_image_idwt(wt,3);
I_rec = uint8(I_rec);
figure(8);
imshow(I_rec);
title('Q16 reconstruction of the image');

% compute the squared error
SE_I = sum(sum((I-I_rec).^2));

%% Q17


%normalize the input image to the range [0,255]
I = uint8(255*mat2gray(I));

% apply dwt on the normalized image
wt = haar_image_dwt(I,3);

% take thresholds from 0 to 1000 in different sacales
T = [0:0.5:10 10:10:100 100:100:600];
n_T = length(T);
compression_ratio = zeros(1, n_T);
N = size(I,1)*size(I,2);
MSE_vec = zeros(1, n_T);
 
wt_T = wt;


for i=1:n_T
    % zero the details coefficietns <= thresh
    zero_ind = (abs(wt)<=T(i)) & (abs(wt) > 1e-10);
    
    %ignore indexes of the approximation (V0) (found in wt(448:512,1:64) )
    zero_ind(448:512,1:64) = 0;
    
    % reconstruct the image from the thresholded wavelet transform and
    % compute the squared error and the compression ratio
    wt_T(zero_ind) = 0;
    I_rec_T = haar_image_idwt(wt_T, 3);
    compression_ratio(i) = sum(sum(zero_ind))/N;
    MSE_vec(i) = sum(sum((I-uint8(I_rec_T)).^2))/N;   
    
    % unzero the details coefficietns
    wt_T = wt;
end

figure(9);
subplot(2,1,1);
plot(T, MSE_vec);
title('Q17 Mean Squared Error against threshold');
xlabel('threshold');
ylabel('MSE');

subplot(2,1,2);
plot(T, compression_ratio);
title('Compression ratio against threshold');
xlabel('threshold');
ylabel('compression ratio');

%% Q18

% pick 3 interesting threshold values 10,100,1000
T = [10 100 1000];
n_T = length(T);
compression_ratio = zeros(1, n_T);
N = size(I,1)*size(I,2);
MSE_vec = zeros(1, n_T);

wt_T = wt;

% show original image
figure();
imshow(I);
title({'Q18 Original image ';'Compression ratio = 0'});

% show 3 images with threshold 10,100,1000
for i=1:n_T
    % zero the details coefficietns <= thresh
    zero_ind = (abs(wt)<=T(i)) & (abs(wt) > 1e-10);
    
    %ignore indexes of the approximation (V0) (found in wt(448:512,1:64) )
    zero_ind(448:512,1:64) = 0;
    
    % reconstruct the image from the thresholded wavelet transform and
    % compute the squared error and the compression ratio
    wt_T(zero_ind) = 0;
    I_rec_T = uint8(haar_image_idwt(wt_T, 3));
    compression_ratio(i) = sum(sum(zero_ind))/N;
    MSE_vec(i) = sum(sum((I-I_rec_T).^2))/N;
    % show the reconstructed image
    figure();
    imshow(I_rec_T);
    title({['Q18 Image reconstructed with threshold of ',num2str(T(i))];['Compression ratio = ',num2str(compression_ratio(i)),'  MSE = ',num2str(MSE_vec(i))]});
end


