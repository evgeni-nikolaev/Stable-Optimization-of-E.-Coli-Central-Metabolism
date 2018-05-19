%=====================================================================
% FUNCTION: print_max_rate_ratios_file_mod
%=====================================================================
function [done] = print_max_rate_ratios_file_mod(fid, rmax0, rmax, r_des_ind)
%
% PURPOSE: prints maximal rates and design variables to file
%
done = 0;   % MATLAB requires at least one return parameter

ind = 1;  fprintf(fid, '1).  PTS        %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 2;  fprintf(fid, '2).  PGI        %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 3;  fprintf(fid, '3).  PFK        %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 4;  fprintf(fid, '4).  ALDO       %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 5;  fprintf(fid, '5).  TIS        %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 6;  fprintf(fid, '6).  GAPDH      %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 7;  fprintf(fid, '7).  PGK        %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 8;  fprintf(fid, '8).  PGM        %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 9;  fprintf(fid, '9).  ENO        %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 10; fprintf(fid, '10). PK         %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 11; fprintf(fid, '11). PDH        %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 12; fprintf(fid, '12). PepCxylase %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 13; fprintf(fid, '13). PGlucoM    %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 14; fprintf(fid, '14). G1PAT      %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 15; fprintf(fid, '15). RPPK       %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 16; fprintf(fid, '16). G3PDH      %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 17; fprintf(fid, '17). SerSynth   %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 18; fprintf(fid, '18). Synth1     %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 19; fprintf(fid, '19). Synth2     %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 20; fprintf(fid, '20). DAHPS      %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 21; fprintf(fid, '21). G6PDH      %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 22; fprintf(fid, '22). PGDH       %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 23; fprintf(fid, '23). Ru5P       %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 24; fprintf(fid, '24). R5PI       %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 25; fprintf(fid, '25). TKa        %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 26; fprintf(fid, '26). TKb        %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 27; fprintf(fid, '27). TA         %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 28; fprintf(fid, '28). MurSynth   %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 29; fprintf(fid, '29). TrpSynth   %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind = 30; fprintf(fid, '30). MetSynth   %18.12f   %18.12f   %18.12f', rmax0(ind), rmax(ind), rmax(ind)/rmax0(ind) ); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid,'\n');

done = 1;   % MATLAB requires at least one return parameter
% END OF FUNCTION: print_max_rates_file_mod