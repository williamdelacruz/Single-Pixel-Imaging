function Hnew = GCSS(dim, ordering)
%% Construct Hadamard matrix with a unique binary string per row


if rem(dim,2)~=0
    fprintf('Incorrect dimension for Hadamard generation!\n');
    return
end

dim2 = dim/2;

% create Hadamard matrix or order dim-1
[H1, sg1] = GCK(dim2, 1);

% temporal
H2 = zeros(size(H1));
sg2 = zeros(size(sg1));
Len = size(H1,1);



%% Different ordering

if strcmp(ordering,'dyadic')
    % sort w.r.t. the change of sign
    v = change_of_sign(H1);
    [~,Index] = sort(v, 'ascend');
    
    for k=1:Len
        H2(k,:) = H1(Index(k),:);
        sg2(k,:) = sg1(Index(k),:);
    end
elseif strcmp(ordering,'GCK')
    H2 = H1;
    sg2 = sg1;
elseif strcmp(ordering,'random')
    rng(1)
    rp = rperm(Len);
    for k=1:Len
        H2(k,:) = H1(rp(k),:);
        sg2(k,:) = sg1(rp(k),:);
    end
elseif strcmp(ordering,'natural')
    H = Walsh_Hadamard_Transform(dim2);
    Index = IndexingMatrix(H1, H, Len);
    for k=1:Len
        H2(k,:) = H1(Index(k),:);
        sg2(k,:) = sg1(Index(k),:);
    end
elseif strcmp(ordering,'Walsh-Paley')
    H = Walsh_Paley_Transform(dim2);
    Index = IndexingMatrix(H1, H, Len);
    for k=1:Len
        H2(k,:) = H1(Index(k),:);
        sg2(k,:) = sg1(Index(k),:);
    end
elseif strcmp(ordering,'Cal-Sal')
    H = Cal_Sal_Transform(dim2);
    Index = IndexingMatrix(H1, H, Len);
    for k=1:Len
        H2(k,:) = H1(Index(k),:);
        sg2(k,:) = sg1(Index(k),:);
    end
elseif strcmp(ordering,'Walsh-System')
    H = Walsh_System_Transform(dim2);
    Index = IndexingMatrix(H1, H, Len);
    for k=1:Len
        H2(k,:) = H1(Index(k),:);
        sg2(k,:) = sg1(Index(k),:);
    end
elseif strcmp(ordering,'other')
    H = GCK_paths_optimalOrdering(dim2, 1.0);
    Index = IndexingMatrix(H1, H, Len);
    for k=1:Len
        H2(k,:) = H1(Index(k),:);
        sg2(k,:) = sg1(Index(k),:);
    end
end






%% Matrix representation of the Hadamard matrix of order dim

M = zeros(Len, Len);

for i=1:Len
    str1 = sg2(i,:);
    for j=1:Len
       str2 = sg2(j,:); 
       M(i,j) = bin2dec0([str1 str2]);
    end
end


%% Reference Hadamard matrix
[Hr, sgr] = GCK(dim, 1);
sgr_dec = zeros(1,size(sgr,1));

for k=1:size(sgr,1)
    sgr_dec(k) = bin2dec0(sgr(k,:));
end




%% Hadamard matrix traversal 

route = zigzag(M);



%% New ordering
Hnew = zeros(size(Hr));

for k=1:size(Hnew,1)
    id = find(sgr_dec==route(k));
    Hnew(k,:) = Hr(id(1),:);
end
