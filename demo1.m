% Single-pixel imaging using Hadamard patterns as sensing basis
% Example of single pixel imaging using taditional Hadamard matrices

clc
close all
clearvars

% Load object
img = imread('.\misc\5.3.01.tiff');

% sub-sampled image
% The size of the sampled image must be a power of 2
sampledImg = double(img(1:16:end, 1:16:end));  % 64x64p
sampledImg = sampledImg/max(max(sampledImg));
npixels = size(sampledImg,1);

fprintf('Size of image: %d pixels\n',npixels)

% - - - - - - - - - - - - - - - - - - 
%   Generate measurement patterns
% - - - - - - - - - - - - - - - - - -

% compute transform matrix
fprintf('Computing Hadamard matrices\n')
type_matrix = 1;
dim = 6;

if 2^(2*dim) ~= npixels^2
    fprintf('Dimensions do not agree.\n');
    return
end

switch type_matrix
    case 1
        % Compute the Walsh Hadamard transform
        Ht = Walsh_Hadamard_Transform(2*dim);
    case 2
        % Compute the Walsh-Paley transform
        Ht = Walsh_Paley_Transform(2*dim);
    case 3
        % Compute the Cal-Sal transform
        Ht = Cal_Sal_Transform(2*dim);
    case 4
        % Compute the Walsh-systems
        Ht = Walsh_System_Transform(2*dim);
    case 5
        % Compute the Haar transform
        Ht = Haar_Transform(2*dim);
    otherwise
        fprintf('Invalid option.\n')
        return
end

% visualize the Hadamard matrix
figure(1), imshow(Ht)

% - - - - - - - - - - - - - - - - - - 
% Reconstruct scene
% - - - - - - - - - - - - - - - - - - 
snr = 35;
numIter = 1;
avg_error = 0;

fprintf('Reconstructing image:\n')

for iter=1:numIter
    [target, target_noise] = dspi(Ht, sampledImg, snr, dim);
    % Calculate the error of the reconstructed image with added noise
    error = rmse(sampledImg, target_noise);
    avg_error = avg_error + error;
end

avg_error = avg_error/numIter;
fprintf('Average error = %f\n',avg_error)

% - - - - - - - - - - - - - - - 
%   Plot reconstructed image
% - - - - - - - - - - - - - - -
figure(2)
subplot(1,3,1)
imshow(sampledImg)
title('Original')
subplot(1,3,2)
imshow(target)
title('Reconstructed')
subplot(1,3,3)
imshow(target_noise)
title('Reconstructed with noise')