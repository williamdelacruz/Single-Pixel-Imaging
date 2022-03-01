function [sign] = change_of_sign(H)

dim = size(H,1);
sign = zeros(1,dim);

for i=1:dim
    change = 0;
    for j=1:dim-1
        if H(i,j)~=H(i,j+1)
            change = change + 1;
        end
    end
    sign(i) = change;
end