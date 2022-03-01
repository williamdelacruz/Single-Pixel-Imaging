function perm=rperm(N)

list=1:N;
perm = zeros(1,N);

for k=1:N
    x = randi(N-k+1);
    perm(k) = list(x);
    swap = list(N-k+1);
    list(N-k+1) = list(x);
    list(x) = swap;
end