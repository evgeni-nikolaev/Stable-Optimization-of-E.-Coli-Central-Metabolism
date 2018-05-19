%=====================================================================
% FUNCTION: print_reaction_rates_file_mod
%=====================================================================
function [done] = print_reaction_rates_file_mod(fid,r)
%
% PURPOSE: prints maximal rates and design variables to file
%
done = 0;   % MATLAB requires at least one return parameter

fprintf(fid, '1).  r_PTS        = %17.10f\n', r(1)); 
fprintf(fid, '2).  r_PGI        = %17.10f\n', r(2)); 
fprintf(fid, '3).  r_PFK        = %17.10f\n', r(3)); 
fprintf(fid, '4).  r_ALDO       = %17.10f\n', r(4)); 
fprintf(fid, '5).  r_TIS        = %17.10f\n', r(5)); 
fprintf(fid, '6).  r_GAPDH      = %17.10f\n', r(6)); 
fprintf(fid, '7).  r_PGK        = %17.10f\n', r(7)); 
fprintf(fid, '8).  r_PGM        = %17.10f\n', r(8)); 
fprintf(fid, '9).  r_ENO        = %17.10f\n', r(9)); 
fprintf(fid, '10). r_PK         = %17.10f\n', r(10)); 
fprintf(fid, '11). r_PDH        = %17.10f\n', r(11)); 
fprintf(fid, '12). r_PepCxylase = %17.10f\n', r(12)); 
fprintf(fid, '13). r_PGlucoM    = %17.10f\n', r(13)); 
fprintf(fid, '14). r_G1PAT      = %17.10f\n', r(14)); 
fprintf(fid, '15). r_RPPK       = %17.10f\n', r(15)); 
fprintf(fid, '16). r_G3PDH      = %17.10f\n', r(16)); 
fprintf(fid, '17). r_SerSynth   = %17.10f\n', r(17)); 
fprintf(fid, '18). r_Synth1     = %17.10f\n', r(18)); 
fprintf(fid, '19). r_Synth2     = %17.10f\n', r(19)); 
fprintf(fid, '20). r_DAHPS      = %17.10f\n', r(20)); 
fprintf(fid, '21). r_G6PDH      = %17.10f\n', r(21)); 
fprintf(fid, '22). r_PGDH       = %17.10f\n', r(22)); 
fprintf(fid, '23). r_Ru5P       = %17.10f\n', r(23)); 
fprintf(fid, '24). r_R5PI       = %17.10f\n', r(24)); 
fprintf(fid, '25). r_TKa        = %17.10f\n', r(25)); 
fprintf(fid, '26). r_TKb        = %17.10f\n', r(26)); 
fprintf(fid, '27). r_TA         = %17.10f\n', r(27)); 
fprintf(fid, '28). r_MurSynth   = %17.10f\n', r(28)); 
fprintf(fid, '29). r_TrpSynth   = %17.10f\n', r(29)); 
fprintf(fid, '30). r_MetSynth   = %17.10f\n', r(30)); 
fprintf(fid,'\n');

done = 1;   % MATLAB requires at least one return parameter
% END OF FUNCTION: print_reaction_rates_file_mod