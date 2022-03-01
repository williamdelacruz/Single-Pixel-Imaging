function w = Haar_Transform(n)
    % Walsh-Paley transform
    Haar = [1 1; 1 -1];
    B1 = [1 1];
    B2 = [1 -1];
    
    if n==1
        w = Haar;
    else
        H = Haar;
        for k=2:n
            pk1 = kron(H, B1);
            In = eye(2^(k-1));
            pk2 = kron(sqrt(2^(k-1))*In,B2);
            Pk  = [pk1; pk2];
            H = Pk;
        end
    
        w = H;      
    end
end