function mask_range = mask_range_compute(mask_matrice)
%Function : 	find the [min x, max x, min y, max y] of the mask 
    [y_mask,x_mask] = find(mask_matrice);
    y_min = min(y_mask);
    y_max = max(y_mask);
    x_min = min(x_mask);
    x_max = max(x_mask);
    mask_range = [x_min x_max y_min y_max];
end