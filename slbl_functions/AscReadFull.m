function [grid,meta] = AscReadFull(asc_filename)
	%Function : 	Import asc_file and convert in matrice and metadata
	%Input : 		full path to file to import

    fid = fopen(asc_filename,'rt');

    % Scan header
    meta.ncols = fscanf(fid,'%*s %u',1);
    meta.nrows = fscanf(fid,'%*s %u',1);
    meta.xllcorner = fscanf(fid,'%*s %g',1);
    meta.yllcorner = fscanf(fid,'%*s %g',1);
    meta.cellsize = fscanf(fid,'%*s %g',1);
    meta.nan = fscanf(fid,'%*s %e',1);
    
	% Scan grid
    grid = fscanf(fid,'%g',[meta.ncols meta.nrows]);
    
	% Transpose
    grid = grid';
    fclose(fid);
end