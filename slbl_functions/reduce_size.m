function [grid_small, metadata_small] = reduce_size(grid, metadata, mask_range)
	%Function : 	create a new grid and its metadata resized with a new range 
	%Input : 		grid = grid to resize
	%				metadata = grid metadata to resize 
	%				mask_range = [xmin, xmax, ymin ,ymax], the size of the new matrice 
	
    xmin = mask_range(1)-1;
    xmax = mask_range(2)+1;
    ymin = mask_range(3)-1;
    ymax = mask_range(4)+1;
    grid_small = grid([ymin:ymax],[xmin:xmax]);
    
    metadata_small = metadata;
    metadata_small.ncols = xmax - xmin + 1;
    metadata_small.nrows = ymax - ymin + 1;
    metadata_small.xllcorner = metadata.xllcorner + (xmin-1)*metadata.cellsize;
    metadata_small.yllcorner = metadata.yllcorner + (ymin-1)*metadata.cellsize;
end