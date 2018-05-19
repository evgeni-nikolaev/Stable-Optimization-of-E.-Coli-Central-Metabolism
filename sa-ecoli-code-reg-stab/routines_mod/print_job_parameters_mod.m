%=====================================================================
% FUNCTION: print_job_parameters_mod
%=====================================================================
function [done] = print_job_parameters_mod(fid, job_name)
%
% PURPOSE: Prints all input parameters to a file
%
done = 0;   % MATLAB requires at least one return parameter
[date] = fix(clock);

num = 1;

fprintf(fid,'%1d. DATE: %4d-%2d-%2d, %2d:%2d:%2d\n',num, date);             num = num + 1;
fprintf(fid,'%1d. %s\n\n', num, job_name); num = num + 1;

%----------------------------------------------------------------------
% CONTROL PARAMETERS
%----------------------------------------------------------------------
fprintf(fid,'%1d. CONTROL PARAMETERS\n', num);    num = num + 1;
global C_VAR;
fprintf(fid,'C_VAR = %12.6f\n', C_VAR);

global OPT_FLUX_IND;
fprintf(fid,'OPT_FLUX_IND = %3d\n\n',OPT_FLUX_IND);

global INT_IC DC_FACTOR;
fprintf(fid,'INT_IC = %1d\nDC_FACTOR = %6.3f\n\n',INT_IC, DC_FACTOR);

global NUM_MIN NUM_MAX;
fprintf(fid,'NUM_MIN = %9.3e\nNUM_MAX = %9.3e\n\n', NUM_MIN, NUM_MAX);

global CP iter_SA_CP;
fprintf(fid,'CP = %1d\niter_SA_CP = %6d\n\n', CP, iter_SA_CP);

fprintf(fid,'%1d. OPTIMIZATION PARAMETERS\n', num);    num = num + 1;
global tolCon_opt tolFun_opt tolX_opt maxFunEvals maxIter;
fprintf(fid,'tolCon_opt = %9.3e\ntolFun_opt = %9.3e\ntolX_opt   = %9.3e\n\n', tolCon_opt, tolFun_opt, tolX_opt);

%----------------------------------------------------------------------
% INTEGRATION PARAMETERS
%----------------------------------------------------------------------
fprintf(fid,'%1d. INTEGRATION PARAMETERS\n', num);    num = num + 1;
global tEnd_ode nInt absErr_ode relErr_ode;
fprintf(fid,'tEnd_ode = %9.3e\nnInt = %3d\n\n', tEnd_ode, nInt);
fprintf(fid,'absErr_ode = %9.3e\nrelErr_ode = %9.3e\n\n', absErr_ode, relErr_ode);

global RHS_ERR_MIN RHS_ERR_MAX;
fprintf(fid,'RHS_ERR_MIN = %9.3e\nRHS_ERR_MAX = %9.3e\n\n', RHS_ERR_MIN, RHS_ERR_MAX);

%----------------------------------------------------------------------
% NEWTON ITERATION PARAMETERS
%----------------------------------------------------------------------
fprintf(fid,'%1d. NEWTON ITERATIONS PARAMETERS\n', num);   num = num + 1;

global CODE_neq;
fprintf(fid,'CODE_neq = %2d\n', CODE_neq);

if 1 == CODE_neq
    global tolFun_neq tolX_neq ALG_neq maxFunEval_neq maxIter_neq;
    fprintf(fid,'tolFun_neq = %9.3e\ntolX_neq   = %9.3e\nALG_neq = %s\n', tolFun_neq, tolX_neq, ALG_neq);
    fprintf(fid,'maxFunEval_neq = %4d\nmaxIter_neq = %4d\n\n', maxFunEval_neq, maxIter_neq);    
else
    fprintf(fid,'\n');
end

%----------------------------------------------------------------------
% ORIGINAL MAXIMAL RATES
%----------------------------------------------------------------------
fprintf(fid,'%1d. ORIGINAL MAXIMAL RATES\n', num);  num = num + 1;
global rmax0 r_des_ind;
print_max_rates_file_mod(fid, rmax0, r_des_ind);

%----------------------------------------------------------------------
% ORIGINAL REACTION RATES
%----------------------------------------------------------------------
fprintf(fid,'%1d. ORIGINAL REACTION RATES\n', num);  num = num + 1;
global r0;
print_reaction_rates_file_mod(fid, r0);

%----------------------------------------------------------------------
% ORIGINAL STEADY STATE CONCENTRATIONS
%----------------------------------------------------------------------
fprintf(fid,'%1d. ORIGINAL STEADY STATE CONCENTRATIONS\n', num); num = num + 1;
global c0;
print_concentrations_file_mod(fid, c0);

%----------------------------------------------------------------------
% RHS EVALUATION AT THE ORIGINAL STEADY STATE
%----------------------------------------------------------------------

%global rmax K

fprintf(fid,'%1d. RHS EVALUATION AT THE ORIGINAL STEADY STATE\n', num); num = num + 1;
rhs0 = ecoli_reuss_rhs_mod(0,c0);
print_rhs_file_mod(fid, rhs0);

fprintf(fid,'eigenvalues:\n', num);
print_stability_analysis_file_mod(fid, c0);
fprintf(fid,'\n');

%----------------------------------------------------------------------
% FLUX CONTROL COEFFICIENTS AT THE INITIAL WORK PARAMETERS
%----------------------------------------------------------------------
global fcc OPT_FLUX_IND n_rts;
fprintf(fid,'%1d. FLUX CONTROL COEFFICIENTS AT THE INITIAL WORK PARAMETERS\n', num); num = num + 1;
fprintf(fid,'Tested reference flux: %3d\n', OPT_FLUX_IND);

fcc_sum = 0;
for i=1:n_rts
    fcc_sum = fcc_sum + fcc(i);
end    
fprintf(fid,'The sum of fcc: %16.8f\n', fcc_sum);

fprintf(fid, '1).  r_PTS_max        : %16.8f\n', fcc(1)); 
fprintf(fid, '2).  r_PGI_max        : %16.8f\n', fcc(2)); 
fprintf(fid, '3).  r_PFK_max        : %16.8f\n', fcc(3)); 
fprintf(fid, '4).  r_ALDO_max       : %16.8f\n', fcc(4)); 
fprintf(fid, '5).  r_TIS_max        : %16.8f\n', fcc(5)); 
fprintf(fid, '6).  r_GAPDH_max      : %16.8f\n', fcc(6)); 
fprintf(fid, '7).  r_PGK_max        : %16.8f\n', fcc(7)); 
fprintf(fid, '8).  r_PGM_max        : %16.8f\n', fcc(8)); 
fprintf(fid, '9).  r_ENO_max        : %16.8f\n', fcc(9)); 
fprintf(fid, '10). r_PK_max         : %16.8f\n', fcc(10));
fprintf(fid, '11). r_PDH_max        : %16.8f\n', fcc(11));
fprintf(fid, '12). r_PepCxylase_max : %16.8f\n', fcc(12));
fprintf(fid, '13). r_PGlucoM_max    : %16.8f\n', fcc(13));
fprintf(fid, '14). r_G1PAT_max      : %16.8f\n', fcc(14));
fprintf(fid, '15). r_RPPK_max       : %16.8f\n', fcc(15));
fprintf(fid, '16). r_G3PDH_max      : %16.8f\n', fcc(16));
fprintf(fid, '17). r_SerSynth_max   : %16.8f\n', fcc(17));
fprintf(fid, '18). r_Synth1_max     : %16.8f\n', fcc(18));
fprintf(fid, '19). r_Synth2_max     : %16.8f\n', fcc(19));
fprintf(fid, '20). r_DAHPS_max      : %16.8f\n', fcc(20));
fprintf(fid, '21). r_G6PDH_max      : %16.8f\n', fcc(21));
fprintf(fid, '22). r_PGDH_max       : %16.8f\n', fcc(22));
fprintf(fid, '23). r_Ru5P_max       : %16.8f\n', fcc(23));
fprintf(fid, '24). r_R5PI_max       : %16.8f\n', fcc(24));
fprintf(fid, '25). r_TKa_max        : %16.8f\n', fcc(25));
fprintf(fid, '26). r_TKb_max        : %16.8f\n', fcc(26));
fprintf(fid, '27). r_TA_max         : %16.8f\n', fcc(27));
fprintf(fid, '28). r_MurSynth_max   : %16.8f\n', fcc(28));
fprintf(fid, '29). r_TrpSynth_max   : %16.8f\n', fcc(29));
fprintf(fid, '30). r_MetSynth_max   : %16.8f\n', fcc(30));
fprintf(fid,'\n');

%----------------------------------------------------------------------
% FLUX RESPONSE AND ENZYME ELASTICITY COEFFICIENTS AT THE INITIAL WORK PARAMETERS
%----------------------------------------------------------------------
global frc eec reg_enz_ind;

fprintf(fid,'%1d. FEEDFORWARD/FEEDBACK RESPONSE COEFFICIENTS AND ELASTICITIES\n', num); 
fprintf(fid,'     (Tested reference flux: %3d)\n', OPT_FLUX_IND);
fprintf(fid,'                                     rate #              eec              frc          fcc*eec\n');
fprintf(fid, '1).  PTS        inhibition  by  g6p   (%2d): %16.8f %16.8f %16.8f   (31)\n', reg_enz_ind(1),  eec(1),  frc(1),  fcc(reg_enz_ind(1) )*eec(1));
fprintf(fid, '2).  PGI        inhibition  by  6pg   (%2d): %16.8f %16.8f %16.8f   (32)\n', reg_enz_ind(2),  eec(2),  frc(2),  fcc(reg_enz_ind(2) )*eec(2));
fprintf(fid, '3).  PFK        inhibition  by  pep   (%2d): %16.8f %16.8f %16.8f   (33)\n', reg_enz_ind(3),  eec(3),  frc(3),  fcc(reg_enz_ind(3) )*eec(3));
fprintf(fid, '4).  PFK        activation  by  adp   (%2d): %16.8f %16.8f %16.8f   (34)\n', reg_enz_ind(4),  eec(4),  frc(4),  fcc(reg_enz_ind(4) )*eec(4));
fprintf(fid, '5).  PFK        activation  by  amp   (%2d): %16.8f %16.8f %16.8f   (35)\n', reg_enz_ind(5),  eec(5),  frc(5),  fcc(reg_enz_ind(5) )*eec(5));
fprintf(fid, '6).  PK         activation  by  amp   (%2d): %16.8f %16.8f %16.8f   (36)\n', reg_enz_ind(6),  eec(6),  frc(6),  fcc(reg_enz_ind(6) )*eec(6));
fprintf(fid, '7).  PK         activation  by  fdp   (%2d): %16.8f %16.8f %16.8f   (37)\n', reg_enz_ind(7),  eec(7),  frc(7),  fcc(reg_enz_ind(7) )*eec(7));
fprintf(fid, '8).  PK         inhibition  by  atp   (%2d): %16.8f %16.8f %16.8f   (38)\n', reg_enz_ind(8),  eec(8),  frc(8),  fcc(reg_enz_ind(8) )*eec(8));
fprintf(fid, '9).  G1PAT      activation  by  fdp   (%2d): %16.8f %16.8f %16.8f   (39)\n', reg_enz_ind(9),  eec(9),  frc(9),  fcc(reg_enz_ind(9) )*eec(9));
fprintf(fid, '10). G6PDH      inhibition  by  nadph (%2d): %16.8f %16.8f %16.8f   (40)\n', reg_enz_ind(10), eec(10), frc(10), fcc(reg_enz_ind(10))*eec(10));
fprintf(fid, '11). PGDH       inhibition  by  atp   (%2d): %16.8f %16.8f %16.8f   (41)\n', reg_enz_ind(11), eec(11), frc(11), fcc(reg_enz_ind(11))*eec(11));
fprintf(fid, '12). PGDH       inhibition  by  nadph (%2d): %16.8f %16.8f %16.8f   (42)\n', reg_enz_ind(12), eec(12), frc(12), fcc(reg_enz_ind(12))*eec(12));
fprintf(fid, '13). PEPCxylase activatin   by  fdp   (%2d): %16.8f %16.8f %16.8f   (43)\n', reg_enz_ind(13), eec(13), frc(13), fcc(reg_enz_ind(13))*eec(13));

done = 1;   % MATLAB requires at least one return parameter
% END OF FUNCTION: print_job_parameters_mod