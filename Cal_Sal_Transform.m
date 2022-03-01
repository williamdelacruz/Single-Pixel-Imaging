function w = Cal_Sal_Transform(n)
    % Cal-Sal transform
    w = zeros(2^n, 2^n);
    R = zeros(n, n);
    
    if n==1
        R = [1];
    else
        for k=1:n-1
            R(k,n-k+1) = 1;
            R(n-k+1,k+1) = 1;
        end
        R(n, 1) = 1;
    end

    for j=1:2^n
        bj = flip(de2bi(j-1,n));
        w(j, j) = (-1)^sum(bj*R*bj');
        
        for k=j+1:2^n
            bk = flip(de2bi(k-1,n));
            entry = (-1)^sum(bj*R*bk');
            w(j, k) = entry;
            w(k, j) = entry;
        end
    end 
end