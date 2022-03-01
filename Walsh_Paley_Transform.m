function w = Walsh_Paley_Transform(n)
    % Walsh-Paley transform
    Pk = [1];
    B1 = [1 1];
    B2 = [1 -1];
    
    for k=1:n
        pk1 = kron(Pk,B1);
        pk2 = kron(Pk,B2);
        Pk  = [pk1; pk2];
    end
    
    w = Pk;
end