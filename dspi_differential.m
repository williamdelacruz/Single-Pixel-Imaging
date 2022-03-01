% Single-Pixel image reconstruction

function [target, target_noise] = dspi_differential(H, img, snr, dim, ...
                                                option_sampling, sampling_ratio)
    % Positive Hadamard patterns
    H1 = max(H, 0);
    
    % Negative Hadamard patterns
    H0 = abs(min(H, 0));

    % Generate simulated measurements using positive and negative patterns
    M1 = H1*img(:);
    M0 = H0*img(:);

    %Generate measurements corrupted by noise
    M1Noise = awgn(M1,snr,'measured');
    M0Noise = awgn(M0,snr,'measured');

    % Generate true Hadamard coefficients
    M = M1 - M0;
    MNoise = M1Noise - M0Noise;
    
    % Apply sampling
    if option_sampling==1
        if sampling_ratio>0.0 && sampling_ratio<1.0
            l = round(length(M)*sampling_ratio);
            M(l: end) = 0;
            MNoise(l: end) = 0;
        end
    end

    % Reconstruct object without noise
    %target = H\M;
    target =(1/2^(2*dim))*H'*M;
    target = reshape(target,[2^dim 2^dim]);

    % Reconstruct object with noise
    %target_noise = H\MNoise;
    target_noise =(1/2^(2*dim))*H'*MNoise;
    target_noise = reshape(target_noise,[2^dim 2^dim]);
end