function AscWriteFull(grid, meta, filename)
	%Function : 	Write in .asc file the grid and its metadata
	%Input : 		
	%				grid = matrice if the grid to write
	%				meta = metadata of the grid
	%				filename = full path of the file to write. If exist, overwritten 
	
    fid = fopen(filename, 'wt');

    % Write header
    fprintf(fid, 'ncols \t %g\n', meta.ncols);
    fprintf(fid, 'nrows \t %g\n', meta.nrows);
    fprintf(fid, 'xllcorner \t %.3f\n', meta.xllcorner);
    fprintf(fid, 'yllcorner \t %.3f\n', meta.yllcorner);
    fprintf(fid, 'cellsize \t %.3f\n', meta.cellsize);
    fprintf(fid, 'NODATA_value \t %g\n', meta.nan);

    % Write grid
    for i=1:meta.nrows
        for j=1:meta.ncols
            fprintf(fid, '%g \t', grid(i,j));
        end
        fprintf(fid,'\n');
    end
    fclose(fid);
end