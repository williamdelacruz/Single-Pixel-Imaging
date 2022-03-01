function w = Walsh_System_Transform(n)
    % Walsh-systems
    W2 = [1 1; 1 -1];
    R  = [0 1; 1 0];
    
    if n==1
        w = W2;
    else
        A = W2;
        
        % construct recursively the matrix W
        for N=1:n-1
            Wk = zeros(2^(N+1), 2^(N+1));
            % for each column of A
            k = 1;
            for i=1:2:2^N
                Wk(:,k:k+3) = [kron(W2,A(:,i)) kron(W2*R,A(:,i+1))];
                k = k + 4;
            end
            
            A = Wk;
        end
        w = A;
    end
end