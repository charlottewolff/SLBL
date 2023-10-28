function [dem_grid_SLBL, thickness_grid_SLBL, volume_total, compute_time, mask_range] = compute_SLBL(process)
    dem_grid            = process.dem_grid;
    dem_metadata        = process.dem_metadata;
    mask_grid           = process.mask_grid;
    mask_range          = process.mask_range;
    volume_threshold    = process.volume_threshold;
    thickness           = process.thickness;
    C_estimate          = process.C_estimate;
    min_alti            = process.min_alti;
    limited_thickness   = process.limited_thickness;  
    

    %% -- initialization
    tic;
    [dem_grid_SLBL_small, ~]  = reduce_size(dem_grid, dem_metadata, mask_range); %reduce grid size to speed the processing
    [mask_grid_SLBL_small, ~] = reduce_size(mask_grid, dem_metadata, mask_range);
	
	%increase mask size to take also the borders
	xmin            = mask_range(1)-1; 
    xmax            = mask_range(2)+1;
    ymin            = mask_range(3)-1;
    ymax            = mask_range(4)+1;
    thickness_grid_small  = zeros(size(mask_grid_SLBL_small));
	
    SLBL_process.thickness               = thickness;
    SLBL_process.C_estimate              = C_estimate;
    SLBL_process.min_alti                = min_alti;
    SLBL_process.limited_thickness       = limited_thickness;
    SLBL_process.mask_grid               = mask_grid_SLBL_small;
    SLBL_process.dem_grid                = dem_grid_SLBL_small;
    SLBL_process.thickness_grid          = thickness_grid_small;
    SLBL_process.steps                   = 0;
    SLBL_process.volume_step             = volume_threshold+1;
    SLBL_process.volume_total            = 0;
    
    while SLBL_process.volume_step>volume_threshold %slbl loop
       SLBL_process.steps = SLBL_process.steps + 1;       
       [SLBL_process] = SLBL_step(SLBL_process); 
       SLBL_process.volume_total = SLBL_process.volume_total + SLBL_process.volume_step;
    end
    
    dem_grid_SLBL = dem_grid;
    dem_grid_SLBL((ymin:ymax),(xmin:xmax))= SLBL_process.dem_grid;
    thickness_grid_SLBL = zeros(size(dem_grid_SLBL));
    thickness_grid_SLBL((ymin:ymax),(xmin:xmax)) = SLBL_process.thickness_grid;
    volume_total = SLBL_process.volume_total*dem_metadata.cellsize^2;
    
    %time to process
    fprintf('SLBL proceeded in : %d steps\n', SLBL_process.steps) 
    processing_time = toc;
    compute_time = [num2str(floor(processing_time /60)) ' minutes ' num2str(mod(processing_time ,60)) ' secondes -- ' num2str(SLBL_process.steps) ' steps\n'];
    fprintf(compute_time);
end
