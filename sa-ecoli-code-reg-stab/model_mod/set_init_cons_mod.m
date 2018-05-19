%=====================================================================
% FUNCTION: set_init_cons_mod
%=====================================================================
function [n_cons, c] = set_init_cons_mod
%
%   PURPOSE:    Assigns initial conditions for concentrations in the Reuss' 
%               Escherichia coli model
%
%   Last Modified: 2004-12-14
%


%---------------------------------------------------------------------
% The numbers of concentrations
%---------------------------------------------------------------------
n_cons  = 17;

%---------------------------------------------------------------------
% Unbalanced metabolites
%---------------------------------------------------------------------
global c_atp c_adp c_amp c_nadph c_nadp c_nadh c_nad
c_atp = 4.27;   
c_adp = 0.595;  
c_amp = 0.955;  
c_nadph = 0.062;  
c_nadp = 0.195;  
c_nadh = 0.1;    
c_nad = 1.47;   

%---------------------------------------------------------------------
% Fixed concentrations
%---------------------------------------------------------------------
global c_glc_ext
c_glc_ext = 0.0556; 

%---------------------------------------------------------------------
% Dynamic concentrations
%---------------------------------------------------------------------
global c;
c = zeros(n_cons, 1);

c(1) = 3.48;    % c_g6p
c(2) = 0.60;    % c_f6p
c(3) = 0.272;   % c_fdp
c(4) = 0.218;   % c_gap
c(5) = 0.167;   % c_dhap
c(6) = 0.8e-02;   % c_pgp
c(7) = 2.131;   % c_3pg
c(8) = 0.399;   % c_2pg
c(9) = 2.67;   % c_pep
c(10) = 2.67;   % c_pyr
c(11) = 0.8075; % c_6pg
c(12) = 0.111;  % c_ribu5p 
c(13) = 0.138;  % c_xyl5p 
c(14) = 0.276;  % c_sed7p
c(15) = 0.398;  % c_rib5p
c(16) = 0.098;  % c_e4p
c(17) = 0.6525; % c_g1p

done = 1;   % MATLAB requires at least one return parameter

% END OF FUNCTION: Set_Init_Cons_Mod