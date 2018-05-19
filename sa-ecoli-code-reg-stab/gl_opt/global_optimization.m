%=====================================================================
% FUNCTION: global_optimization
%=====================================================================
function [done] = global_optimization
%
% PURPOSE: does global optimization of all network
%
% MODIFIED: 2005-12-24
%
done = 0;   % MATLAB requires at least one return parameter
rand('state',sum(100*clock));   % resent random seeds to start with new first trail set

global tBegSA OUT_FLG;
global file_name_LONG;

do_optimization;

print_go_optimization_results_LONG_mod;

% END OF FUNCTION: global_optimization

%=====================================================================
% FUNCTION: do_optimization
%=====================================================================
function [rdes_opt, r_opt] = do_optimization
%
% PURPOSE: optimize the reaction set for the given set of modulated enzymes
%
% MODIFIED: 2005-12-24

global ENZ_GL REG_GL ENZ_REG_GL r_des_ind;
global OUT_FLG;

global n_rts n_reg;

%--------------------------------------------------------------------------
% set starting unit values for (1) normilized design variable and (2) factor q
%--------------------------------------------------------------------------
r_des_ind = zeros(n_rts+n_reg,1);

if 1 == ENZ_GL                          % only enzyme levels will be optimized
    rdes_start = ones(n_rts,1);

    for i=1:n_rts
        r_des_ind(i) = i;
    end    

end    

if 1 == REG_GL                          % only regulations will be optimized
    rdes_start = ones(n_reg,1);     

    for i=n_rts+1:n_rts+n_reg
        r_des_ind(i) = i;
    end            
    
end                                 

if 1 == ENZ_REG_GL                      % both enzyme levels and regulations will be optimized
    rdes_start = ones(n_rts + n_reg,1);     
    
    for i=1:n_rts + n_reg
        r_des_ind(i) = i;
    end        
    
end                                 

%--------------------------------------------------------------------------
% set lower and upper bounds for normalized design variables
%--------------------------------------------------------------------------
[lb,ub] = set_bounds;

%--------------------------------------------------------------------------
% set row-vector A_eq and number b_eq to keep enzyme level constant
% if these enzyme levels will be optimized
%--------------------------------------------------------------------------
if (1 == ENZ_GL) || (1 == ENZ_REG_GL)
    [A_eq,b_eq] = set_Ab_eq;
end

%--------------------------------------------------------------------------
% OPTIMIZATION
%--------------------------------------------------------------------------
global tolCon_opt tolFun_opt tolX_opt maxFunEvals maxIter display_flg;
options = optimset('LargeScale','off','TolCon',tolCon_opt,'TolFun',tolFun_opt,...
          'TolX',tolX_opt,'MaxFunEvals',maxFunEvals,'MaxIter',maxIter,'Display',display_flg);
      
global rdes_opt exitflag output_opt;

% enzyme levels are optimized
if (1 == ENZ_GL) || (1 == ENZ_REG_GL)    
    [rdes_opt, r_opt, exitflag, output_opt, grad] = fmincon(@get_negative_obj_rate, rdes_start, [], [], A_eq, b_eq, lb, ub, @set_global_cons_cnt, options);
end

% enzyme levels are not optimized
if 1 == REG_GL    
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
function [lb,ub] = set_bounds
%
% PURPOSE: Sets lower and upper bounds for normalized design variables 
%
global ENZ_GL REG_GL ENZ_REG_GL;
global NUM_MIN NUM_MAX n_rts n_reg;

if 1 == ENZ_GL            % enzyme levels will be optimized only
    lb = zeros(n_rts,1);
    ub = zeros(n_rts,1);
    
    % bounds for enzyme levels
    lb(1:n_rts) = NUM_MIN;
    ub(1:n_rts) = NUM_MAX;
end    

if 1 == REG_GL              % regulation will be optimized only
    lb = zeros(n_reg,1);
    ub = zeros(n_reg,1);
    
    % bounds for feedbacks    
    lb(1:n_reg) = NUM_MIN;
    ub(1:n_reg) = NUM_MAX;    
end    

if 1 == ENZ_REG_GL          % enzyme levels and regulaiton will be optimized
    lb = zeros(n_rts+n_reg,1);
    ub = zeros(n_rts+n_reg,1);
  
    % bounds for all modulations
    lb(1:n_rts+n_reg) = NUM_MIN;
    ub(1:n_rts+n_reg) = NUM_MAX;
end    

% END OF FUNCTION: Set_Bounds

%=====================================================================
% FUNCTION: set_Ab_eq
%=====================================================================
function [A_eq,b_eq] = set_Ab_eq
%
% PURPOSE: Sets row-vector A_eq and number b_eq to keep enzyme level constant 
%
% MODIFIED: 2005-12-24
%
global n_rts n_reg;
global ENZ_GL REG_GL ENZ_REG_GL;

if 1 == ENZ_GL 
    A_eq = ones(1,n_rts);
end

if 1 == ENZ_REG_GL
    A_eq = zeros(1,n_rts+n_reg);    
    A_eq(1:n_rts) = 1;
end

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
% MODIFIED: 2005-12-24
%
done = 0;   % MATLAB requires at least one return parameter

global rmax rmax0 n_rts reg n_reg;
global ENZ_GL REG_GL ENZ_REG_GL;

% update values of adjusted variables within rmax only
if 1 == ENZ_GL
    for i=1:n_rts
        rmax(i) = rdes(i)*rmax0(i);
    end    
end    

% correct updated values of design variables within reg array only   
if 1 == REG_GL
    reg  = rdes;    
end    

% correct updated values of design variables within rmax and reg arrays
if 1 == ENZ_REG_GL 
    for i=1:n_rts
        rmax(i) = rdes(i)*rmax0(i);
    end    

    for i=1:n_reg
        reg(i)  = rdes(i+n_rts);    
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
function [cnt_ineq, dummy]=set_global_cons_cnt(rdes)
%
% PURPOSE: Set global concentration constraint
%
global C_VAR n_cons c0 c;
update_global_variables(rdes); % rmax and c

% global variation in concentration levels
dc = sum( abs( (c-c0)./c0 ) )/n_cons;    
cnt_ineq = dc - C_VAR;
dummy = 0.0;

% END OF FUNCTION: set_global_cons_cnt

%=====================================================================
% FUNCTION: print_sa_optimization_results_LONG_mod
%=====================================================================
function [done]=print_go_optimization_results_LONG_mod
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
fprintf(fid,'------------------------------------------------------------------------- \n');
fprintf(fid,'1. REPORT ON ITERATION OPTIMIZATION RESULTS\n');
fprintf(fid,'------------------------------------------------------------------------- \n');

% print out optimization stop condition exitflag
global exitflag output_opt;
if exitflag <=0 
    fprintf(fid,'*** The optimization iterations did not converge to a solution\n');
else
    fprintf(fid,'The optimization iterations have successfully converged to a solution\n');
end    
fprintf(fid,'exitflag      = %5d\n', exitflag);
fprintf(fid,'iterations    = %5d\n', output_opt.iterations);
fprintf(fid,'funcCount     = %5d\n', output_opt.funcCount);
fprintf(fid,'algorithm     = %s\n', output_opt.algorithm);
fprintf(fid,'stepsize      = %18.6f\n', output_opt.stepsize);
fprintf(fid,'firstorderopt = %18.6e\n', output_opt.firstorderopt);
fprintf(fid,'\n');        

% printing out the model data
fprintf(fid,'\n%s\n', '------------------------------------------------------------------------- ');
fprintf(fid,'%s\n',   '2. RHS after optimization:');
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
fprintf(fid,'%s\n',   '3. MAXIMAL REACTION RATES (ENZYME LEVELS) AND REGULATION');
fprintf(fid,'%s\n',   '   (after optimization)');
fprintf(fid,'%s\n',   '------------------------------------------------------------------------- ');
fprintf(fid,'%s\n',   '3.1. Maximal reaction rates (#  rmax_name  rmax0  rmax_opt  rmax_opt/rmax0)');
global rmax0 r_des_ind;
enz = 0;
for i=1:n_rts
    enz = enz + rmax(i)/rmax0(i);
end
fprintf(fid,'%s %12.6f\n', 'total normilized enzyme level after optimizaiton: ', enz);
print_max_rate_ratios_file_mod(fid, rmax0, rmax, r_des_ind);

fprintf(fid,'%s\n',   '3.2. Feedback regulations');
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
fprintf(fid,'%s\n', '4. REACTION RATES OR FLUXES (#  rate_name  rate0  rate_opt  rate_opt/rate0  ) :');
fprintf(fid,'%s\n',    '------------------------------------------------------------------------- ');
global r0;
print_normalized_rate_ratios_file_mod(fid, r0, r);

fprintf(fid,'\n%s\n', '------------------------------------------------------------------------- ');
fprintf(fid,'%s\n', '5. CONCENTRATIONS (#  met_name  c0  c_opt  c_opt/c0):');
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
fprintf(fid,'%s\n', '6. STABILITY ANALYSIS (of the optimized steady state): ');
fprintf(fid,'%s\n',    '------------------------------------------------------------------------- ');
print_stability_analysis_file_mod(fid, c);

fclose(fid);

done = 1;   % MATLAB requires at least one return parameter
% END OF FUNCTION: print_sa_optimization_results_LONG_mod