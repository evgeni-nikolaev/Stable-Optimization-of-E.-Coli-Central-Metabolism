%=====================================================================
% FUNCTION: ecoli_reuss_rhs_fun_mod
%=====================================================================
function [fun] = ecoli_reuss_rhs_fun_mod(c)
%
%   PURPOSE: Assigns the autonomous ode right hand sides for 
%            the Reuss' dynamical model of Escherichia coli
%
%   REFERENCE:  Christophe Chassagnole, Naruemol Noisommit-Rizzi, Joachim W. Schmid,
%               Klaus Mauch, and Matthias Reuss. 
%               "Dynamic Modeling of the Central Carbon Metabolism of Escherichia coli"
%               BIOTECHNOLOGY AND BIOENGINEERING, VOL.79, NO.1, JULY 5, 2002
%
%   Last Modified: 2004-12-14
%

global n_cons;

t0 = 0;
fun = zeros(n_cons,1);

fun = ecoli_reuss_rhs_mod(t0,c);

% END OF FUNCTION: ecoli_reuss_rhs_fun_mod