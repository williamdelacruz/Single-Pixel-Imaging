% Compute the cake cutting ordering of a Hadamard matix
% The parameter type can be either 'blocks' or 'lblocks'. In the first
% case, it obtaings an ordering based on the number of blocks, and in the
% second case, it obtains an ordering based on the largest block size
function [H_new, I, blocks] = Cake_Cutting(H, dim, type)

    len = 2^(2*dim);
    blocks = zeros(1,len); 
    
    for ii=1:len
        p = reshape(H(ii,:), [2^dim 2^dim]);
        [b0, b1, lbs]=count_regions(p, 2^dim);
        if strcmp(type,'blocks')
            blocks(ii) = b0+b1;
        elseif strcmp(type,'lblocks')
            blocks(ii) = lbs;
        end
    end
    
    % sort from larger to lower number of blocks
    if strcmp(type,'blocks')
        [~, I] = sort(blocks,'ascend');
    elseif strcmp(type,'lblocks')
        [~, I] = sort(blocks,'descend');
    end
    
    H_new = zeros(size(H));
    for i=1:size(H,1)
        H_new(i,:) = H(I(i), :);
    end