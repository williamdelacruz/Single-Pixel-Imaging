% Construction of generalized Hadamard matrices
% based on gray code sequence
function [vs, sg] = GCK(n, s)
    vs = s;
    sg = [];
    
    for k=1:n
        M = size(vs,1);
        N = size(vs,2);
        vk = zeros(2*M, 2*N);
        % For the alpha-related property
        sign = zeros(2*M, k);
        
        i = 1;
        for j=1:2:2*M
            vk(j, :) = [ vs(i,:) vs(i,:)];
            if isempty(sg)
                sign(j,:) = 1;
            else
                sign(j,:) = [sg(i,:) 1];
            end
            
            vk(j+1, :) = [ vs(i,:) -vs(i,:)];
            if isempty(sg)
                sign(j+1,:) = -1;
            else
                sign(j+1,:) = [sg(i,:) -1];
            end
            
            i=i+1;
        end
        
        vs = vk;
        sg = sign;
    end
end