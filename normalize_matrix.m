function [y] = normalize_matrix(im)
    min1 = min(im(:));
    im = im - min1;
    max1 = max(im(:));
    y = im / max1;