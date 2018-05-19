%=====================================================================
% FUNCTION: print_go_job_parameters_mod
%=====================================================================
function [done] = print_go_job_parameters_mod()
%
% PURPOSE: Prints all input parameters to a LONG
%
done = 0;   % MATLAB requires at least one return parameter

global file_name_LONG job_name;

%--------------------------------------------------------------------------
% OUTPUT TO LONG FILE
%--------------------------------------------------------------------------
fid_LONG = fopen(file_name_LONG,'a');
print_job_parameters_mod(fid_LONG, job_name);
fclose(fid_LONG);

done = 1;   % MATLAB requires at least one return parameter
% END OF FUNCTION: print_job_parameters_mod