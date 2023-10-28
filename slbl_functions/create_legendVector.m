function [X_vector, Y_vector] = create_legendVector(metadata)

    X_vector = [];
    Y_vector = [];
    
    for i=1:metadata.ncols
        X_vector = [X_vector metadata.xllcorner+(i-1)*metadata.cellsize];
    end
    for j=1:metadata.nrows
        Y_vector = [Y_vector metadata.yllcorner+(j-1)*metadata.cellsize];
    end
end