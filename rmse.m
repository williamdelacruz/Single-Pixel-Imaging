% Commpute the normalized RMSE
function error = rmse(I1, I2)
    [ny, nx] = size(I1);
    diff = (I1(:)-I2(:)).^2;
    error = sqrt( sum(diff)/(ny*nx) );
end