function dec = bin2dec0(list)
% spin to binary
list = (list + 1)/2;

N = length(list);
dec = 0;
for j=1:N
    dec = dec + list(N-j+1)*2^(j-1);
end
