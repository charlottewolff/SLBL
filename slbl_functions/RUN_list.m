clear 
close all 

%p.dem_file    = "C:\Users\charl\Downloads\ruoshen\dtm1114_dem.txt";
mask_path     = "C:\Users\charl\Downloads\ruoshen\list.txt";
volume_file   = "C:\Users\charl\Downloads\ruoshen\liuzi.txt";
p.save_path   = "C:\Users\charl\Downloads\ruoshen";






p.thickness               = 100;
p.Lrh                     = 100;
p.C_estimate              = 0;       %TOLERANCE : %negative value-->will be estimated %positive value-->takes user input
p.min_alti                = 0;
p.SLBL_inverse            = 1;        %bool - 0:no 1:yes
p.volume_threshold        = 1;
p.plot_surface_ON_mask    = 0;        %bool - 0:plot on dsm_surface 1:plot on mask surface
p.show_plot               = 0;        %bool - 0:dont display 1:display
p.limited_thickness       = 0;        %bool - 0:dont limit the maximum thickness 1:limit the thickness to the estimated one

fid=fopen(mask_path);
writeid = fopen(volume_file,'w');
path = fgetl(fid);
Volumes = [];
while ischar(path)
    path_list   = split(path,";");
    p.dem_file  = string(path_list(1));
    p.mask_file = string(path_list(2));
    [V,D,M]     = SLBL_process_results_l(p);
    Volumes     = [Volumes ; V];
    volume_string = append(D,';',M,';',int2str(V),'\n')
    fprintf(writeid, volume_string);
    path = fgetl(fid);
end
fclose(fid);
fclose(writeid);
Volumes

%SLBL_process_results(p)
                    



