function C_estimate = tolerance(thickness, Lrh, cellsize)
	%Function : 	estimate the tolerance value from thickness and surface
    C_estimate = 4*(thickness/Lrh)*(cellsize^2);
    fprintf('Tolerance estimated : %f\n', C_estimate);
end