%=====================================================================
% FUNCTION: rhs_max_val_mod
%=====================================================================
function [max_abs_val]=rhs_max_val_mod(c)
%
% PURPOSE: Computes the maximal absolute value of the rhs vector
% 
global n_cons;
rhs = zeros(n_cons,1);
rhs = ecoli_reuss_rhs_mod(0,c);
max_abs_val = max( abs(rhs) );

% END OF FUNCTION: rhs_max_val