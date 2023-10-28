function result_plot = plot_SLBL_dem(dem_grid_SLBL, volume_total, dem_metadata, thickness, save_path, varagin)
	%Function : 	plot in 3d the result of the SLBL 

    [X_vector, Y_vector] = create_legendVector(dem_metadata);
    
    if nargin>5 && ~varagin
        fprintf('Result not plotted\n');
        figure('name',[num2str(thickness) ' - Depth between original topography and computed surface [m]'],'position',[1 1 800 800],'PaperType','A3','PaperOrientation','landscape','PaperPositionMode','auto', 'visible', 'off')
    else
        figure('name',[num2str(thickness) ' - Depth between original topography and computed surface [m]'],'position',[1 1 800 800],'PaperType','A3','PaperOrientation','landscape','PaperPositionMode','auto')
    end
        
    h=surf(X_vector,Y_vector,dem_grid_SLBL, dem_grid_SLBL);
	set(gca,'FontSize',16)
    
	if min(size(dem_grid_SLBL,1),size(dem_grid_SLBL,2))>100
        set(h,'EdgeColor','none')
    end
    
    title_name = ['DEM after SLBL -- Volume eroded : ' num2str(volume_total) 'm^3'];
	title(title_name)
    view(-30,25)
    light('Position',[1500 0 2500],'Style','infinite')
    lightangle(315,45);
    lighting flat
    colorbar
    axis equal       
    xlabel('Easting')
    ylabel('Northing')
    zlabel('Altitude [masl]')
    xticks('manual')
    yticks('manual')
    zticks('manual')
    result_plot = gcf;
    fprintf('Writting results in file');
    saveas(result_plot, save_path, 'fig');
    fprintf('Writting DONE !');
end