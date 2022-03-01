function sol = zigzag(H)

[n, m] = size(H);
sol = zeros(1,n*m);

row = 0; 
col = 0;
row_inc = 0;

% Print matrix of lower half zig-zag pattern
mn = min(m, n);

iter = 1;

for len=1:mn
    for i=0:len-1
        %fprintf('%d ',H(row+1,col+1))
        sol(iter) = H(row+1,col+1);
        iter = iter+1;
        
        if (i+1)==len
            break
        end
        
        if row_inc
            row = row + 1;
            col = col - 1;
        else
            row = row - 1;
            col = col + 1;
        end
    end
    
    if len == mn
        break
    end
    
    if row_inc
        row = row + 1;
        row_inc = 0;
    else
        col = col + 1;
        row_inc = 1;
    end
end



% Update the indexes of row and col variable
if (row == 0) 
    if (col == m - 1)
		row = row+1;
	else
		col=col+1;
    end
	row_inc = 1;
else
	if row == n - 1
		col = col+1;
	else
		row = row+1;
    end
	row_inc = 0;
end

% Print the next half zig-zag pattern
MAX = max(m, n) - 1;

for diag=MAX:-1:1
    if (diag > mn)
		len = mn;
	else
		len = diag;
    end
    
    for i=0:len-1
        %fprintf('%d ',H(row+1,col+1))
        sol(iter) = H(row+1,col+1);
        iter = iter+1;        
        
        if (i + 1 == len)
            break;
        end
        
        if (row_inc)
			row=row+1;
            col=col-1;
        else
            col=col+1;
            row=row-1;
        end
    end
    
    % Update the indexes of row and col variable
	if (row == 0 || col == m - 1) 
		if (col == m - 1)
			row=row+1;
		else
			col=col+1;
        end
		row_inc = 1;
    else
        if (col == 0 || row == n - 1)
			if (row == n - 1)
				col=col+1;
			else
				row=row+1;
            end

			row_inc = 0;
        end
    end
end
