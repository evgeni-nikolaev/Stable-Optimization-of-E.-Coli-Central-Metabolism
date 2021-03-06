%=====================================================================
% FUNCTION: sa_reg MODIFIED to inculde regulation
%=====================================================================
function [done] = sa_reg
%
% PURPOSE: does simulated annealing calculations
%
% MODIFIED: 2005-12-18
%
done = 0;   % MATLAB requires at least one return parameter
rand('state',sum(100*clock));   % resent random seeds to start with new first trail set

global tBegSA OUT_FLG;
global file_name_LONG;
global file_name_ITER_SHORT file_name_TEMP_SHORT;
global file_name_OPTP_SHORT file_name_FCC_SHORT;

%--------------------------------------------------------------------------
% print original fcc, eec, and frc
%--------------------------------------------------------------------------
print_sa_optimization_results_FCC_SHORT_mod(-1, 1);

%--------------------------------------------------------------------------
% SA iterations
%--------------------------------------------------------------------------
global iter_SA max_iter_SA T_SA L_SA alpha_SA CP iter_SA_CP;

%--------------------------------------------------------------------------
% vector-columns of indeces for modulated enzymes
%--------------------------------------------------------------------------
global NUM_MOD_ENZ;         % the total number of modulated enzymes and regulatory parameters
global Eb Ec Et E0;
global rate_b rate_c rate_t;
Et = zeros(NUM_MOD_ENZ,1);  % a trial set of enzymes and enzyme regulatory parameters
Eb = zeros(NUM_MOD_ENZ,1);  % the best set of enzymes and enzyme regulatory parameters
Ec = zeros(NUM_MOD_ENZ,1);  % a current set of enzymes and enzyme regulatory parameters
E0 = zeros(NUM_MOD_ENZ,1);  % changed move to get of cycle

%--------------------------------------------------------------------------
% best ten enzyme subsets
%--------------------------------------------------------------------------
global best10 Et_used Rt_used;
best10  = zeros(NUM_MOD_ENZ+1,10);
Et_used = zeros(NUM_MOD_ENZ,max_iter_SA); % a set of all previously checked combinations
Rt_used = zeros(1,max_iter_SA); % computed optimal rates corresponding to Et_used

%--------------------------------------------------------------------------
% generate an initial set Et
%--------------------------------------------------------------------------
global fcc n_rts_opt n_reg_opt Et_MAN MAN n_reg_MAN n_rts_MAN;

if CP == 0
    tBeg = cputime;    
    
    iter_SA = 1;
    if 0 == MAN
        Et = generate_initial_enzyme_set(NUM_MOD_ENZ); % random selection
    end
    
    if 1 == MAN
        Et = Et_MAN;    % manual selection
        
        n_reg_opt = n_reg_MAN;
        n_rts_opt = n_rts_MAN;
                
        MAN = 0;
    end    
    
    Eb = Et;
    Ec = Et;
    Et_used(:,1) = Et;    

    %--------------------------------------------------------------------------
    % print out initial set
    %--------------------------------------------------------------------------
    print_sa_optimization_results_OPTP_SHORT_mod(tBeg-tBegSA, 0, 0);

    % debugging output
    if OUT_FLG
        fprintf('SA iter: %4d   T_SA: %12.6e   enzymes and feedbacks:', 1, T_SA);
        for i=1:NUM_MOD_ENZ
            fprintf('%3d ', Et(i));    
        end    
        fprintf('\n');
    end        
        
    %--------------------------------------------------------------------------
    % optimize normilized reaction rate at the initial set of modulated enzymes Et
    %--------------------------------------------------------------------------
    [rdes_opt, r_opt] = optimize_rate(Et);
    rate_t = -r_opt;
    rate_b = rate_t;
    rate_c = rate_b;
    Rt_used(iter_SA) = rate_t;

    % initiate the first best enzyme subset
    best10(1:NUM_MOD_ENZ,1) = Et;
    best10(NUM_MOD_ENZ+1,1) = rate_t;

    % update fcc
    compute_fcc_mod;

    % print protocol to files
    tEnd = cputime;
    print_sa_optimization_results_LONG_mod(rdes_opt, tEnd-tBegSA, tEnd - tBeg);
    write_CP_file(iter_SA, Et, Ec, Eb, rate_t, rate_c, rate_b, T_SA, NUM_MOD_ENZ);        
    
    % debugging output
    if OUT_FLG
        fprintf('initial set of enzymes and feedbacks: ');
        for i=1:NUM_MOD_ENZ
            fprintf('%3d ', Et(i));    
        end    
        fprintf('\n');
    end    
    
end    

% read an initial set from the control point form file
if CP == 1
    read_CP_file;

    % initiate the best enzyme subset
    best10(1:NUM_MOD_ENZ,1) = Eb;
    best10(NUM_MOD_ENZ+1,1) = rate_b;
    
    print_CP_LONG_mod;    
    
end    
    
%--------------------------------------------------------------------------
% SA iterations
%--------------------------------------------------------------------------
global hi rate_aver sigma sigma_norm sel_OUT ind_bk_0 rate_c_0;
hi = 0;                     % acceptance ratio as function of temperature
rate_aver = 0;              % average relaxtion optimal rate as function of temperature
sigma = 0;                  % standard relaxation deviation as function of temperature
sigma_norm = 0;             % normilized deviation as function of temperature
sigma_inf = sigma;          % approximation of standard deviation at initie temperature
rate_L = zeros(1,L_SA);     % array of optimal rates at relaxation iterations
zero_L = rate_L;
ind_L = 0;

iter_SA_BEG = iter_SA + 1;
for iter_SA = iter_SA_BEG:max_iter_SA    
    tBeg = cputime;       
    
    %--------------------------------------------------------------------------
    % select a new trial enzyme subset from EC
    %--------------------------------------------------------------------------
    if 0 == MAN
        sel_OUT = select;   % random selection
    end
        
    if 1 == MAN
        Et = Et_MAN;        % manual selection
                
        n_reg_opt = n_reg_MAN;
        n_rts_opt = n_rts_MAN;
                               
        MAN = 0;
    end    
        
    %--------------------------------------------------------------------------
    % check if all sets have been used and exit
    %--------------------------------------------------------------------------    
    if sel_OUT == 2
        fid = fopen(file_name_LONG,'a');
        fprintf(fid,'\n\nSTOP CONDITION: Et == Ec \n\n');        
        fclose(fid);
        
        fid = fopen(file_name_ITER_SHORT,'a');
        fprintf(fid,'\n\nSTOP CONDITION: Et == Ec \n\n');        
        fclose(fid);

        fid = fopen(file_name_TEMP_SHORT,'a');        
        fprintf(fid,'\n\nSTOP CONDITION: Et == Ec \n\n');        
        fclose(fid);

        fid = fopen(file_name_OPTP_SHORT,'a');
        fprintf(fid,'\n\nSTOP CONDITION: Et == Ec \n\n');        
        fclose(fid);

        fid = fopen(file_name_FCC_SHORT,'a');
        fprintf(fid,'\n\n STOP CONDITION: Et == Ec \n\n');        
        fclose(fid);
        
        break;
    end

    %--------------------------------------------------------------------------
    % check if the current set Ec has been changed to a previous one
    %--------------------------------------------------------------------------    
    if sel_OUT == 1
        rate_c = Rt_used(iter_SA - ind_bk_0);
        rate_c_0 = rate_c;
    end
    
    % debugging output
    if OUT_FLG
        fprintf('SA iter: %4d   T_SA: %12.6e   enzymes and feedbacks:', iter_SA, T_SA);
        for i=1:NUM_MOD_ENZ
            fprintf('%3d ', Et(i));    
        end    
        fprintf('\n');
    end        
        
    %--------------------------------------------------------------------------
    % optimize reaction rate at trial enzyme subset
    %--------------------------------------------------------------------------
    print_sa_optimization_results_OPTP_SHORT_mod(tBeg-tBegSA, 0, 0);    
    [rdes_opt, r_opt] = optimize_rate(Et);
    rate_t = -r_opt;
    Rt_used(iter_SA) = rate_t;
    
    if sel_OUT == 1
        print_MOVE_CHANGE_LONG_mod;        
    end
    
    % update fcc
    compute_fcc_mod;

    % get SA-control statistics
    ind_L = ind_L + 1;
    rate_L(ind_L) = rate_t;
    rate_aver = rate_aver + rate_t; % average rate
    
    %--------------------------------------------------------------------------
    % do annealing
    %--------------------------------------------------------------------------    
    if rate_t > rate_b
        Eb = Et;
        rate_b = rate_t;
        Ec = Et;
        rate_c = rate_t;
        hi = hi + 1;        % Et is accepted
    else
        anneal = exp((rate_t-rate_c)/T_SA);        
        if rand < anneal
            Ec = Et;
            rate_c = rate_t;
            hi = hi + 1;        % Et is accepted            
        end                    
    end        

    %--------------------------------------------------------------------------
    % print relaxation statistics and reset parameters
    %--------------------------------------------------------------------------    
    if mod(iter_SA,L_SA) == 0        
        % print relaxation statistics
        rate_aver = rate_aver/L_SA;
        
        % deviation
        for p=1:L_SA
            sigma = sigma + (rate_L(p)-rate_aver)^2;    
        end  
        sigma = sqrt(sigma/L_SA);
        
        if (iter_SA <= L_SA)
            sigma_inf = sigma;
        end
        if 0 == sigma_inf
            sigma_inf = 1;
        end
        
        sigma_norm = sigma/sigma_inf;
        
        hi = hi/L_SA;   % accepted / proposed transitions
                
        print_sa_optimization_results_TEMP_SHORT_mod(cputime-tBegSA);            
                
        % reset statistical characteristics
        hi = 0;             
        rate_aver = 0;
        rate_L = zero_L;
        ind_L = 0;
        sigma = 0;          
        sigma_norm = 0;
    end        

    %--------------------------------------------------------------------------
    % update 10 best enzyme and feedback subsets
    %--------------------------------------------------------------------------    
    update_10_best;
     
    tEnd = cputime;
    print_sa_optimization_results_LONG_mod(rdes_opt, tEnd-tBegSA, tEnd - tBeg);
    
    %--------------------------------------------------------------------------
    % update temperature
    %--------------------------------------------------------------------------    
    if mod(iter_SA,L_SA) == 0                    
        T_SA = T_SA*alpha_SA;        
    end

    %--------------------------------------------------------------------------
    % update control point file
    %--------------------------------------------------------------------------        
    write_CP_file(iter_SA, Et, Ec, Eb, rate_t, rate_c, rate_b, T_SA, NUM_MOD_ENZ);    
end    

done = 1;   % MATLAB requires at least one return parameter
% END OF FUNCTION: sa_mod

%=====================================================================
% FUNCTION: generate_initial_enzyme_set
%=====================================================================
function [enz_subset] = generate_initial_enzyme_set(NUM_MOD_ENZ)
%
% PURPOSE: generate an initial enzyme and regulatory set
%
% MODIFIED: 2005-12-13
%
global n_rts n_reg n_rts_opt n_reg_opt;

enz_subset = zeros(NUM_MOD_ENZ,1);

%--------------------------------------------------------------------------    
%   pick up NUM_MOD_ENZ enzyme levels and regulatory parameters at random out of 
%   all n_rts enzymes and n_reg regulations: The initial set should have
%   at least one regulatory parameter to optimize
%--------------------------------------------------------------------------
n_set = n_rts + n_reg;

while (enz_subset(NUM_MOD_ENZ) <= n_rts)
    enz_set = randperm(n_set)';
    enz_subset = enz_set(1:NUM_MOD_ENZ);
    enz_subset = sort(enz_subset);
end

% compute how many enzymes and feedbacks are present in the subset
n_rts_opt = 0;
n_reg_opt = 0;
for i=1:NUM_MOD_ENZ
    if enz_subset(i) <= n_rts
        n_rts_opt = n_rts_opt + 1;
    end
end    
n_reg_opt = NUM_MOD_ENZ - n_rts_opt;

% END OF FUNCTION: generate_initial_enzyme_set

%=====================================================================
% FUNCTION: optimize_rate
%=====================================================================
function [rdes_opt, r_opt] = optimize_rate(Et)
%
% PURPOSE: optimize the reaction set for the given set of modulated enzymes
%
% MODIFIED: 2005-12-13

global NUM_MOD_ENZ OUT_FLG;

%--------------------------------------------------------------------------
% reset concentrations, rates, and regulations
%--------------------------------------------------------------------------
global c0 c;
c = c0;

global rmax rmax0 reg n_reg;
rmax = rmax0;
reg = ones(n_reg,1);

%--------------------------------------------------------------------------
% define normilized design variables that correspond to enzyme subset Et
%--------------------------------------------------------------------------
global n_des r_des_ind n_rts n_rts_opt n_reg_opt;
n_des = NUM_MOD_ENZ;    % the number of designed variables
r_des_ind = Et;         % indeces of enzymes and feedbacks

%--------------------------------------------------------------------------
% set starting unit values for (1) normilized design variable and (2) factor q
%--------------------------------------------------------------------------
if n_rts_opt > 0
    rdes_start = ones(n_des+1,1);   % enzyme levels are present and will be optimized
end    

if 0 == n_rts_opt
    rdes_start = ones(n_des,1);     % enzyme levels are absent and won't be optimized
end                                 % and factor q is not needed

%--------------------------------------------------------------------------
% set lower and upper bounds for normalized design variables
%--------------------------------------------------------------------------
[lb,ub] = set_bounds(n_des);

%--------------------------------------------------------------------------
% set row-vector A_eq and number b_eq to keep enzyme level constant
% if these enzyme levels will be optimized
%--------------------------------------------------------------------------
if n_rts_opt > 0    
    [A_eq,b_eq] = set_Ab_eq(n_des,n_rts,n_rts_opt);
end

%--------------------------------------------------------------------------
% OPTIMIZATION
%--------------------------------------------------------------------------
global tolCon_opt tolFun_opt tolX_opt maxFunEvals maxIter display_flg;
options = optimset('LargeScale','off','TolCon',tolCon_opt,'TolFun',tolFun_opt,...
          'TolX',tolX_opt,'MaxFunEvals',maxFunEvals,'MaxIter',maxIter,'Display',display_flg);
      
global rdes_opt exitflag output_opt;

if n_rts_opt > 0    % enzyme levels are optimized
    [rdes_opt, r_opt, exitflag, output_opt, grad] = fmincon(@get_negative_obj_rate, rdes_start, [], [], A_eq, b_eq, lb, ub, @set_global_cons_cnt, options);
end

if 0 == n_rts_opt    % enzyme levels are not optimized
    [rdes_opt, r_opt, exitflag, output_opt, grad] = fmincon(@get_negative_obj_rate, rdes_start, [], [], [], [], lb, ub, @set_global_cons_cnt, options);    
end    

if OUT_FLG
    output_opt
end    

%--------------------------------------------------------------------------
% update rmax and c
%--------------------------------------------------------------------------
update_global_variables(rdes_opt);

% END OF FUNCTION: optimize_rate

%=====================================================================
% FUNCTION: Set_Bounds
%=====================================================================
function [lb,ub] = set_bounds(n_des)
%
% PURPOSE: Sets lower and upper bounds for normalized design variables 
%
global NUM_MIN NUM_MAX n_rts n_rts_opt n_reg_opt;

if n_rts_opt > 0  % enzyme levels will be optimized
    lb = zeros(n_des+1,1);
    ub = zeros(n_des+1,1);
    
    % bounds for enzyme levels
    lb(1:n_rts_opt) = NUM_MIN;
    ub(1:n_rts_opt) = n_rts;

    % bounds for feedbacks    
    lb(n_rts_opt+1:n_des) = NUM_MIN;
    ub(n_rts_opt+1:n_des) = NUM_MAX;
        
    % a bound for factor q        
    lb(n_des+1) = NUM_MIN;
    ub(n_des+1) = n_rts/(n_rts-n_rts_opt);    
end    

if 0 == n_rts_opt   % enzyme levels won't be optimized
    lb = zeros(n_des,1);
    ub = zeros(n_des,1);
    
    % bounds for feedbacks    
    lb(1:n_des) = NUM_MIN;
    ub(1:n_des) = NUM_MAX;    
end    

% END OF FUNCTION: Set_Bounds

%=====================================================================
% FUNCTION: set_Ab_eq
%=====================================================================
function [A_eq,b_eq] = set_Ab_eq(n_des,n_rts,n_rts_opt)
%
% PURPOSE: Sets row-vector A_eq and number b_eq to keep enzyme level constant 
%
% MODIFIED: 2005-12-13
%
A_eq = zeros(1,n_des+1);
A_eq(1:n_rts_opt) = 1;
A_eq(n_des+1) = n_rts - n_rts_opt;
b_eq = n_rts;

% END OF FUNCTION: set_bounds

%=====================================================================
% FUNCTION: update_global_variables
%=====================================================================
function [done]=update_global_variables(rdes)
%
% PURPOSE: Updates all global variables at the optimization iteration
%          Global variabes: 
%           - enzyme levels or maximal rates
%           - feedback regulations
%           - concentrations
%
% MODIFIED: 2005-12-13
%
done = 0;   % MATLAB requires at least one return parameter

global n_des r_des_ind rmax rmax0 n_rts n_rts_opt reg n_reg;

% update values of adjusted variables within rmax and reg arrays
if n_rts_opt > 0 
    rmax = rdes(n_des+1)*rmax0; % factor q = rdes(n_des+1)

    % correct updated values of design variables within rmax array
    for i=1:n_rts_opt
        rmax( r_des_ind(i) ) = rdes(i)*rmax0( r_des_ind(i) );
    end
    
    % correct updated values of design variables within reg array
    reg  = ones(n_reg,1);
    for i=n_rts_opt+1:n_des
        reg( r_des_ind(i)-n_rts ) = rdes(i);
    end
    
end    

% correct updated values of design variables within reg array only   
if 0 == n_rts_opt
    reg  = ones(n_reg,1);    
    for i=1:n_des
        reg( r_des_ind(i)-n_rts ) = rdes(i);
    end    
end    

% update steady-state concentrations
global n_cons c c0 C_VAR;

global INT_IC DC_FACTOR;
if INT_IC > 0
    
    dc = sum( abs( (c-c0)./c0 ) )/n_cons;    
    if dc <= DC_FACTOR*C_VAR
        c = locate_steady_state_cons_mod(c);
    else        
        c = locate_steady_state_cons_mod(c0);    
    end                
    
else
    c = locate_steady_state_cons_mod(c0);
end    

done = 1;   % MATLAB requires at least one return parameter
% END OF FUNCTION: update_global_variables

%=====================================================================
% FUNCTION: get_negative_obj_rate
%=====================================================================
function [r_obj] = get_negative_obj_rate(rdes)
%
% PURPOSE: Compute the objective rate for the optimization

global c;
update_global_variables(rdes); % rmax and c

% compute OPT_FLUX_IND reaction rate
global n_rts OPT_FLUX_IND;
rate = zeros(n_rts,1);
rate = ecoli_reuss_rates_mod(0,c);
r_obj = -rate(OPT_FLUX_IND);

% END OF FUNCTION: get_negative_obj_rate

%=====================================================================
% FUNCTION: set_global_cons_cnt
%=====================================================================
function [all_ineq, dummy]=set_global_cons_cnt(rdes)
%
% PURPOSE: Set global concentration constraint
%
global STAB_MAX C_VAR n_cons c0 c;
update_global_variables(rdes); % rmax and c

% global variation in concentration levels
dc = sum( abs( (c-c0)./c0 ) )/n_cons;    
cnt_ineq = dc - C_VAR;

% maximal negative eigenvalues
global tolFun_neq tolX_neq ALG_neq maxFunEval_neq maxIter_neq;
options_eq = optimset('Display','off','TolFun',tolFun_neq,'TolX',tolX_neq,...
                   'MaxFunEvals',maxFunEval_neq,'MaxIter',maxIter_neq,'NonlEqnAlgorithm',ALG_neq);

[c_ss,fz,exitflag,ouput,jac] = fsolve(@ecoli_reuss_rhs_fun_mod, c, options_eq);

ev = zeros(n_cons,1);
ev = real(eig(jac));
lambda_max = max(ev);

stab_ineq = lambda_max + STAB_MAX;

all_ineq = [cnt_ineq, stab_ineq];
dummy = 0.0;

% END OF FUNCTION: set_global_cons_cnt

%=====================================================================
% FUNCTION: print_sa_optimization_results_LONG_mod
%=====================================================================
function [done]=print_sa_optimization_results_LONG_mod(rdes, allTotSec, allSec)
%
% PURPOSE: Print out a detailed report on the optimized kinetic model
%
done = 0;   % MATLAB requires at least one return parameter

global file_name_LONG;
fid = fopen(file_name_LONG,'a');

% compute reaction rates after optimization
global n_rts rmax c;
r = zeros(n_rts,1);
r = ecoli_reuss_rates_mod(0,c);

fprintf(fid,'\n\n\n');
fprintf(fid,'=====================================================================\n');
fprintf(fid,'REPORT ON SA ITERATION OPTIMIZATION RESULTS\n');
fprintf(fid,'=====================================================================\n');

% print out optimization stop condition exitflag
global exitflag;
if exitflag <=0 
    fprintf(fid,'*** The optimization iterations did not converge to a solution\nexitflag = %2d', exitflag);
else
    fprintf(fid,'The optimization iterations have successfully converged to a solution\nexitflag = %2d', exitflag);
end    
fprintf(fid,'\n');

% printing out iteration # and temperature
global iter_SA T_SA;
fprintf(fid,'\n%s\n', '------------------------------------------------------------------------- ');
fprintf(fid,'%s\n',   '1. SA ITERATION, TEMPERATURE, AND ENZYME SUBSETS:');
fprintf(fid,'%s\n',   '------------------------------------------------------------------------- ');
fprintf(fid,'iteration:   %4d\n', iter_SA);
fprintf(fid,'temperature: %12.6e\n', T_SA);

global Et Eb Ec NUM_MOD_ENZ;
global rate_b rate_c rate_t;
global r0 OPT_FLUX_IND;

fprintf(fid,'BEST:   (ratio/rate): %12.6f   %12.6e', rate_b/r0(OPT_FLUX_IND), rate_b);
for i=1:NUM_MOD_ENZ
    fprintf(fid,' %4d', Eb(i));    
end    

fprintf(fid,'\nCURRENT (ratio/rate): %12.6f   %12.6e', rate_c/r0(OPT_FLUX_IND), rate_c);
for i=1:NUM_MOD_ENZ
    fprintf(fid,' %4d', Ec(i));    
end    

fprintf(fid,'\nTRAIL:  (ratio/rate): %12.6f   %12.6e', rate_t/r0(OPT_FLUX_IND), rate_t);
for i=1:NUM_MOD_ENZ
    fprintf(fid,' %4d', Et(i));    
end    
fprintf(fid,'\n');    

% 10 best enzyme subsets
global best10;
fprintf(fid,'\n%s\n', '------------------------------------------------------------------------- ');
fprintf(fid,'%s\n',   '2. TEN BEST ENZYME SUBSETS (LESS THEN TEN AT THE BEGINNING OF ITERATIONS):');
fprintf(fid,'%s\n',   '------------------------------------------------------------------------- ');

if iter_SA < 9
    nColPnt = iter_SA;
else
    nColPnt = 10;
end

test_zero = zeros(NUM_MOD_ENZ+1,1);
for j=1:nColPnt
    if test_zero == best10(:,j)
        continue;
    end
    
    fprintf(fid,'%2d   ratio/rate: %12.6f   %12.6f', j, best10(NUM_MOD_ENZ+1,j)/r0(OPT_FLUX_IND), best10(NUM_MOD_ENZ+1,j));    

    fprintf(fid,'   enzymes: ');    
    for i=1:NUM_MOD_ENZ
        fprintf(fid,' %4d', best10(i,j));        
    end
    
    fprintf(fid,'\n');
end    

global fcc OPT_FLUX_IND reg_enz_ind eec;
fprintf(fid,'\n%s\n', '------------------------------------------------------------------------- ');
fprintf(fid,'%s\n',   '3. FLUX CONTROL, ENZYME ELASTICITY, AND FLUX RESPONCE COEFFICIENTS:');
fprintf(fid,'%s\n',   '   (after optimization)');
fprintf(fid,'%s\n',   '------------------------------------------------------------------------- ');

fcc_sum = 0;
for i=1:n_rts
    fcc_sum = fcc_sum + fcc(i);
end    
fprintf(fid,'3.1. The flux control coefficients follow (FCCs)');
fprintf(fid,' (optimized flux: %3d)\n', OPT_FLUX_IND);
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

fprintf(fid,'3.2. Flux control, elasticities, and respose coefficients');
fprintf(fid,' (optimized flux: %3d)\n', OPT_FLUX_IND);
fprintf(fid,'     (for the feedback regulated enzymes only)\n');
fprintf(fid,'                                     rate #              FCC              EEC              FRC\n');
fprintf(fid, '1).  PTS        inhibition  by  g6p   (%2d): %16.8f %16.8f %16.8f   (31)\n', reg_enz_ind(1),  fcc(reg_enz_ind(1) ),  eec(1),  fcc(reg_enz_ind(1) )*eec(1));
fprintf(fid, '2).  PGI        inhibition  by  6pg   (%2d): %16.8f %16.8f %16.8f   (32)\n', reg_enz_ind(2),  fcc(reg_enz_ind(2) ),  eec(2),  fcc(reg_enz_ind(2) )*eec(2));
fprintf(fid, '3).  PFK        inhibition  by  pep   (%2d): %16.8f %16.8f %16.8f   (33)\n', reg_enz_ind(3),  fcc(reg_enz_ind(3) ),  eec(3),  fcc(reg_enz_ind(3) )*eec(3));
fprintf(fid, '4).  PFK        activation  by  adp   (%2d): %16.8f %16.8f %16.8f   (34)\n', reg_enz_ind(4),  fcc(reg_enz_ind(4) ),  eec(4),  fcc(reg_enz_ind(4) )*eec(4));
fprintf(fid, '5).  PFK        activation  by  amp   (%2d): %16.8f %16.8f %16.8f   (35)\n', reg_enz_ind(5),  fcc(reg_enz_ind(5) ),  eec(5),  fcc(reg_enz_ind(5) )*eec(5));
fprintf(fid, '6).  PK         activation  by  amp   (%2d): %16.8f %16.8f %16.8f   (36)\n', reg_enz_ind(6),  fcc(reg_enz_ind(6) ),  eec(6),  fcc(reg_enz_ind(6) )*eec(6));
fprintf(fid, '7).  PK         activation  by  fdp   (%2d): %16.8f %16.8f %16.8f   (37)\n', reg_enz_ind(7),  fcc(reg_enz_ind(7) ),  eec(7),  fcc(reg_enz_ind(7) )*eec(7));
fprintf(fid, '8).  PK         inhibition  by  atp   (%2d): %16.8f %16.8f %16.8f   (38)\n', reg_enz_ind(8),  fcc(reg_enz_ind(8) ),  eec(8),  fcc(reg_enz_ind(8) )*eec(8));
fprintf(fid, '9).  G1PAT      activation  by  fdp   (%2d): %16.8f %16.8f %16.8f   (39)\n', reg_enz_ind(9),  fcc(reg_enz_ind(9) ),  eec(9),  fcc(reg_enz_ind(9) )*eec(9));
fprintf(fid, '10). G6PDH      inhibition  by  nadph (%2d): %16.8f %16.8f %16.8f   (40)\n', reg_enz_ind(10), fcc(reg_enz_ind(10) ), eec(10), fcc(reg_enz_ind(10))*eec(10));
fprintf(fid, '11). PGDH       inhibition  by  atp   (%2d): %16.8f %16.8f %16.8f   (41)\n', reg_enz_ind(11), fcc(reg_enz_ind(11) ), eec(11), fcc(reg_enz_ind(11))*eec(11));
fprintf(fid, '12). PGDH       inhibition  by  nadph (%2d): %16.8f %16.8f %16.8f   (42)\n', reg_enz_ind(12), fcc(reg_enz_ind(12) ), eec(12), fcc(reg_enz_ind(12))*eec(12));
fprintf(fid, '13). PEPCxylase activatin   by  fdp   (%2d): %16.8f %16.8f %16.8f   (43)\n', reg_enz_ind(13), fcc(reg_enz_ind(13) ), eec(13), fcc(reg_enz_ind(13))*eec(13));

% printing out the model data
fprintf(fid,'\n%s\n', '------------------------------------------------------------------------- ');
fprintf(fid,'%s\n',   '4. RHS after optimization:');
fprintf(fid,'%s\n',   '------------------------------------------------------------------------- ');

rhs_err = rhs_max_val_mod(c);
global RHS_ERR_MIN; 
if rhs_err > RHS_ERR_MIN
    fprintf(fid,'\n%s\n', '################################################################ ');
    fprintf(fid,'rhs error exeeds the alowable maximal rhs error: %14.8e   %14.8e\n', rhs_err, RHS_ERR_MIN);
end

rhs_opt = ecoli_reuss_rhs_mod(0,c);
print_rhs_file_mod(fid, rhs_opt); 

fprintf(fid,'\n%s\n', '------------------------------------------------------------------------- ');
fprintf(fid,'%s\n',   '5. MAXIMAL REACTION RATES (ENZYME LEVELS) AND REGULATION');
fprintf(fid,'%s\n',   '   (after optimization)');
fprintf(fid,'%s\n',   '------------------------------------------------------------------------- ');
fprintf(fid,'%s\n',   '5.1. Maximal reaction rates (#  rmax_name  rmax0  rmax_opt  rmax_opt/rmax0)');
global rmax0 r_des_ind;
enz = 0;
for i=1:n_rts
    enz = enz + rmax(i)/rmax0(i);
end
fprintf(fid,'%s %12.6f\n', 'total normilized enzyme level after optimizaiton: ', enz);
print_max_rate_ratios_file_mod(fid, rmax0, rmax, r_des_ind);

fprintf(fid,'%s\n',   '5.2. Feedback regulations');
global reg;

ind=31; fprintf(fid, '1).  PTS        inhibition  by  g6p:   %16.8f (31)', reg(1)); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind=32; fprintf(fid, '2).  PGI        inhibition  by  6pg:   %16.8f (32)', reg(2)); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind=33; fprintf(fid, '3).  PFK        inhibition  by  pep:   %16.8f (33)', reg(3)); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind=34; fprintf(fid, '4).  PFK        activation  by  adp:   %16.8f (34)', reg(4)); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind=35; fprintf(fid, '5).  PFK        activation  by  amp:   %16.8f (35)', reg(5)); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind=36; fprintf(fid, '6).  PK         activation  by  amp:   %16.8f (36)', reg(6)); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind=37; fprintf(fid, '7).  PK         activation  by  fdp:   %16.8f (37)', reg(7)); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind=38; fprintf(fid, '8).  PK         inhibition  by  atp:   %16.8f (38)', reg(8)); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind=39; fprintf(fid, '9).  G1PAT      activation  by  fdp:   %16.8f (39)', reg(9)); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind=40; fprintf(fid, '10). G6PDH      inhibition  by  nadph: %16.8f (40)', reg(10)); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind=41; fprintf(fid, '11). PGDH       inhibition  by  atp:   %16.8f (41)', reg(11)); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind=42; fprintf(fid, '12). PGDH       inhibition  by  nadph: %16.8f (42)', reg(12)); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end
ind=43; fprintf(fid, '13). PEPCxylase activatin   by  fdp:   %16.8f (43)', reg(13)); if 1 == size( find(r_des_ind==ind) ) fprintf(fid,' (design)\n'); else fprintf(fid,'\n'); end

fprintf(fid,'\n%s\n', '------------------------------------------------------------------------- ');
fprintf(fid,'%s\n', '6. REACTION RATES OR FLUXES (#  rate_name  rate0  rate_opt  rate_opt/rate0  ) :');
fprintf(fid,'%s\n',    '------------------------------------------------------------------------- ');
print_normalized_rate_ratios_file_mod(fid, r0, r);

fprintf(fid,'\n%s\n', '------------------------------------------------------------------------- ');
fprintf(fid,'%s\n', '7. CONCENTRATIONS (#  met_name  c0  c_opt  c_opt/c0):');
fprintf(fid,'%s\n',    '------------------------------------------------------------------------- ');

global n_cons c0;
cvar_opt = 0;
for i=1:n_cons
     cvar_opt = cvar_opt + abs(c(i) - c0(i))/c0(i);
end    
cvar_opt = cvar_opt/n_cons;
fprintf(fid,'total variation in the concentration level %12.6f\n', cvar_opt);
print_concentration_ratios_file_mod(fid, c0, c);

fprintf(fid,'\n%s\n', '------------------------------------------------------------------------- ');
fprintf(fid,'%s\n', '8. STABILITY ANALYSIS (of the optimized steady state): ');
fprintf(fid,'%s\n',    '------------------------------------------------------------------------- ');
print_stability_analysis_file_mod(fid, c);

print_cpu_time_file_mod(fid, allSec);

fclose(fid);

%--------------------------------------------------------------------------
% print out each SA iteration into the ITER_SHORT_ITER and SHORT_OPTP  files
%--------------------------------------------------------------------------
print_sa_optimization_results_ITER_SHORT_mod(allTotSec, allSec, r0, r);
print_sa_optimization_results_OPTP_SHORT_mod(allTotSec, allSec, 1);
print_sa_optimization_results_FCC_SHORT_mod(iter_SA, r(OPT_FLUX_IND)/r0(OPT_FLUX_IND));

done = 1;   % MATLAB requires at least one return parameter
% END OF FUNCTION: print_sa_optimization_results_LONG_mod

%=====================================================================
% FUNCTION: print_sa_optimization_results_ITER_SHORT_mod
%=====================================================================
function [done] = print_sa_optimization_results_ITER_SHORT_mod(allTotSec, allLocSec, r0, r)
%
% PURPOSE: Print out each SA iteration into the file
%
done = 0;

global file_name_ITER_SHORT;
global iter_SA T_SA;
global OPT_FLUX_IND;
global Et NUM_MOD_ENZ;
global rate_b rate_c rate_t;

fid = fopen(file_name_ITER_SHORT,'a');
% total CPU time spent
allTotMin = floor(allTotSec/60);
totSec = floor(allTotSec - allTotMin*60);
totHr  = floor(allTotMin/60);
totMin = floor(allTotMin - totHr*60);
fprintf(fid, '%3i:%2i:%2i', totHr, totMin, totSec);

% CPU time for optimization
allLocMin = floor(allLocSec/60);
locSec = floor(allLocSec - allLocMin*60);
locHr  = floor(allLocMin/60);
locMin = floor(allLocMin - locHr*60);
fprintf(fid, '     %3i:%2i:%2i', locHr, locMin, locSec);

fprintf(fid,'      %4d', iter_SA);
fprintf(fid,'      %12.6e', T_SA);
fprintf(fid,'   %12.6f ', rate_b/r0(OPT_FLUX_IND));
fprintf(fid,'   %12.6f ', rate_c/r0(OPT_FLUX_IND));
fprintf(fid,'   %12.6f ', rate_t/r0(OPT_FLUX_IND));

for i=1:NUM_MOD_ENZ
    fprintf(fid,' %4d', Et(i));    
end

global exitflag;
if exitflag <=0 
    fprintf(fid,' *** exitflag = %2d', exitflag);
end

global sel_OUT E0 ind_bk_0 rate_c_0;
if sel_OUT == 1
    fprintf(fid,' *** a new move emanated at: %5d with rate_c = %12.6e from set: ',ind_bk_0, rate_c_0);
    for i=1:NUM_MOD_ENZ
        fprintf(fid,' %2d', E0(i));    
    end    
end    

fprintf(fid,'\n');

fclose(fid);
done = 1;
% END OF FUNCTION: print_sa_optimization_results_ITER_SHORT_mod

%=====================================================================
% FUNCTION: print_sa_optimization_results_OPTP_SHORT_mod
%=====================================================================
function [done]=print_sa_optimization_results_OPTP_SHORT_mod(allTotSec, allLocSec, flg_end)
%
% PURPOSE: Print out each SA iteration into the file
%
done = 0;

global file_name_OPTP_SHORT;
global iter_SA;
global Et NUM_MOD_ENZ;
global exitflag output_opt;

fid = fopen(file_name_OPTP_SHORT,'a');

if flg_end == 0
    fprintf(fid,'iter = %4d, enzymes and feedbacks:', iter_SA);

    for i=1:NUM_MOD_ENZ
        fprintf(fid,' %4d', Et(i));    
    end
    fprintf(fid,'\n');    
    
    % total CPU time spent
    fprintf(fid,'CPU (tot.)    =  ');        
    allTotMin = floor(allTotSec/60);
    totSec = floor(allTotSec - allTotMin*60);
    totHr  = floor(allTotMin/60);
    totMin = floor(allTotMin - totHr*60);    
    fprintf(fid,'%3i:%2i:%2i\n', totHr, totMin, totSec);    
end    

if flg_end == 1        
    % CPU time for optimization
    fprintf(fid,'CPU (loc.)    =  ');        
    allLocMin = floor(allLocSec/60);
    locSec = floor(allLocSec - allLocMin*60);
    locHr  = floor(allLocMin/60);
    locMin = floor(allLocMin - locHr*60);
    fprintf(fid, '%3i:%2i:%2i\n', locHr, locMin, locSec);
    
    fprintf(fid,'exitflag      = %4d\n', exitflag);
    fprintf(fid,'iterations    = %4d\n', output_opt.iterations);
    fprintf(fid,'funcCount     = %4d\n', output_opt.funcCount);
    fprintf(fid,'algorithm     = %s\n', output_opt.algorithm);
    fprintf(fid,'stepsize      = %12.6f\n', output_opt.stepsize);
    fprintf(fid,'firstorderopt = %12.6e\n', output_opt.firstorderopt);
    fprintf(fid,'\n');        
end

fclose(fid);

done = 1;
% END OF FUNCTION: print_sa_optimization_results_OPTP_SHORT_mod

%=====================================================================
% FUNCTION: print_sa_optimization_results_TEMP_SHORT_mod
%=====================================================================
function [done] = print_sa_optimization_results_TEMP_SHORT_mod(allTotSec)            
%
% PURPOSE: Print out statistics for each SA relaxation iteration
%
done = 0;

global file_name_TEMP_SHORT;
fid = fopen(file_name_TEMP_SHORT,'a');

global iter_SA T_SA hi rate_aver sigma sigma_norm;
global rate_b rate_c rate_t;
global r0;
global OPT_FLUX_IND;

% total CPU time spent
allTotMin = floor(allTotSec/60);
totSec = floor(allTotSec - allTotMin*60);
totHr  = floor(allTotMin/60);
totMin = floor(allTotMin - totHr*60);
fprintf(fid, '%3i:%2i:%2i', totHr, totMin, totSec);

fprintf(fid,'      %4d', iter_SA);
fprintf(fid,'      %12.6e', T_SA);
fprintf(fid,'      %12.6f', hi);
fprintf(fid,'       %12.6f', rate_aver);
fprintf(fid,'   %12.6f', sigma);
fprintf(fid,'   %12.6f', sigma_norm);

fprintf(fid,'   %12.6f ', rate_b/r0(OPT_FLUX_IND));
fprintf(fid,'   %12.6f ', rate_c/r0(OPT_FLUX_IND));
fprintf(fid,'   %12.6f\n', rate_t/r0(OPT_FLUX_IND));


fclose(fid);
done = 1;
% END OF FUNCTION: print_sa_optimization_results_TEMP_SHORT_mod

%=====================================================================
% FUNCTION: print_sa_optimization_results_FCC_SHORT_mod
%=====================================================================
function [done] = print_sa_optimization_results_FCC_SHORT_mod(iter_SA, ratio_SA)
%
% PURPOSE: Print out flux control coefficients
%
done = 0;

global n_rts file_name_FCC_SHORT fcc eec frc;
fid = fopen(file_name_FCC_SHORT,'a');

fprintf(fid,'%4d', iter_SA);
fprintf(fid,'  %12.6f', ratio_SA);

sum = 0;
for i=1:n_rts
    sum = sum + fcc(i);
    fprintf(fid,' %16.8f', fcc(i));    
end
fprintf(fid,' %16.8f', sum);

fprintf(fid,' %16.8f %16.8f', eec(1),  frc(1));
fprintf(fid,' %16.8f %16.8f', eec(2),  frc(2));
fprintf(fid,' %16.8f %16.8f', eec(3),  frc(3));
fprintf(fid,' %16.8f %16.8f', eec(4),  frc(4));
fprintf(fid,' %16.8f %16.8f', eec(5),  frc(5));
fprintf(fid,' %16.8f %16.8f', eec(6),  frc(6));
fprintf(fid,' %16.8f %16.8f', eec(7),  frc(7));
fprintf(fid,' %16.8f %16.8f', eec(8),  frc(8));
fprintf(fid,' %16.8f %16.8f', eec(9),  frc(9));
fprintf(fid,' %16.8f %16.8f', eec(10), frc(10));
fprintf(fid,' %16.8f %16.8f', eec(11), frc(11));
fprintf(fid,' %16.8f %16.8f', eec(12), frc(12));
fprintf(fid,' %16.8f %16.8f', eec(13), frc(13));



fprintf(fid,'\n');

fclose(fid);
done = 1;
% END OF FUNCTION: print_sa_optimization_results_FCC_SHORT_mod

function [sel_OUT] = select
%
% PURPOSE: selection of a new trial enzyme and feedback subset
%
% MODIFIED: 2005-12-13
%

global FCC_FLAG Et_used NUM_MOD_ENZ n_rts iter_SA n_reg n_rts_opt n_reg_opt
global Et Ec E0 ind_bk_0

sel_OUT = 0;
ind_bk  = 1;
n_set = n_rts + n_reg;
while (ind_bk < iter_SA)
    %pick enzyme that leaves the subset at random
    tmp_out = randperm(NUM_MOD_ENZ);
    
    %pick enzyme that enters the subset at random
    tmp_in = randperm(n_set);
        
    for m=1:NUM_MOD_ENZ
        enz_out_ind = tmp_out(m);   % the virtual(!) subset index of a leaving enzyme or feedback
        
        for k=1:n_set
            enz_in = tmp_in(k);     % the actual(!) index of an entering enzyme or feedback
            ok_in = 1;
        
            % check if enz_in is already present in subset Ec
            for i=1:NUM_MOD_ENZ
                if Ec(i) == enz_in
                    ok_in = 0;
                    break;
                end
            end
        
            if ok_in == 0
                continue;   % try another one
            end
        
            %swap enz_in and enz_out in subset Et
            Et = Ec;
            Et(enz_out_ind) = enz_in;
            Et = sort(Et);
        
            % check if subset Et has been already used
            for j=1:iter_SA-1
                if Et_used(:,j) == Et
                    ok_in = 0;
                    break;
                end                
            end            
        
            % check if a brand new subset is generated
            if ok_in == 1
                
                % check if the the subset includes at least one feedback
                if Et(NUM_MOD_ENZ) <= n_rts
                    continue;                    
                end    
                    
                Et_used(:,iter_SA) = Et;
                
                % compute how may enzyme levels and feedbacks are present in the subset
                n_rts_opt = 0;
                n_reg_opt = 0;
                for i=1:NUM_MOD_ENZ
                    if Et(i) <= n_rts
                        n_rts_opt = n_rts_opt + 1;
                    end
                end    
                n_reg_opt = NUM_MOD_ENZ - n_rts_opt;
                                
                return;
            end            
        end
    end        

    % try to get off a trapped cycle
    %fprintf('%5d\n',ind_bk);    
    sel_OUT = 1;        
    Ec = Et_used(:,iter_SA - ind_bk);
    E0 = Ec;
    ind_bk_0 = ind_bk;
    ind_bk = ind_bk + 1;            
end

sel_OUT = 2;    
% END OF FUNCTION: select

%=====================================================================
% FUNCTION: write_CP_file
%=====================================================================
function [out] = write_CP_file(iter_SA, Et, Ec, Eb, rate_t, rate_c, rate_b, T_SA, NUM_MOD_ENZ)
%
% PURPOSE: selection of a new trial enzyme subset
%
out = 0;

fid_CP = fopen('CP.res','a');

fprintf(fid_CP,'%6d   ',iter_SA);
for i=1:NUM_MOD_ENZ
    fprintf(fid_CP,'% 2d', Et(i));    
end
fprintf(fid_CP,'  ');

for i=1:NUM_MOD_ENZ
    fprintf(fid_CP,'% 2d', Ec(i));    
end
fprintf(fid_CP,'  ');

for i=1:NUM_MOD_ENZ
    fprintf(fid_CP,'% 2d', Eb(i));    
end
fprintf(fid_CP,'  ');

fprintf(fid_CP,'% 12.6e   %12.6e   %12.6e   %12.6e\n', rate_t, rate_c, rate_b, T_SA);

fclose(fid_CP);

out = 1;
% END OF FUNCTION: write_CP_file

%=====================================================================
% FUNCTION: read_CP_file  Original
%=====================================================================
function [out] = read_CP_file
%
% PURPOSE: selection of a new trial enzyme subset
%
out = 0;

global iter_SA iter_SA_CP Et_used Rt_used Et Ec Eb rate_t rate_c rate_b T_SA NUM_MOD_ENZ

fid_CP = fopen('CP.res','r');

for i=1:iter_SA_CP
        iter_SA = fscanf(fid_CP,'%6d',1);
        
        Et = fscanf(fid_CP,' %d',NUM_MOD_ENZ);
        Ec = fscanf(fid_CP,' %d',NUM_MOD_ENZ);
        Eb = fscanf(fid_CP,' %d',NUM_MOD_ENZ);
                
        tmp_data = fscanf(fid_CP,'%e %e %e %e', 4);
        rate_t = tmp_data(1);
        rate_c = tmp_data(2);
        rate_b = tmp_data(3);
        T_SA   = tmp_data(4);
        
        Et_used(:,i) = Et;
        Rt_used(i) = rate_t;           
end        

% compute how may enzyme levels and feedbacks are present in Et
global n_rts_opt n_reg_opt n_rts;

n_rts_opt = 0;
n_reg_opt = 0;

for i=1:NUM_MOD_ENZ
    if Et(i) <= n_rts
        n_rts_opt = n_rts_opt + 1;
    end
end    
n_reg_opt = NUM_MOD_ENZ - n_rts_opt;

fclose(fid_CP);

% END OF FUNCTION: read_CP_file

%=====================================================================
% FUNCTION: update_10_best
%=====================================================================
function [done] = update_10_best
%
% PURPOSE: update 10 best enzyme subsets
%    
done = 0;

global rate_t Et best10 iter_SA NUM_MOD_ENZ
 
for j=1:10
    rate_tmp = best10(NUM_MOD_ENZ+1,j);
    
    if rate_t > rate_tmp
        if j < 10
            for k=j:9
                best10(:,10+j-k) = best10(:,10+j-k-1);
            end                   
        end            
        best10(1:NUM_MOD_ENZ,j) = Et;
        best10(NUM_MOD_ENZ+1,j) = rate_t;
        break;
    end            
end

done = 1;        
% END OF FUNCTION: update_10_best


%=====================================================================
% FUNCTION: print_CP_LONG_mod
%=====================================================================
function [done] = print_CP_LONG_mod
%
% PURPOSE: print control point to LONG file
%    
done = 0;

global iter_SA iter_SA_CP Et_used Rt_used Et Ec Eb rate_t rate_c rate_b T_SA NUM_MOD_ENZ

global file_name_LONG;
fid = fopen(file_name_LONG,'a');

fprintf(fid,'\n\n');
fprintf(fid,'=====================================================================\n');
fprintf(fid,'CONTROL POINT DATA:\n');
fprintf(fid,'=====================================================================\n');

fprintf(fid,'1. iter_SA    = %6d\n',iter_SA);
fprintf(fid,'2. iter_SA_CP = %6d\n',iter_SA_CP);
fprintf(fid,'3. T_SA = %12.6e\n',T_SA);

fprintf(fid,'4. rate_b = %12.6e, Eb = ',rate_b);
for i=1:NUM_MOD_ENZ
    fprintf(fid,' %2d',Eb(i));
end    
fprintf(fid,'\n');

fprintf(fid,'5. rate_c = %12.6e, Ec = ',rate_c);
for i=1:NUM_MOD_ENZ
    fprintf(fid,' %2d',Ec(i));
end
fprintf(fid,'\n');

fprintf(fid,'6. rate_t = %12.6e, Et = ',rate_t);
for i=1:NUM_MOD_ENZ
    fprintf(fid,' %2d',Et(i));
end    
fprintf(fid,'\n');

fclose(fid);

done = 1;
% END OF FUNCTION: print_CP_LONG_mod

%=====================================================================
% FUNCTION: print_CP_LONG_mod
%=====================================================================
function [done] = print_MOVE_CHANGE_LONG_mod
%
% PURPOSE: print change in move to LONG file
%    
done = 0;

global iter_SA Et Ec Eb rate_t rate_c rate_b T_SA NUM_MOD_ENZ ind_bk_0

global file_name_LONG;
fid = fopen(file_name_LONG,'a');

fprintf(fid,'\n\n');
fprintf(fid,'=====================================================================\n');
fprintf(fid,'CHANGE OF REGULAR MOVE DUE TO AN ARTIFICIAL TRAPPING CYCLE:\n');
fprintf(fid,'(next new move will be generated from the updated Ec)\n');
fprintf(fid,'=====================================================================\n');

fprintf(fid,'1. iter_SA    = %6d\n',iter_SA);
fprintf(fid,'2. ind_bk_0    = %6d\n',ind_bk_0);
fprintf(fid,'3. T_SA = %12.6e\n',T_SA);

fprintf(fid,'4. rate_b = %12.6e, Eb = ',rate_b);
for i=1:NUM_MOD_ENZ
    fprintf(fid,' %2d',Eb(i));
end    
fprintf(fid,'\n');

fprintf(fid,'5. rate_c = %12.6e, Ec = ',rate_c);
for i=1:NUM_MOD_ENZ
    fprintf(fid,' %2d',Ec(i));
end
fprintf(fid,'\n');

fprintf(fid,'5. rate_t = %12.6e, Et = ',rate_t);
for i=1:NUM_MOD_ENZ
    fprintf(fid,' %2d',Et(i));
end    
fprintf(fid,'\n');

fclose(fid);

done = 1;