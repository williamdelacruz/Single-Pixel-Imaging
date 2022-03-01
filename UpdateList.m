function [B, bitflags, stack, index, block_size] = UpdateList(seed, B_ref, bitflags_ref, stack_ref, index_ref, y, x, block_size_ref)
    B = B_ref;
    bitflags = bitflags_ref;
    stack = stack_ref;
    index = index_ref;
    block_size = block_size_ref;

    [dimy, dimx] = size(B);

    if y-1>=1
        if bitflags(y-1, x)==0 && B(y-1,x)==seed
            index = index + 1;
            stack(index, :) = [y-1 x];
            bitflags(y-1, x) = 1;
            block_size = block_size + 1;
        end
    end
    
    if y+1<=dimy
        if bitflags(y+1,x)==0 && B(y+1,x)==seed
            index = index + 1;
            stack(index, :) = [y+1 x];
            bitflags(y+1, x) = 1;
            block_size = block_size + 1;
        end
    end
    
    if x-1>=1
        if bitflags(y,x-1)==0 && B(y,x-1)==seed
            index = index + 1;
            stack(index, :) = [y x-1];
            bitflags(y, x-1) = 1;
            block_size = block_size + 1;
        end
    end

    if x+1<=dimx
        if bitflags(y,x+1)==0 && B(y,x+1)==seed
            index = index + 1;
            stack(index, :) = [y x+1];
            bitflags(y, x+1) = 1;
            block_size = block_size + 1;
        end
    end