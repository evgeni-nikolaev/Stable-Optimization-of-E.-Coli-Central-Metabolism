%=====================================================================
% FUNCTION: locate_steady_state_cons_mod
%=====================================================================
function [c_ss]=locate_steady_state_cons_mod(c)
%
% PURPOSE: Locate steady state concentrations close to concentrations c
%

% disp('*** START *** locate_steady_state_cons_mod(c)')

global OUT_FLG;
global tEnd_ode nInt n_cons;
global absErr_ode relErr_ode;
global RHS_ERR_MIN RHS_ERR_MAX RHS_ERR_UNSTABLE;

options = odeset('RelTol',relErr_ode,'AbsTol',absErr_ode);

% new steady state concentrations
c_ss = zeros(n_cons,1);
c_ss = c;

% work arrays
t_sol = zeros(11,1);
c_sol = zeros(11,n_cons);

% STEP 1: integrate the model until the rhs is small enough
nLoop = 1;
err = 0;
t_range = [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0].*tEnd_ode;
while (nLoop <= nInt)
%     disp('*** START *** ode15s')        
    [t_sol, c_sol] = ode15s(@ecoli_reuss_rhs_mod, t_range, c_ss, options);
    
    tStop = t_sol(end);
    c_ss  = c_sol(end,:)';
    err   = rhs_max_val_mod(c_ss);
    
    if (tStop < tEnd_ode) && OUT_FLG
        disp (['*** ERROR INTEGRATION TIME STOP = '  num2str(tStop) ', err_rhs = ' num2str(err)]);
        break;
    end 
    
    if err < RHS_ERR_MAX
        break;
    end    
    
    if err > RHS_ERR_UNSTABLE
        break;
    end    
            
    nLoop = nLoop + 1;
end    

% STEP 2: solve nonlinear equations
global CODE_neq;

if 0 == CODE_neq
    return
end    

global tolFun_neq tolX_neq ALG_neq maxFunEval_neq maxIter_neq;
options_eq = optimset('TolFun',tolFun_neq,'TolX',tolX_neq,...
                   'MaxFunEvals',maxFunEval_neq,'MaxIter',maxIter_neq,...
                   'NonlEqnAlgorithm',ALG_neq,'Display','off');

c_eq = zeros(n_cons,1);
[c_eq,fz,exitflag_eq,output_eq] = fsolve(@ecoli_reuss_rhs_fun_mod, c_ss, options_eq);

if (exitflag_eq <= 0) && OUT_FLG
    max_abs_val = max( abs(fz) );
    disp (['*** ERROR fsolve STOP, exitflag_eq = '  num2str(exitflag_eq)]);
    disp (['*** max_abs_rhs_val = ' num2str(max_abs_val) ]);
    output_eq
end        
 
c_ss = c_eq;

% STEP 3: fix negative concentrations
global NUM_MIN;
for i=1:n_cons
    if c_ss(i) < NUM_MIN
        c_ss(i) = NUM_MIN;
    end            
end            
% END OF FUNCTION: locate_steady_state_cons_mod
