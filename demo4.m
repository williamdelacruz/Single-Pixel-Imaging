% Comparison of the matrix ordering Cake Cutting and GCS+S
% Using the COCO database
% 

clc
close all
clear


% - - - - - - - - - - - - - - - - - - 
%   Generate measurement patterns
% - - - - - - - - - - - - - - - - - -
dim = 6;
size_img = 2^dim;

% - - - - - - - - - - - - - - - - - - 
% Constructing Hadamard matrices
% - - - - - - - - - - - - - - - - - - 

fprintf('Constructing Hadamard matrices.\n')


H1 = Walsh_Hadamard_Transform(2*dim);
H2 = Walsh_Paley_Transform(2*dim);
H3 = Walsh_System_Transform(2*dim);

if isfile('data/cakecutting128_blocks.mat')==1
    load 'data/cakecutting128_blocks.mat'
else
    [H, ~, ~] = Cake_Cutting(H1, dim, 'blocks');
end
H4 = H;

H5 = GCSS(2*dim, 'dyadic');



% - - - - - - - - - - - - - - - - - - 
%     Main program for simulation
% - - - - - - - - - - - - - - - - - - 

num_images = 10;

sampling_list = [0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0];
len_sl = length(sampling_list);

snr = 50;

option_sampling = 1;
list_rmse = zeros(len_sl, 5, num_images);
list_rmse_noise = zeros(len_sl, 5, num_images);
list_ssim = zeros(len_sl, 5, num_images);
list_ssim_noise = zeros(len_sl, 5, num_images);
list_images = zeros(1, num_images);

% storage for images
img_nonoise = zeros(size_img, size_img, len_sl, 5, num_images);
img_noise = zeros(size_img, size_img, len_sl, 5, num_images);


fprintf('Simulation ...\n');


for im=1:num_images
    % Load a random object 
    index_img = randi(82783);
    list_images(im) = index_img;
    name = strcat('COCO_train2014_', num2str(index_img), '.jpg');
    path_img = strcat('.\coco-train2014\', name);
    img = imread(path_img);
    fprintf('Image: %s\n', path_img);

    if size(img,3)==3
        img = rgb2gray(img);
    end

    % sub-sampled image
    img = double(imresize(img, [size_img size_img], 'bilinear'));
    img = img/max(max(img));
    
    iter = 1;

    for sr = 1:length(sampling_list)
        sampling_ratio = sampling_list(sr);
        fprintf('Sampling ratio: %.2f\n',sampling_ratio*100);
    
        % Compute the Walsh Hadamard transform
        [target, target_noise] = dspi_differential(H1, img, snr, dim, option_sampling, sampling_ratio);
        list_rmse(iter,1, im) = rmse(img, target);             % RMSE
        list_rmse_noise(iter,1, im) = rmse(img, target_noise);
        list_ssim(iter, 1, im) = ssim_index(target*255, img*255);            % SSIM
        list_ssim_noise(iter, 1, im) = ssim_index(target_noise*255, img*255);
        img_nonoise(:,:,iter, 1, im) = target;                 % Images
        img_noise(:,:,iter, 1, im) = target_noise;   
    
        % Compute the Walsh-Paley transform
        [target, target_noise] = dspi_differential(H2, img, snr, dim, option_sampling, sampling_ratio);
        list_rmse(iter,2,im) = rmse(img, target);              % RMSE
        list_rmse_noise(iter,2,im) = rmse(img, target_noise);
        list_ssim(iter, 2, im) = ssim_index(target*255, img*255);            % SSIM
        list_ssim_noise(iter, 2, im) = ssim_index(target_noise*255, img*255);
        img_nonoise(:,:,iter, 2,im) = target;                  % Images
        img_noise(:,:,iter, 2,im) = target_noise;
    
        % Compute the Walsh-systems
        [target, target_noise] = dspi_differential(H3, img, snr, dim, option_sampling, sampling_ratio);
        list_rmse(iter,3,im) = rmse(img, target);              % RMSE
        list_rmse_noise(iter,3,im) = rmse(img, target_noise);
        list_ssim(iter, 3, im) = ssim_index(target*255, img*255);            % SSIM
        list_ssim_noise(iter, 3, im) = ssim_index(target_noise*255, img*255);
        img_nonoise(:,:,iter, 3,im) = target;                  % Images
        img_noise(:,:,iter, 3,im) = target_noise;
    
        % cake cutting blocks
        [target, target_noise] = dspi_differential(H4, img, snr, dim, option_sampling, sampling_ratio);
        list_rmse(iter,4,im) = rmse(img, target);              % RMSE
        list_rmse_noise(iter,4,im) = rmse(img, target_noise);
        list_ssim(iter, 4, im) = ssim_index(target*255, img*255);            % SSIM
        list_ssim_noise(iter, 4, im) = ssim_index(target_noise*255, img*255);
        img_nonoise(:,:,iter, 4,im) = target;                  % Images
        img_noise(:,:,iter, 4,im) = target_noise;

        % GCS+S ordering
        [target, target_noise] = dspi_differential(H5, img, snr, dim, option_sampling, sampling_ratio);
        list_rmse(iter,5,im) = rmse(img, target);              % RMSE
        list_rmse_noise(iter,5,im) = rmse(img, target_noise);
        list_ssim(iter, 5, im) = ssim_index(target*255, img*255);            % SSIM
        list_ssim_noise(iter, 5, im) = ssim_index(target_noise*255, img*255);
        img_nonoise(:,:,iter, 5,im) = target;                  % Imagenes 
        img_noise(:,:,iter, 5,im) = target_noise;
    
        iter = iter + 1;
    end
end


% - - - - - - - - - - - - - - - - - - - - - -
% Mean and standard deviation
% - - - - - - - - - - - - - - - - - - - - - -

range = sampling_list;
result1 = zeros(5, len_sl, 2);
result2 = zeros(5, len_sl, 2);
result3 = zeros(5, len_sl, 2);
result4 = zeros(5, len_sl, 2);

for i=1:5
    for j=1:len_sl
        % RMSE
        result1(i,j,1) = mean(list_rmse(j,i,:)); 
        result1(i,j,2) = std(list_rmse(j,i,:));
        result2(i,j,1) = mean(list_rmse_noise(j,i,:)); 
        result2(i,j,2) = std(list_rmse_noise(j,i,:));
        % SSIM
        result3(i,j,1) = mean(list_ssim(j,i,:)); 
        result3(i,j,2) = std(list_ssim(j,i,:));
        result4(i,j,1) = mean(list_ssim_noise(j,i,:)); 
        result4(i,j,2) = std(list_ssim_noise(j,i,:));
    end
end


% - - - - - - - - - - - - - - - - - - - - - -
% RMSE plots
% - - - - - - - - - - - - - - - - - - - - - -

% Without noise
figure(1)
errorbar(range, result1(2,:,1), result1(2,:,2),'d-','LineWidth',1)
hold on
errorbar(range, result1(3,:,1), result1(3,:,2),'o-','LineWidth',1)
hold on
errorbar(range, result1(4,:,1), result1(4,:,2),'*-','LineWidth',1)
hold on
errorbar(range, result1(5,:,1), result1(5,:,2),'p-','LineWidth',1)

legend('Walsh-Paley','Sequency','CC','GCS+S')
xlabel('Sampling ratio (%)');
ylabel('RMSE (Mean +/- Std Dev)')
grid
box on



% With noise
figure(2)
errorbar(range, result2(2,:,1), result2(2,:,2),'d-','LineWidth',1)
hold on
errorbar(range, result2(3,:,1), result2(3,:,2),'o-','LineWidth',1)
hold on
errorbar(range, result2(4,:,1), result2(4,:,2),'*-','LineWidth',1)
hold on
errorbar(range, result2(5,:,1), result2(5,:,2),'p-','LineWidth',1)

legend('Walsh-Paley','Sequency','CC','GCS+S')
xlabel('Sampling ratio (%)');
ylabel('RMSE (Mean +/- Std Dev)')
grid
box on



% - - - - - - - - - - - - - - - - - - - - - -
% SSIM Plots
% - - - - - - - - - - - - - - - - - - - - - -

% Without noise 
figure(3)
errorbar(range, result3(2,:,1), result3(2,:,2),'d-','LineWidth',1)
hold on
errorbar(range, result3(3,:,1), result3(3,:,2),'o-','LineWidth',1)
hold on
errorbar(range, result3(4,:,1), result3(4,:,2),'*-','LineWidth',1)
hold on
errorbar(range, result3(5,:,1), result3(5,:,2),'p-','LineWidth',1)

legend('Walsh-Paley','Sequency','CC','GCS+S')
xlabel('Sampling ratio (%)');
ylabel('SSIM (Mean +/- Std Dev)')
grid
box on


% With noise
figure(4)
errorbar(range, result4(2,:,1), result4(2,:,2),'d-','LineWidth',1)
hold on
errorbar(range, result4(3,:,1), result4(3,:,2),'o-','LineWidth',1)
hold on
errorbar(range, result4(4,:,1), result4(4,:,2),'*-','LineWidth',1)
hold on
errorbar(range, result4(5,:,1), result4(5,:,2),'p-','LineWidth',1)

legend('Walsh-Paley','Sequency','CC','GCS+S')
xlabel('Sampling ratio (%)');
ylabel('SSIM (Mean +/- Std Dev)')
grid
box on
