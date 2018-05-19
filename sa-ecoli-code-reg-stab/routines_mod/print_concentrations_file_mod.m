%=====================================================================
% FUNCTION: print_concentrations_file_mod
%=====================================================================
function [done] = print_concentrations_file_mod(fid, c)
%
% PURPOSE: prints concentrations to file
%
done = 0;   % MATLAB requires at least one return parameter

%---------------------------------------------------------------------
% Dynamic Concentrations
%---------------------------------------------------------------------
fprintf(fid,'Dynamic Concentrations\n');
fprintf(fid, '1).  c_g6p    = %17.10f\n', c(1)); 
fprintf(fid, '2).  c_f6p    = %17.10f\n', c(2));
fprintf(fid, '3).  c_fdp    = %17.10f\n', c(3));
fprintf(fid, '4).  c_gap    = %17.10f\n', c(4));
fprintf(fid, '5).  c_dhap   = %17.10f\n', c(5));
fprintf(fid, '6).  c_pgp    = %17.10f\n', c(6));
fprintf(fid, '7).  c_3pg    = %17.10f\n', c(7));
fprintf(fid, '8).  c_2pg    = %17.10f\n', c(8));
fprintf(fid, '9).  c_pep    = %17.10f\n', c(9));
fprintf(fid, '10). c_pyr    = %17.10f\n', c(10));
fprintf(fid, '11). c_6pg    = %17.10f\n', c(11));
fprintf(fid, '12). c_ribu5p = %17.10f\n', c(12));
fprintf(fid, '13). c_xyl5p  = %17.10f\n', c(13));
fprintf(fid, '14). c_sed7p  = %17.10f\n', c(14));
fprintf(fid, '15). c_rib5p  = %17.10f\n', c(15));
fprintf(fid, '16). c_e4p    = %17.10f\n', c(16));
fprintf(fid, '17). c_g1p    = %17.10f\n', c(17));
fprintf(fid,'\n');

%---------------------------------------------------------------------
% External Concentrations
%---------------------------------------------------------------------
fprintf(fid,'External Concentrations\n');
global c_glc_ext;
fprintf(fid, '1).  c_glc_ext = %17.10f\n', c_glc_ext); 
fprintf(fid,'\n');

%---------------------------------------------------------------------
% Fixed Concentrations
%---------------------------------------------------------------------
fprintf(fid,'Fixed Concentrations\n');
global c_atp c_adp c_amp c_nadph c_nadp c_nadh c_nad;
fprintf(fid, '1).  c_atp   = %17.10f\n', c_atp); 
fprintf(fid, '2).  c_adp   = %17.10f\n', c_adp); 
fprintf(fid, '3).  c_amp   = %17.10f\n', c_amp); 
fprintf(fid, '4).  c_nadph = %17.10f\n', c_nadph); 
fprintf(fid, '5).  c_nadp  = %17.10f\n', c_nadp); 
fprintf(fid, '6).  c_nadh  = %17.10f\n', c_nadh); 
fprintf(fid, '7).  c_nad   = %17.10f\n', c_nad); 
fprintf(fid,'\n');

done = 1;   % MATLAB requires at least one return parameter
% END OF FUNCTION: print_concentrations_file_mod