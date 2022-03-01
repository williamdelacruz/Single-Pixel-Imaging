% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%  A comparison of image restoration using the Cake Cutting
%  and GCS+S methods. The linear equation system is solved using
%  a Total Variational algorithm
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

clc
close all
clear

base_path = pwd;

cd(strcat(base_path,'\TVAL3_beta2.4'))
path(path,genpath(pwd));
cd('..')

% - - - - - - - - - - - - - - - - - - 
%   Generate measurement patterns
% - - - - - - - - - - - - - - - - - -
dim = 7;
size_img = 2^dim;

% - - - - - - - - - - - - - - - - - - 
% Constructing Hadamard matrices
% - - - - - - - - - - - - - - - - - - 

fprintf('Constructing Hadamard matrices.\n')

if isfile('data/cakecutting128_blocks.mat')==1
    load 'data/cakecutting128_blocks.mat'
else
    [H, ~, ~] = Cake_Cutting(Walsh_Hadamard_Transform(2*dim), dim, 'blocks');
end

H4 = H;
clear H
H5 = GCSS(2*dim, 'dyadic');





% - - - - - - - - - - - - - - - - - - 
%     Main program for simulation
% - - - - - - - - - - - - - - - - - - 

num_images = 1;

sampling_list = [0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0];
len_sl = length(sampling_list);

snr = 40;

option_sampling = 1;
list_rmse = zeros(len_sl, 2, num_images);
list_rmse_noise = zeros(len_sl, 2, num_images);
list_ssim = zeros(len_sl, 2, num_images);
list_ssim_noise = zeros(len_sl, 2, num_images);

% storage for images
img_nonoise = zeros(size_img, size_img, len_sl, 2, num_images);
img_noise = zeros(size_img, size_img, len_sl, 2, num_images);


fprintf('Simulation ...\n');

list_images = [3713 3309 56622];

for im=1:num_images
    % Load a random object 
    index_img = randi(82783);
    list_images(im) = index_img;
    %index_img = list_images(im);
    fprintf('***********  IMAGE %d **********\n', im);
    
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
    num_pixel = 128; % number of image pixels in each dimension


    for sr = 1:length(sampling_list)
        sampling_ratio = sampling_list(sr);
        fprintf('Sampling ratio: %.2f\n',sampling_ratio*100);
    
        % - - - - - - - - - - - - - - - 
        %     Cake Cutting blocks
        % - - - - - - - - - - - - - - -
 
        num_pattern = round(sampling_ratio*num_pixel*num_pixel);
        
        patterns = H4(1:num_pattern,:);
        measurements = patterns*img(:);
        mavg = mean(abs(measurements));
        sigma = 0.5;
        measurements_noise = measurements + sigma*mavg*randn(length(measurements),1);
        %measurements_noise = awgn(measurements, snr, 'measured');
        
        % Run TVAL3
        clear opts
        opts.mu = 2^8;
        opts.beta = 2^5;
        opts.tol = 1E-3;
        opts.maxit = 300;
        opts.TVnorm = 1;
        opts.disp = false;

        % Solve the sparse problem
        [target, ~] = TVAL3(patterns, measurements, num_pixel, num_pixel, opts);
        [target_noise, ~] = TVAL3(patterns, measurements_noise, num_pixel, num_pixel, opts);
                 
        % restored images
        target = abs(target);
        target_noise = abs(target_noise);
        target = normalize_matrix(target);
        target_noise = normalize_matrix(target_noise);
        
        % save solutions
        list_rmse(iter,1,im) = rmse(img, target);              % RMSE
        list_rmse_noise(iter,1,im) = rmse(img, target_noise);
        list_ssim(iter, 1, im) = ssim(target, img);            % SSIM
        list_ssim_noise(iter, 1, im) = ssim(target_noise, img);
        img_nonoise(:,:,iter, 1,im) = target;                  % Imagenes
        img_noise(:,:,iter, 1,im) = target_noise;

        
        % - - - - - - - - - - - - - - - 
        %     GCS+S ordering
        % - - - - - - - - - - - - - - -
        
        patterns = H5(1:num_pattern,:);
        measurements = patterns*img(:);
        mavg = mean(abs(measurements));
        sigma = 0.5;
        measurements_noise = measurements + sigma*mavg*randn(length(measurements),1);
        %measurements_noise = awgn(measurements, snr, 'measured');
        
        % Run TVAL3
        clear opts
        opts.mu = 2^8;
        opts.beta = 2^5;
        opts.tol = 1E-3;
        opts.maxit = 300;
        opts.TVnorm = 1;
        opts.disp = false;

        % Solve the sparse problem
        [target, ~] = TVAL3(patterns, measurements, num_pixel, num_pixel, opts);
        [target_noise, ~] = TVAL3(patterns, measurements_noise, num_pixel, num_pixel, opts);
                 
        % restored images
        target = abs(target);
        target_noise = abs(target_noise);
        target = normalize_matrix(target);
        target_noise = normalize_matrix(target_noise);

        % save solutions
        list_rmse(iter,2,im) = rmse(img, target);              % RMSE
        list_rmse_noise(iter,2,im) = rmse(img, target_noise);
        list_ssim(iter, 2, im) = ssim(target, img);            % SSIM
        list_ssim_noise(iter, 2, im) = ssim(target_noise, img);
        img_nonoise(:,:,iter, 2,im) = target;                  % Imagenes 
        img_noise(:,:,iter, 2,im) = target_noise;
    
        iter = iter + 1;
    end

end


% - - - - - - - - - - - - - - - - - - - - - -
% Mean and standard deviation
% - - - - - - - - - - - - - - - - - - - - - -

range = sampling_list;
result1 = zeros(2, len_sl, 2);
result2 = zeros(2, len_sl, 2);
result3 = zeros(2, len_sl, 2);
result4 = zeros(2, len_sl, 2);

for i=1:2
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
errorbar(range*100, result1(1,:,1), result1(1,:,2),'d-','LineWidth',1)
hold on
errorbar(range*100, result1(2,:,1), result1(2,:,2),'o-','LineWidth',1)
xlabel('Sampling ratio (%)');
ylabel('RMSE (Mean +/- Std Dev)')
grid
box on
x = [0 100];
y = [0.1 0.1];
line(x, y, 'Color', 'Black', 'LineStyle', '--')
legend('Walsh-Paley','Sequency','CC','GCS+S')
set(gca,'FontSize',11)



% With noise
figure(2)
errorbar(range*100, result2(1,:,1), result2(1,:,2),'d-','LineWidth',1)
hold on
errorbar(range*100, result2(2,:,1), result2(2,:,2),'o-','LineWidth',1)
xlabel('Sampling ratio (%)');
ylabel('RMSE (Mean +/- Std Dev)')
grid
box on
x = [0 100];
y = [0.1 0.1];
line(x, y, 'Color', 'Black', 'LineStyle', '--')
legend('Walsh-Paley','Sequency','CC','GCS+S')
set(gca,'FontSize',11)



% - - - - - - - - - - - - - - - - - - - - - -
% SSIM plots
% - - - - - - - - - - - - - - - - - - - - - -

% Without noise
figure(3)
errorbar(range*100, result3(1,:,1), result3(1,:,2),'d-','LineWidth',1)
hold on
errorbar(range*100, result3(2,:,1), result3(2,:,2),'o-','LineWidth',1)
x = [0 100];
y = [0.6 0.6];
line(x, y, 'Color', 'Black', 'LineStyle', '--')
legend('Walsh-Paley','Sequency','CC','GCS+S')
xlabel('Sampling ratio (%)');
ylabel('SSIM (Mean +/- Std Dev)')
grid
box on
set(gca,'FontSize',11)


% With noise
figure(4)
errorbar(range*100, result4(1,:,1), result4(1,:,2),'d-','LineWidth',1)
hold on
errorbar(range*100, result4(2,:,1), result4(2,:,2),'o-','LineWidth',1)
x = [0 100];
y = [0.6 0.6];
line(x, y, 'Color', 'Black', 'LineStyle', '--')
legend('Walsh-Paley','Sequency','CC','GCS+S')
xlabel('Sampling ratio (%)');
ylabel('SSIM (Mean +/- Std Dev)')
grid
box on
set(gca,'FontSize',11)

