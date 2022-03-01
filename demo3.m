% Single-pixel imaging using Hadamard patterns as sensing basis
% A comparison of several permutations with the ordering GCSS
clc
close all
clear

% Load object
img = imread('.\misc\4.1.01.tiff');

if size(img,3)==3
    img = rgb2gray(img);
end

dim = 6;
size_img = 2^dim;


% sub-sampled image
% The size of the sampled image must be a power of 2
img = double(imresize(img, [size_img size_img], 'bilinear'));
img = img/max(max(img));
npixels = size(img,1);

fprintf('Size of image: %d pixels\n',npixels)

% - - - - - - - - - - - - - - - - - - 
%   Generate measurement patterns
% - - - - - - - - - - - - - - - - - -


if 2^(2*dim) ~= npixels^2
    fprintf('Dimensions do not agree.\n');
    return
end


% - - - - - - - - - - - - - - - - - - 
% Constructing Hadamard matrices
% - - - - - - - - - - - - - - - - - - 

fprintf('Constructing Hadamard matrices.\n')

H1 = GCSS(2*dim, 'Cal-Sal');
H2 = GCSS(2*dim, 'natural');
H3 = GCSS(2*dim, 'random');
H4 = GCSS(2*dim, 'Walsh-Paley');
H5 = GCSS(2*dim, 'dyadic');




% - - - - - - - - - - - - - - - - - - 
%     Main program for simulation
% - - - - - - - - - - - - - - - - - - 

snr = 40;
option_sampling = 1;
list_rmse = zeros(10,5);
list_rmse_noise = zeros(10,5);
list_images = {};
iter = 1;

% storage for images
img_nonoise = zeros(size_img, size_img, 10, 5);
img_noise = zeros(size_img, size_img, 10, 5);

fprintf('Simulation ...\n');

for sampling_ratio=0.1:0.1:1
    fprintf('Sampling ratio: %.2f\n',sampling_ratio*100);
    
    % Cal-Sal ordering
    [target, target_noise] = dspi_differential(H1, img, snr, dim, option_sampling, sampling_ratio);
    list_rmse(iter,1) = rmse(img, target);
    list_rmse_noise(iter,1) = rmse(img, target_noise);
    img_nonoise(:,:,iter, 1) = target;
    img_noise(:,:,iter, 1) = target_noise;   
    
    % Natural ordering
    [target, target_noise] = dspi_differential(H2, img, snr, dim, option_sampling, sampling_ratio);
    list_rmse(iter,2) = rmse(img, target);
    list_rmse_noise(iter,2) = rmse(img, target_noise);
    img_nonoise(:,:,iter, 2) = target;
    img_noise(:,:,iter, 2) = target_noise;
    
    % Random ordering
    [target, target_noise] = dspi_differential(H3, img, snr, dim, option_sampling, sampling_ratio);
    list_rmse(iter,3) = rmse(img, target);
    list_rmse_noise(iter,3) = rmse(img, target_noise);
    img_nonoise(:,:,iter, 3) = target;
    img_noise(:,:,iter, 3) = target_noise;
    
    
    % Walsh Paley
    [target, target_noise] = dspi_differential(H4, img, snr, dim, option_sampling, sampling_ratio);
    list_rmse(iter,4) = rmse(img, target);
    list_rmse_noise(iter,4) = rmse(img, target_noise);
    img_nonoise(:,:,iter, 4) = target;
    img_noise(:,:,iter, 4) = target_noise;
    
    % Dyadic ordering
    [target, target_noise] = dspi_differential(H5, img, snr, dim, option_sampling, sampling_ratio);
    list_rmse(iter,5) = rmse(img, target);
    list_rmse_noise(iter,5) = rmse(img, target_noise);
    img_nonoise(:,:,iter, 5) = target;
    img_noise(:,:,iter, 5) = target_noise;
 
    iter = iter + 1;
end


% Plot the rmse for several Hadamard matrices with a sampling ratio
range = (0.1:0.1:1)*100;

figure(1)
hold on, plot(range, list_rmse(:,1),'d-','LineWidth',1)
hold on, plot(range, list_rmse(:,2),'o--','LineWidth',1)
hold on, plot(range, list_rmse(:,3),'v-.','LineWidth',1)
hold on, plot(range, list_rmse(:,4),'*:','LineWidth',1)
hold on, plot(range, list_rmse(:,5),'p-','LineWidth',1)


legend('Cal-Sal','Natural','Random','Walsh-Paley','Sequency (GCS+S)')
xlabel('Sampling ratio (%)');
ylabel('RMSE')
axis tight
grid
box on


figure(2)
hold on, plot(range, list_rmse_noise(:,1),'d-r')
hold on, plot(range, list_rmse_noise(:,2),'o--b')
hold on, plot(range, list_rmse_noise(:,3),'v-.k')
hold on, plot(range, list_rmse_noise(:,4),'*:k')
hold on, plot(range, list_rmse_noise(:,5),'p-k')
legend('Cal-Sal','Natural','Random','Walsh-Paley','Sequency (GCS+S)')
xlabel('Sampling ratio (%)');
ylabel('RMSE') 
title('Signal corrupted by noise')
axis tight
grid
box on


