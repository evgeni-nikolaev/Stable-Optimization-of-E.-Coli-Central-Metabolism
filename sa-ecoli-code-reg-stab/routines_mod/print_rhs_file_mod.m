%=====================================================================
% FUNCTION: print_rhs_file
%=====================================================================
function [done] = print_rhs_file(fid, rhs)
%
% PURPOSE: 
% 
done = 0;   % MATLAB requires at least one return parameter

fprintf(fid, '1).  c_g6p    --> %12.6e\n', rhs(1)); 
fprintf(fid, '2).  c_f6p    --> %12.6e\n', rhs(2));
fprintf(fid, '3).  c_fdp    --> %12.6e\n', rhs(3));
fprintf(fid, '4).  c_gap    --> %12.6e\n', rhs(4));
fprintf(fid, '5).  c_dhap   --> %12.6e\n', rhs(5));
fprintf(fid, '6).  c_pgp    --> %12.6e\n', rhs(6));
fprintf(fid, '7).  c_3pg    --> %12.6e\n', rhs(7));
fprintf(fid, '8).  c_2pg    --> %12.6e\n', rhs(8));
fprintf(fid, '9).  c_pep    --> %12.6e\n', rhs(9));
fprintf(fid, '10). c_pyr    --> %12.6e\n', rhs(10));
fprintf(fid, '11). c_6pg    --> %12.6e\n', rhs(11));
fprintf(fid, '12). c_ribu5p --> %12.6e\n', rhs(12));
fprintf(fid, '13). c_xyl5p  --> %12.6e\n', rhs(13));
fprintf(fid, '14). c_sed7p  --> %12.6e\n', rhs(14));
fprintf(fid, '15). c_rib5p  --> %12.6e\n', rhs(15));
fprintf(fid, '16). c_e4p    --> %12.6e\n', rhs(16));
fprintf(fid, '17). c_g1p    --> %12.6e\n', rhs(17));
fprintf(fid,'\n');

done = 1;   % MATLAB requires at least one return parameter
% END OF FUNCTION: print_rhs_file