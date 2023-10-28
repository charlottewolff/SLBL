function tolerance = compute_tolerance(thickness, Lrh, cellsize)
	%Function : 	estimate the tolerance value from thickness and surface
    tolerance = 4*(thickness/Lrh)*(cellsize^2);
    fprintf('Tolerance estimated : %f\n', tolerance);
end