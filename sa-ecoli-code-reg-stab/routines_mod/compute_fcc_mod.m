%=====================================================================
% FUNCTION: compute_fcc_mod
%=====================================================================
function [done] = compute_fcc_mod
%
% PURPOSE: computes flux control coefficients (fcc)
%
done = 0;   % MATLAB requires at least one return parameter
global n_rts n_reg h_fcc OPT_FLUX_IND n_cons c;
global rmax reg reg_enz_ind fcc frc eec reg_enz_ind; 

% compute a reference reaction rate of interest (OPT_FLUX_IND)
rate_h = zeros(1,n_rts);
rate_0 = ecoli_reuss_rates_mod(0,c);  % at current concentrations c
LOG_J0 = log(rate_0(OPT_FLUX_IND));

% compute fcc gradient (flux control coefficients)
cc = zeros(1,n_cons);               % perturbed concentrations
for i=1:n_rts
    rmax_0 = rmax(i);
    h_rel = h_fcc*rmax_0;
    rmax(i) = rmax_0 + h_rel;

    cc = locate_steady_state_cons_mod(c);
    rate = ecoli_reuss_rates_mod(0,cc);
    
    Jh = rate(OPT_FLUX_IND);    
    fcc(i) = (log(Jh) - LOG_J0)/(log(rmax(i)) - log(rmax_0));
    
    rmax(i) = rmax_0;
end

% compute frc & eec gradients (flux response and enzyme elasticity coefficients)
for i=1:n_reg
    reg_0 = reg(i);
    reg(i) = reg_0 + h_fcc*reg_0;
    
    d_LOG_reg = log(reg(i)) - log(reg_0);

    % eec
    ind = reg_enz_ind(i);     
    rate_h = ecoli_reuss_rates_mod(0,c);    
    eec(i) = (log( rate_h(ind) ) - log( rate_0(ind) ))/d_LOG_reg;
        
    % frc
    frc(i) = fcc(reg_enz_ind(i) )*eec(i);    
    
    reg(i) = reg_0;
end

done = 1;
% END OF FUNCTION: compute_fcc_mod