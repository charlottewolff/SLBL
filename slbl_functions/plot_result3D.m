function plot_result3D(topo_file, slbl_file, mask_file, cloud_file)

    %% -- read files
    fprintf('Reading files\n');
    [grid_topo,meta_topo] = AscReadFull(topo_file);
    [grid_slbl,meta_slbl] = AscReadFull(slbl_file);
    [grid_mask,meta_mask] = AscReadFull(mask_file);
    mask_range            = mask_range_compute(grid_mask);
    %% -- reduce matrices
    [grid_topo_small, meta_topo_small] = reduce_size(grid_topo, meta_topo, mask_range);
    [grid_slbl_small, ~] = reduce_size(grid_slbl, meta_slbl, mask_range);
    [grid_mask_small, ~] = reduce_size(grid_slbl, meta_mask, mask_range);
    
    %find points to plot in 3d and create cloud matrice
    [mask_row,mask_col] = find(grid_mask_small);
    matrice_result = NaN(2*size(mask_row, 1), 4); 
    
    %compute 3d points
    for line=1:size(mask_row)
        x_topo = meta_topo_small.xllcorner + meta_topo_small.cellsize*(mask_col(line)-1);%x 
        y_topo = meta_topo_small.yllcorner + meta_topo_small.cellsize*(mask_row(line)-1);%y
        z_topo = grid_topo_small(mask_row(line),mask_col(line)); %z topo
        th_topo= 0;
        x_slbl = meta_topo_small.xllcorner + meta_topo_small.cellsize*(mask_col(line)-1);%x 
        y_slbl = meta_topo_small.yllcorner + meta_topo_small.cellsize*(mask_row(line)-1);%y
        z_slbl = grid_slbl_small(mask_row(line),mask_col(line)); %z slbl
        th_slbl= z_topo - z_slbl; %thickness
        matrice_result(2*line -1, :) = [x_topo, y_topo, z_topo, th_topo];
        matrice_result(2*line, :)    = [x_slbl, y_slbl, z_slbl, th_slbl];
    end
    
    %%-- Write result in file
    fprintf('Writting file\n');
    writematrix(matrice_result,cloud_file);
    fprintf('Writting in 3d --> DONE !\n')
end 