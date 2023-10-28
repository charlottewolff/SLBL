function SLBL_process_results(process)
%function SLBL_process_results(dem_file, mask_file, save_path, thickness, Lrh, C_estimate, min_alti, SLBL_inverse)
% %     global volume_threshold
% %     global plot_surface_ON_mask
% %     global show_plot
    volume_threshold        = process.volume_threshold;
    plot_surface_ON_mask    = process.plot_surface_ON_mask;
    show_plot               = process.show_plot;
    dem_file                = process.dem_file;
    mask_file               = process.mask_file;
    save_path               = process.save_path;
    thickness               = process.thickness;
    Lrh                     = process.Lrh;
    C_estimate              = process.C_estimate;
    min_alti                = process.min_alti;
    SLBL_inverse            = process.SLBL_inverse;
    
    fprintf('----------------------------\n');
    fprintf('Input DEM : %s \n', dem_file);
    fprintf('Input mask : %s \n', mask_file);
    fprintf('Given thickness : %f \n', thickness);
    fprintf('Given Lrh : %f \n', Lrh);
    fprintf('Volume threshold to stop processing : %f\n', volume_threshold);
    fprintf('Minimum altitude to stop processing : %f\n', min_alti);

    %% -- read files
    [mask_grid, mask_metadata]  = AscReadFull(mask_file);
    [dem_grid, dem_metadata]    = AscReadFull(dem_file);
    [~,dem_name,~] = fileparts(dem_file);
    [~,mask_name,~] = fileparts(mask_file);
    process.mask_grid       = mask_grid;
    process.mask_metada     = mask_metadata;
    process.dem_grid        = dem_grid;
    process.dem_metadata    = dem_metadata;
    process.dem_name        = dem_name;
    process.mask_name       = mask_name;
    
    if ~exist(save_path, 'dir')
       mkdir(save_path);
    end

    %% -- process SLBL
    mask_range = mask_range_compute(mask_grid); %gives [x_min x_max y_min y_max]
    surface_mask = surface_mask_compute(mask_grid, mask_metadata, mask_range);
    process.mask_range = mask_range;
    process.surface_mask = surface_mask;
    if C_estimate<0
        C_estimate = tolerance(thickness, surface_mask, mask_metadata.cellsize);
        process.C_estimate = C_estimate;
    end
    
    fprintf('-----------\nSLBL will start\n')
    % SLBL inverse if needed
    if SLBL_inverse
        top_grid = ones(size(dem_grid)).*(2*(max(max(dem_grid))));
        dem_grid_inverse = top_grid-dem_grid;
        process.dem_grid = dem_grid_inverse;
        fprintf('Inverse SLBL will be processed\n');
        [dem_grid_SLBL_inverse, ~, volume_total, ~] = compute_SLBL(process);
        dem_grid_SLBL = top_grid - dem_grid_SLBL_inverse;
    else
        [dem_grid_SLBL, ~, volume_total, ~] = compute_SLBL(process);
    end
    fprintf('SLBL volume : %f\n', volume_total);
    
    %% -- plot results
    ini_name    = replace(strjoin(['ini_' dem_name '_' mask_name '_thick' num2str(thickness) '.fig']), ' ', ''); 
    slbl_name   = replace(strjoin(['slbl_' dem_name '_' mask_name '_thick' num2str(thickness) '.fig']), ' ', ''); 
    file_pathFIG_ini    = fullfile(save_path, ini_name);
    file_pathFIG_slbl   = fullfile(save_path, slbl_name);
    fprintf('Preparing plot\n');
    if ~plot_surface_ON_mask
        result_plot1 = plot_ini_dem_erosion(dem_grid, dem_grid_SLBL, volume_total, dem_metadata, thickness, file_pathFIG_ini, show_plot);
        result_plot2 = plot_SLBL_dem(dem_grid_SLBL, volume_total, dem_metadata, thickness, file_pathFIG_slbl, show_plot);
    else
        [dem_grid_small, dem_metadata_small] = reduce_size(dem_grid, dem_metadata, mask_range);
        [dem_grid_SLBL_small, ~] = reduce_size(dem_grid_SLBL, dem_metadata, mask_range);
        result_plot1 = plot_ini_dem_erosion(dem_grid_small, dem_grid_SLBL_small, volume_total, dem_metadata_small, thickness, file_pathFIG_ini, show_plot);
        result_plot2 = plot_SLBL_dem(dem_grid_SLBL_small, volume_total, dem_metadata_small, thickness, file_pathFIG_slbl, show_plot);
    end
    
    %% -- save new slbl
    asc_name = replace(strjoin(['slbl_' dem_name '_' mask_name '_thick' num2str(thickness) '.asc']), ' ', ''); 
    file_pathASC = fullfile(save_path, asc_name);
    AscWriteFull(dem_grid_SLBL, dem_metadata, file_pathASC);
end