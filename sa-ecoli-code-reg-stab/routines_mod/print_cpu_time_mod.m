%=====================================================================
% FUNCTION: print_cpu_time_mod
%=====================================================================
function [done] = print_cpu_time_mod(allSec)
%
% PURPOSE: Print out time in hr:min:sec format, where [t] = sec
% 
done = 0;   % MATLAB requires at least one return parameter

allMin = floor(allSec/60);
tSec = floor(allSec - allMin*60);
tHr  = floor(allMin/60);
tMin = floor(allMin - tHr*60);

fprintf('\nCPU time: (hr:min:sec) =  (%2i:%2i:%2i)\n', tHr, tMin, tSec);

done = 1;   % MATLAB requires at least one return parameter
% END OF FUNCTION: Print_CPU_Time