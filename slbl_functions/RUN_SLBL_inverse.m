%%%%% -- INPUTS ---------------------------------------------------
mask_filename = "D:\Codes\charlotte\SLBL\data2test\inverse_dataset\mask-1.asc";
dem_filename = "D:\Codes\charlotte\SLBL\data2test\inverse_dataset\test-1_INVERSE.asc";
thickness = 60;
Lrh = 100;
C_estimate = -1;     %TOLERANCE : %negative value-->will be estimated %positive value-->takes user input
volume_threshold = 0.1;
min_alti = 60;
SLBL_inverse = 1; %bool - 0:no 1:yes


%dem_filename = "C:\Users\charl\OneDrive\Documents\SLBL_simano\tolerance_analyse\dsm_fus_clip_asc.asc";
%mask_filename = "C:\Users\charl\OneDrive\Documents\SLBL_simano\tolerance_analyse\dsm_mask-tol.asc";
%%%%% ---------------------------------------------------

%% -- read inputs
[mask_grid, mask_metadata] = AscReadFull(mask_filename);
[dem_grid, dem_metadata] = AscReadFull(dem_filename);

fprintf('Given thickness : %f \n', thickness);

%% -- process SLBL
mask_range = mask_range_compute(mask_grid);
surface_mask = surface_mask_compute(mask_grid, mask_metadata, mask_range);
if C_estimate<0
    C_estimate = tolerance(thickness, surface_mask, mask_metadata.cellsize);
end

% SLBL inverse if needed
if SLBL_inverse % -topography inversion if slbl inverse
    fprintf('SLBL inverse selected\n');
	top_grid = ones(size(dem_grid)).*(2*(max(max(dem_grid)))); 
    dem_grid_inverse = top_grid - dem_grid;
    min_alti = 2*(max(max(dem_grid))) - min_alti;
end

%run slbl with inverse topography
[dem_grid_SLBL, thickness_grid_total, volume_total, compute_time] = compute_SLBL(dem_grid_inverse, dem_metadata, mask_grid, mask_range, volume_threshold, thickness, C_estimate, min_alti);    
if SLBL_inverse
    %back to real topography
    dem_grid_SLBL = top_grid - dem_grid_SLBL;
end


%% -- plot results
[dem_grid_small, dem_metadata_small] = reduce_size(dem_grid, dem_metadata, mask_range);
[dem_grid_SLBL_small, dem_metadata_SLBL_small] = reduce_size(dem_grid_SLBL, dem_metadata, mask_range);
plot_ini_dem_erosion(dem_grid_small, dem_grid_SLBL_small, volume_total, dem_metadata_small, thickness);
plot_SLBL_dem(dem_grid_SLBL_small, volume_total, dem_metadata_small, thickness);

%% -- save new slbl 
if SLBL_inverse
    filename2write = replace(char(dem_filename),'.',[num2str(thickness) '_slblInverse].']);
else
    filename2write = replace(char(dem_filename),'.',[num2str(thickness) '_slbl].']);
end
AscWriteFull(dem_grid_SLBL, dem_metadata, filename2write)
