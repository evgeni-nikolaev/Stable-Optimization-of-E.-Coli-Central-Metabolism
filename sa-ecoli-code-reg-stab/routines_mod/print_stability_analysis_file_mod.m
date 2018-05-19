%=====================================================================
% FUNCTION: print_stability_analysis_file_mod
%=====================================================================
function [done]=print_stability_analysis_file_mod(fid, c)
%
% PURPOSE: Print out eigenvalues to file
%
done = 0;   % MATLAB requires at least one return parameter

global tolFun_neq tolX_neq ALG_neq maxFunEval_neq maxIter_neq;
options_eq = optimset('Display','off','TolFun',tolFun_neq,'TolX',tolX_neq,...
                   'MaxFunEvals',maxFunEval_neq,'MaxIter',maxIter_neq,'NonlEqnAlgorithm',ALG_neq);

global n_cons;               
[c_ss,fz,exitflag,ouput,jac] = fsolve(@ecoli_reuss_rhs_fun_mod, c, options_eq);

ev = zeros(n_cons,1);
ev = eig(jac);
for i=1:n_cons
    
    if 0 == imag(ev(i))
        fprintf(fid,'%12.6f\n',real(ev(i)));
    else
        fprintf(fid,'%12.6f   %12.6f\n', real(ev(i)), imag(ev(i)));        
    end    
end    

done = 1;   % MATLAB requires at least one return parameter

% END OF FUNCTION: print_stability_analysis_file_mod
