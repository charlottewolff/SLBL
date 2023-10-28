function [SLBL_step_process] = SLBL_step(SLBL_process)    
    
    mask_grid           = SLBL_process.mask_grid;
    dem_grid            = SLBL_process.dem_grid;
    thickness           = SLBL_process.thickness;
    thickness_grid      = SLBL_process.thickness_grid;
    C_estimate          = SLBL_process.C_estimate;
    min_alti            = SLBL_process.min_alti;

    lim_thickness = 0;
    if isfield(SLBL_process,'limited_thickness') &&  SLBL_process.limited_thickness
        lim_thickness = 1;
    end
    convol_matrice = [0 0.25 0; 0.25 0 0.25; 0 0.25 0];
    
	%matrix with mean value 
    dem_grid_convol = conv2(dem_grid,convol_matrice,'same') - C_estimate;
    volume_step = 0;
    for i = 1:size(dem_grid,1)   %lines
        for j = 1:size(dem_grid,2) %columns
            if dem_grid_convol(i,j) < min_alti %update mask is reached min_alti
                mask_grid(i,j) = 0;
            elseif mask_grid(i,j)&& dem_grid(i,j) > dem_grid_convol(i,j) %apply slbl on mask 
                erosion = (dem_grid(i,j)-dem_grid_convol(i,j));
                thickness_grid(i,j) = thickness_grid(i,j) + erosion;
                volume_step = volume_step + erosion;
                dem_grid(i,j) = dem_grid_convol(i,j);
                
                if thickness_grid(i,j) >= thickness && lim_thickness
                    mask_grid(i,j) = 0;
                end                 
            end                        
        end
    end  
    SLBL_step_process                = SLBL_process;
    SLBL_step_process.thickness_grid = thickness_grid;
    SLBL_step_process.mask_grid      = mask_grid;
    SLBL_step_process.dem_grid       = dem_grid;
    SLBL_step_process.volume_step    = volume_step;
end
