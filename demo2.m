%   Demo 2:
%   Image reconstruction using Single Pixel Imaging. We use several
%   sensing matrices: 
%   1) Walsh Hadamard Transform 
%   2) Walsh Paley Transform
%   3) Cal Sal Transform
%   4) Walsh System Transform
%   5) Normalized Haar Transform
%   6) Cake_Cutting, sort with respect to the number of blocks 
%   7) Cake_Cutting, sort with respect to the largest block per pattern
%   8) GCSS with sequency permutation
%
% Single-pixel imaging using Hadamard patterns as sensing basis
clc
close all
clear

% Load object
img = imread('.\misc\5.3.01.tiff');

if size(img,3)==3
    img = rgb2gray(img);
end

num_pixels = 64;

% sub-sampled image
% The size of the sampled image must be a power of 2
img = double(imresize(img, [num_pixels num_pixels], 'bilinear'));
img = img/max(max(img));
npixels = size(img,1);

fprintf('Size of image: %d pixels\n',npixels)

% - - - - - - - - - - - - - - - - - - 
%   Generate measurement patterns
% - - - - - - - - - - - - - - - - - -
dim = 6;

if 2^(2*dim) ~= npixels^2
    fprintf('Dimensions do not agree.\n');
    return
end


% - - - - - - - - - - - - - - - - - - 
% Constructing Hadamard matrices
% - - - - - - - - - - - - - - - - - - 

fprintf('Constructing Hadamard matrices.\n')


H1 = Walsh_Hadamard_Transform(2*dim);
H2 = Walsh_Paley_Transform(2*dim); 
H3 = Walsh_System_Transform(2*dim);

if isfile('data/cakecutting64_blocks.mat')==1
    load 'data/cakecutting64_blocks.mat'
else
    [H, ~, ~] = Cake_Cutting(H1, dim, 'blocks');
end
H4 = H;

H5 = GCSS(dim*2, 'dyadic');



% - - - - - - - - - - - - - - - - - - - - - - - -
% Plot the sequency of each Hadamard matrix
% - - - - - - - - - - - - - - - - - - - - - - - -
figure(1)

% Compute the Walsh Hadamard transform
v = change_of_sign(H1);
subplot(2,3,1)
scatter(1:length(v),v,10,v,'s','filled')
title('Walsh Hadamard')
xlabel('Number of row')
ylabel('Sequency number')
axis tight
grid

% Compute the Walsh-Paley transform
v = change_of_sign(H2);
subplot(2,3,2)
scatter(1:length(v),v,10,v,'s','filled')
title('Walsh-Paley')
xlabel('Number of row')
ylabel('Sequency number')
axis tight
grid



% Compute the Walsh-systems
v = change_of_sign(H3);
subplot(2,3,3)
scatter(1:length(v),v,10,v,'s','filled')
title('Walsh-systems')
xlabel('Number of row')
ylabel('Sequency number')
axis tight
grid



% Cake cutting ordering blocks
v = change_of_sign(H4);
subplot(2,3,4)
scatter(1:length(v),v,10,v,'s','filled')
title('Cake cutting blocks')
xlabel('Number of row')
ylabel('Sequency number')
axis tight
grid


% GCSS ordering
v = change_of_sign(H5);
subplot(2,3,5)
scatter(1:length(v),v,10,v,'s','filled')
title('GCS ordering')
xlabel('Number of row')
ylabel('Sequency number')
axis tight
grid



% - - - - - - - - - - - - - - - - - - 
%     Main program for simulation
% - - - - - - - - - - - - - - - - - - 

snr = 50;
option_sampling = 1;
list_rmse = zeros(10,5);
list_rmse_noise = zeros(10,5);
list_images = {};
iter = 1;

% storage for images
img_nonoise = zeros(num_pixels, num_pixels, 10, 5);
img_noise = zeros(num_pixels, num_pixels, 10, 5);

fprintf('Simulation ...\n');

for sampling_ratio=0.1:0.1:1
    fprintf('Sampling ratio: %.2f\n',sampling_ratio*100);
    
    % Compute the Walsh Hadamard transform
    [target, target_noise] = dspi_differential(H1, img, snr, dim, option_sampling, sampling_ratio);
    list_rmse(iter,1) = rmse(img, target);
    list_rmse_noise(iter,1) = rmse(img, target_noise);
    img_nonoise(:,:,iter, 1) = target;
    img_noise(:,:,iter, 1) = target_noise;   
    
    % Compute the Walsh-Paley transform
    [target, target_noise] = dspi_differential(H2, img, snr, dim, option_sampling, sampling_ratio);
    list_rmse(iter,2) = rmse(img, target);
    list_rmse_noise(iter,2) = rmse(img, target_noise);
    img_nonoise(:,:,iter, 2) = target;
    img_noise(:,:,iter, 2) = target_noise;
    
  
    % Compute the Walsh-systems
    [target, target_noise] = dspi_differential(H3, img, snr, dim, option_sampling, sampling_ratio);
    list_rmse(iter,3) = rmse(img, target);
    list_rmse_noise(iter,3) = rmse(img, target_noise);
    img_nonoise(:,:,iter, 3) = target;
    img_noise(:,:,iter, 3) = target_noise;

    
    % cake cutting blocks
    [target, target_noise] = dspi_differential(H4, img, snr, dim, option_sampling, sampling_ratio);
    list_rmse(iter,4) = rmse(img, target);
    list_rmse_noise(iter,4) = rmse(img, target_noise);
    img_nonoise(:,:,iter, 4) = target;
    img_noise(:,:,iter, 4) = target_noise;


    % GCS ordering
    [target, target_noise] = dspi_differential(H5, img, snr, dim, option_sampling, sampling_ratio);
    list_rmse(iter,5) = rmse(img, target);
    list_rmse_noise(iter,5) = rmse(img, target_noise);
    img_nonoise(:,:,iter, 5) = target;
    img_noise(:,:,iter, 5) = target_noise;
    
    iter = iter + 1;
end


% Plot the rmse for several Hadamard matrices with a sampling ratio
range = 0.1:0.1:1;

figure(2)
hold on, plot(range, list_rmse(:,1),'d-')
hold on, plot(range, list_rmse(:,2),'o-')
hold on, plot(range, list_rmse(:,3),'s-')
hold on, plot(range, list_rmse(:,4),'*-')
hold on, plot(range, list_rmse(:,5),'p-')
legend('Natural','Walsh-Paley','Walsh-systems','Cakecutting','GCS+S')

xlabel('Sampling ratio (%)');
ylabel('RMSE')
axis tight
grid

figure(3)
hold on, plot(range, list_rmse_noise(:,1),'d-')
hold on, plot(range, list_rmse_noise(:,2),'o-')
hold on, plot(range, list_rmse_noise(:,3),'s-')
hold on, plot(range, list_rmse_noise(:,4),'*-')
hold on, plot(range, list_rmse_noise(:,5),'p-')
legend('Natural','Walsh-Paley','Walsh-systems','Cakecutting','GCS+S')
xlabel('Sampling ratio (%)');
ylabel('RMSE') 
title('Signal corrupted by noise')
axis tight
grid



% - - - - - - - - - - - - - - - - - - - - - - - -
% Plot reconstructed images
% - - - - - - - - - - - - - - - - - - - - - - - -

figure(4)
title('Reconstructed images')
index = 1;
for j=1:10
    for k=1:5
        subplot(10,5,index)
        imshow(img_nonoise(:,:,j,k), [],'InitialMagnification',500)
        set(gca,'xtick',[],'ytick',[])
        index = index + 1;
    end
end

figure(5)
title('Reconstructed images with noise')
index = 1;
for j=1:10
    for k=1:5
        subplot(10,5,index)
        imshow(img_nonoise(:,:,j,k),[],'InitialMagnification',500)
        set(gca,'xtick',[],'ytick',[])
        index = index + 1;
    end
end