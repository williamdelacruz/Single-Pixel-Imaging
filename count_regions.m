% Count the number of connected regions in a binary image
function [pieces_back, pieces_white, largest_block_size] = count_regions(B, n)
    bitflags = zeros(n, n);
    pieces_back = 0;
    pieces_white = 0;
    largest_block_size = 0;

    for i=1:n
        for j=1:n
            if bitflags(i,j)==0
                bitflags(i,j) = 1;
                stack = zeros(n*n,2);
                index = 0;
                seed = B(i,j);
                block_size = 1;
                
                if seed ==1
                    pieces_white = pieces_white + 1;
                else
                    pieces_back = pieces_back + 1;
                end
                
                [B, bitflags, stack, index, block_size] = UpdateList(seed, B, bitflags, stack, index, i, j, block_size);
                % fullfil of a region
                while index>0
                    y = stack(index, 1);
                    x = stack(index, 2);
                    index = index - 1;
                    [B, bitflags, stack, index, block_size] = UpdateList(seed, B, bitflags, stack, index, y, x, block_size);
                end
                
                if block_size > largest_block_size %&& seed==1
                    largest_block_size = block_size;
                end  
            end
        end
    end