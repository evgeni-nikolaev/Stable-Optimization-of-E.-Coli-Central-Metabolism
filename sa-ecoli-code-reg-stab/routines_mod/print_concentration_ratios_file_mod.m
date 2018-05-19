%=====================================================================
% FUNCTION: print_concentration_ratios_file_mod
%=====================================================================
function [done] = print_concentration_ratios_file_mod(fid, c0, c)
%
% PURPOSE: prints steady staes concentrations to file
%
done = 0;   % MATLAB requires at least one return parameter

ind = 1;    fprintf(fid,'1).  g6p    %18.12f   %18.12f   %18.12f\n', c0(ind), c(ind), c(ind)/c0(ind));
ind = 2;    fprintf(fid,'2).  f6p    %18.12f   %18.12f   %18.12f\n', c0(ind), c(ind), c(ind)/c0(ind));
ind = 3;    fprintf(fid,'3).  fdp    %18.12f   %18.12f   %18.12f\n', c0(ind), c(ind), c(ind)/c0(ind));
ind = 4;    fprintf(fid,'4).  gap    %18.12f   %18.12f   %18.12f\n', c0(ind), c(ind), c(ind)/c0(ind));
ind = 5;    fprintf(fid,'5).  dhap   %18.12f   %18.12f   %18.12f\n', c0(ind), c(ind), c(ind)/c0(ind));
ind = 6;    fprintf(fid,'6).  pgp    %18.12f   %18.12f   %18.12f\n', c0(ind), c(ind), c(ind)/c0(ind));
ind = 7;    fprintf(fid,'7).  3pg    %18.12f   %18.12f   %18.12f\n', c0(ind), c(ind), c(ind)/c0(ind));
ind = 8;    fprintf(fid,'8).  2pg    %18.12f   %18.12f   %18.12f\n', c0(ind), c(ind), c(ind)/c0(ind));
ind = 9;    fprintf(fid,'9).  pep    %18.12f   %18.12f   %18.12f\n', c0(ind), c(ind), c(ind)/c0(ind));
ind = 10;   fprintf(fid,'10). pyr    %18.12f   %18.12f   %18.12f\n', c0(ind), c(ind), c(ind)/c0(ind));
ind = 11;   fprintf(fid,'11). 6pg    %18.12f   %18.12f   %18.12f\n', c0(ind), c(ind), c(ind)/c0(ind));
ind = 12;   fprintf(fid,'12). ribu5p %18.12f   %18.12f   %18.12f\n', c0(ind), c(ind), c(ind)/c0(ind));
ind = 13;   fprintf(fid,'13). xyl5p  %18.12f   %18.12f   %18.12f\n', c0(ind), c(ind), c(ind)/c0(ind));
ind = 14;   fprintf(fid,'14). sed7p  %18.12f   %18.12f   %18.12f\n', c0(ind), c(ind), c(ind)/c0(ind));
ind = 15;   fprintf(fid,'15). rib5p  %18.12f   %18.12f   %18.12f\n', c0(ind), c(ind), c(ind)/c0(ind));
ind = 16;   fprintf(fid,'16). e4p    %18.12f   %18.12f   %18.12f\n', c0(ind), c(ind), c(ind)/c0(ind));
ind = 17;   fprintf(fid,'17). g1p    %18.12f   %18.12f   %18.12f\n', c0(ind), c(ind), c(ind)/c0(ind));

done = 1;   % MATLAB requires at least one return parameter
% END OF FUNCTION: print_concentration_ratios_file_mod