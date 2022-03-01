function [target, target_noise] = dspi(H, sampledImg, snr, dim)
    % Single-Pixel image reconstruction
    
    % Positive Hadamard patterns
    H1 = (H+1)/2;
    
    % Negative Hadamard patterns
    H0 = (1-H)/2;

    % Generate simulated measurements using positive and negative patterns
    M1 = H1*sampledImg(:);
    M0 = H0*sampledImg(:);

    %Generate measurements corrupted by noise
    M1Noise = awgn(M1,snr,'measured');
    M0Noise = awgn(M0,snr,'measured');

    % Generate true Hadamard coefficients
    M = M1 - M0;
    MNoise = M1Noise - M0Noise;

    % Reconstruct object
    target = H\M;
    target = reshape(target,[2^dim 2^dim]);

    % Reconstruct object with noise
    target_noise = H\MNoise;
    target_noise = reshape(target_noise,[2^dim 2^dim]);
end