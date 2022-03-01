function Index = IndexingMatrix(H1, H, Len)
 Index = zeros(1,Len);
    
    for i=1:Len
        row1 = H(i,:);
        j=1;
        flag = 1;
        
        while j<=Len && flag==1
            row2 = H1(j,:);
            k=1;
            
            while k<=Len && row1(k)==row2(k)
                k=k+1;
            end
         
            if k>Len
                flag=0;
            end
        
            j=j+1;
        end
        
        Index(i)=j-1;
    end