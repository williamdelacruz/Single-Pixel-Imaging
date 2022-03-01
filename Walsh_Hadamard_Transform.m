function w = Walsh_Hadamard_Transform(n)
    % Walsh-Hadamard transform
    w = [1 1; 1 -1];
    
    for N=1:n-1
        Wk = [w w; w -w];
        w = Wk;
    end
end