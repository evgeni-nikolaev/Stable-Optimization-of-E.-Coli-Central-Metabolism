%=====================================================================
% FUNCTION: print_sa_job_parameters_mod
%=====================================================================
function [done] = print_sa_job_parameters_mod()
%
% PURPOSE: Prints all input parameters to a LONG file and job title to
% SHORT files
%
done = 0;   % MATLAB requires at least one return parameter

global file_name_LONG;
global file_name_ITER_SHORT file_name_TEMP_SHORT job_name;
global file_name_OPTP_SHORT file_name_FCC_SHORT;

%--------------------------------------------------------------------------
% OUTPUT TO LONG FILE
%--------------------------------------------------------------------------
fid_LONG = fopen(file_name_LONG,'a');
print_job_parameters_mod(fid_LONG, job_name);
fclose(fid_LONG);

%--------------------------------------------------------------------------
% OUTPUT TO SHORT ITERATION AND TEMPERATURE FILES
%--------------------------------------------------------------------------
[date] = fix(clock);

fid_ITER_SHORT = fopen(file_name_ITER_SHORT,'a');
fprintf(fid_ITER_SHORT,'DATE: %4d-%2d-%2d, %2d:%2d:%2d\n', date);
fprintf(fid_ITER_SHORT,'%s\n\n', job_name);
fclose(fid_ITER_SHORT);

fid_TEMP_SHORT = fopen(file_name_TEMP_SHORT,'w');
fprintf(fid_TEMP_SHORT,'DATE: %4d-%2d-%2d, %2d:%2d:%2d\n', date);
fprintf(fid_TEMP_SHORT,'%s\n\n', job_name);
fclose(fid_TEMP_SHORT);

fid_OPTP_SHORT = fopen(file_name_OPTP_SHORT,'w');
fprintf(fid_OPTP_SHORT,'DATE: %4d-%2d-%2d, %2d:%2d:%2d\n', date);
fprintf(fid_OPTP_SHORT,'%s\n\n', job_name);
fclose(fid_OPTP_SHORT);

fid_FCC_SHORT = fopen(file_name_FCC_SHORT,'w');
fprintf(fid_FCC_SHORT,'DATE: %4d-%2d-%2d, %2d:%2d:%2d\n', date);
fprintf(fid_FCC_SHORT,'%s\n\n', job_name);
fclose(fid_FCC_SHORT);

done = 1;   % MATLAB requires at least one return parameter
% END OF FUNCTION: print_job_parameters_mod