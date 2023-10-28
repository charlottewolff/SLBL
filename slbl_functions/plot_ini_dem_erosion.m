function result_plot = plot_ini_dem_erosion(dem_grid, dem_grid_SLBL, volume_total, dem_metadata, thickness, save_path, varagin)
    %Function : 	plot in 3d the original with landslide volume draped on the topography

	[X_vector, Y_vector] = create_legendVector(dem_metadata);
    
    if nargin>6 && ~varagin
        fprintf('Result not plotted\n');
        figure('name',[num2str(thickness) ' - Depth between original topography and computed surface [m]'],'position',[1 1 800 800],'PaperType','A3','PaperOrientation','landscape','PaperPositionMode','auto', 'visible', 'off')
    else
        figure('name',[num2str(thickness) ' - Depth between original topography and computed surface [m]'],'position',[1 1 800 800],'PaperType','A3','PaperOrientation','landscape','PaperPositionMode','auto')
    end
    
    h = surf(X_vector, Y_vector, dem_grid, dem_grid-dem_grid_SLBL);
 	set(gca,'FontSize',16)
    title_name = ['Depth draped on original topography -- Total volume eroded : ' num2str(volume_total) 'm^3'];
    title(title_name)
	view(-30,25)
	light('Position',[1500 0 2500],'Style','infinite')
	lightangle(315,45);
	colorbar
    
	if min(size(dem_grid,1),size(dem_grid,2))>100
        set(h,'EdgeColor','none')
    end   
	lighting flat
	axis equal
	xlabel('Easting')
            
	xticks('manual')
	yticks('manual')
 	zticks('manual')
            
 	ylabel('Northing')
 	zlabel('Altitude [masl]')
    
    result_plot = gcf;
    saveas(result_plot, save_path, 'fig');
end