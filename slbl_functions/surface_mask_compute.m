function surface_mask = surface_mask_compute(mask_grid, mask_metadata, mask_range)
	%Function : 	gives the number of cells and surface in the mask
    surface_mask = 0;
    cells_nb = 0;
    for i = mask_range(3):mask_range(4) %lines
        for j = mask_range(1):mask_range(2) %columns
            if mask_grid(i,j)
                surface_mask = surface_mask + (mask_metadata.cellsize)^2;
                cells_nb = cells_nb +1;
            end
        end
    end
    fprintf('Number of cells in mask : %d\n', cells_nb);
end