%=====================================================================
% FUNCTION: print_max_rates_file_mod
%=====================================================================
function [done] = print_max_rates_file_mod(fid, rmax, r_des_ind)
%
% PURPOSE: prints maximal rates and design variables to file
%
done = 0;   % MATLAB requires at least one return parameter

fprintf(fid, '1).  r_PTS_max        = %17.10f', rmax(1)); if 1 == size( find(r_des_ind==1) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '2).  r_PGI_max        = %17.10f', rmax(2)); if 1 == size( find(r_des_ind==2) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '3).  r_PFK_max        = %17.10f', rmax(3)); if 1 == size( find(r_des_ind==3) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '4).  r_ALDO_max       = %17.10f', rmax(4)); if 1 == size( find(r_des_ind==4) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '5).  r_TIS_max        = %17.10f', rmax(5)); if 1 == size( find(r_des_ind==5) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '6).  r_GAPDH_max      = %17.10f', rmax(6)); if 1 == size( find(r_des_ind==6) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '7).  r_PGK_max        = %17.10f', rmax(7)); if 1 == size( find(r_des_ind==7) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '8).  r_PGM_max        = %17.10f', rmax(8)); if 1 == size( find(r_des_ind==8) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '9).  r_ENO_max        = %17.10f', rmax(9)); if 1 == size( find(r_des_ind==9) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '10). r_PK_max         = %17.10f', rmax(10)); if 1 == size( find(r_des_ind==10) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '11). r_PDH_max        = %17.10f', rmax(11)); if 1 == size( find(r_des_ind==11) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '12). r_PepCxylase_max = %17.10f', rmax(12)); if 1 == size( find(r_des_ind==12) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '13). r_PGlucoM_max    = %17.10f', rmax(13)); if 1 == size( find(r_des_ind==13) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '14). r_G1PAT_max      = %17.10f', rmax(14)); if 1 == size( find(r_des_ind==14) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '15). r_RPPK_max       = %17.10f', rmax(15)); if 1 == size( find(r_des_ind==15) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '16). r_G3PDH_max      = %17.10f', rmax(16)); if 1 == size( find(r_des_ind==16) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '17). r_SerSynth_max   = %17.10f', rmax(17)); if 1 == size( find(r_des_ind==17) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '18). r_Synth1_max     = %17.10f', rmax(18)); if 1 == size( find(r_des_ind==18) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '19). r_Synth2_max     = %17.10f', rmax(19)); if 1 == size( find(r_des_ind==19) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '20). r_DAHPS_max      = %17.10f', rmax(20)); if 1 == size( find(r_des_ind==20) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '21). r_G6PDH_max      = %17.10f', rmax(21)); if 1 == size( find(r_des_ind==21) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '22). r_PGDH_max       = %17.10f', rmax(22)); if 1 == size( find(r_des_ind==22) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '23). r_Ru5P_max       = %17.10f', rmax(23)); if 1 == size( find(r_des_ind==23) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '24). r_R5PI_max       = %17.10f', rmax(24)); if 1 == size( find(r_des_ind==24) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '25). r_TKa_max        = %17.10f', rmax(25)); if 1 == size( find(r_des_ind==25) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '26). r_TKb_max        = %17.10f', rmax(26)); if 1 == size( find(r_des_ind==26) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '27). r_TA_max         = %17.10f', rmax(27)); if 1 == size( find(r_des_ind==27) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '28). r_MurSynth_max   = %17.10f', rmax(28)); if 1 == size( find(r_des_ind==28) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '29). r_TrpSynth_max   = %17.10f', rmax(29)); if 1 == size( find(r_des_ind==29) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid, '30). r_MetSynth_max   = %17.10f', rmax(30)); if 1 == size( find(r_des_ind==30) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
fprintf(fid,'\n');

done = 1;   % MATLAB requires at least one return parameter
% END OF FUNCTION: print_max_rates_file_mod