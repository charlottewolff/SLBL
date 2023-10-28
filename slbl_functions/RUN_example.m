clear 

p.dem_file    = "C:\Users\charl\Desktop\test\p2_s5_dem_r5.asc";
p.mask_file   = "C:\Users\charl\Desktop\test\p2_s5_source_r5.asc";
p.save_path   = 'C:\Users\charl\Desktop\test\s5';



p.thickness               = 110;
p.Lrh                     = 800;
p.C_estimate              = 1;       %TOLERANCE : %negative value-->will be estimated %positive value-->takes user input
p.min_alti                = 0;
p.SLBL_inverse            = 0;        %bool - 0:no 1:yes
p.volume_threshold        = 0.1;
p.plot_surface_ON_mask    = 1;        %bool - 0:plot on dsm_surface 1:plot on mask surface
p.show_plot               = 1;        %bool - 0:dont display 1:display
p.limited_thickness       = 0;        %bool - 0:dont limit the maximum thickness 1:limit the thickness to the estimated one



SLBL_process_results(p)
                    
