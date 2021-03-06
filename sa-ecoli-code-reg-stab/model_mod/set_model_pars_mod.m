%=====================================================================
% FUNCTION: set_model_pars_mod
%=====================================================================
%
function [n_rts,rmax,n_reg,reg,reg_enz_ind,K] = set_model_pars_mod
%
%   PURPOSE: sets kinetic parameters for the Reuss' dynamical model of Escherichia coli
%
%   Last Modified: 2005-12-10
%

%---------------------------------------------------------------------
% The numbers of rates and regulations
%---------------------------------------------------------------------
n_rts  = 30;
n_reg  = 13;

%---------------------------------------------------------------------
% Maximal reaction rates
%---------------------------------------------------------------------
rmax = zeros(n_rts,1);

global STO;
STO = 65;
%STO = 1;

rmax(1) = 508935.8779/STO;  % r_PTS_max
%rmax(1) = 508935.8779;     % r_PTS_max
rmax(2) = 650.9878687;      % r_PGI_max
rmax(3) = 1840.584747;      % r_PFK_max
rmax(4) = 17.41464425;      % r_ALDO_max
rmax(5) = 68.67474392;      % r_TIS_max
rmax(6) = 921.5942861;      % r_GAPDH_max
rmax(7) = 3021.773771;      % r_PGK_max
rmax(8) = 89.04965407;      % r_PGM_max (former PGluMu)
rmax(9) = 330.4476151;      % r_ENO_max
rmax(10) = 0.06113150238;   % r_PK_max
rmax(11) = 6.059531017;     % r_PDH_max
rmax(12) = 0.1070205858;    % r_PepCxylase_max
rmax(13) = 0.8398242773;    % r_PGlucoM_max (former PGM)
rmax(14) = 0.007525458026;  % r_G1PAT_max
rmax(15) = 0.01290045226;   % r_RPPK_max
rmax(16) = 0.01162042696;   % r_G3PDH_max
rmax(17) = 0.02571210700;   % r_SerSynth_max
rmax(18) = 0.01953897003;   % r_Synth1_max
rmax(19) = 0.07361855055;   % r_Synth2_max
rmax(20) = 0.1079531227;    % r_DAHPS_max
rmax(21) = 1.380196955;     % r_G6PDH_max
rmax(22) = 16.23235977;     % r_PGDH_max
rmax(23) = 6.739029475;     % r_Ru5P_max
rmax(24) = 4.838411930;     % r_R5PI_max
rmax(25) = 9.473384783;     % r_TKa_max
rmax(26) = 86.55855855;     % r_TKb_max    
rmax(27) = 10.87164108;     % r_TA_max
rmax(28) = 0.43711e-3;      % r_MurSynth_max
rmax(29) = 0.10370e-2 ;     % r_TrpSynth_max
rmax(30) = 0.22627e-2;      % r_MetSynth_max

%---------------------------------------------------------------------
% Regulation
%---------------------------------------------------------------------
reg_enz_ind = zeros(n_reg,1);
reg  = zeros(n_reg,1);

reg(1)  = 1;    % PTS   inhibition  by  g6p 
reg(2)  = 1;    % PGI   inhibition  by  6pg
reg(3)  = 1;    % PFK   inhibition  by  pep
reg(4)  = 1;    % PFK   activation  by  adp
reg(5)  = 1;    % PFK   activation  by  amp
reg(6)  = 1;    % PK    activation  by  amp
reg(7)  = 1;    % PK    activation  by  fdp
reg(8)  = 1;    % PK    inhibition  by  atp
reg(9)  = 1;    % G1PAT activation  by  fdp
reg(10) = 1;    % G6PDH inhibition  by  nadph
reg(11) = 1;    % PGDH  inhibition  by  atp
reg(12) = 1;    % PGDH  inhibition  by  nadph
reg(13) = 1;    % PEPCxylase activatin by fdp

reg_enz_ind(1)  = 1;    % PTS   inhibition  by  g6p 
reg_enz_ind(2)  = 2;    % PGI   inhibition  by  6pg
reg_enz_ind(3)  = 3;    % PFK   inhibition  by  pep
reg_enz_ind(4)  = 3;    % PFK   activation  by  adp
reg_enz_ind(5)  = 3;    % PFK   activation  by  amp
reg_enz_ind(6)  = 10;   % PK    activation  by  amp
reg_enz_ind(7)  = 10;   % PK    activation  by  fdp
reg_enz_ind(8)  = 10;   % PK    inhibition  by  atp
reg_enz_ind(9)  = 14;   % G1PAT activation  by  fdp
reg_enz_ind(10) = 21;   % G6PDH inhibition  by  nadph
reg_enz_ind(11) = 22;   % PGDH  inhibition  by  atp
reg_enz_ind(12) = 22;   % PGDH  inhibition  by  nadph
reg_enz_ind(13) = 12;   % PEPCxylase activatin by fdp

%---------------------------------------------------------------------
% Kinetic constants and parameters
%---------------------------------------------------------------------
% 1. PTS (phosphotransferase system)
%---------------------------------------------------------------------
 global K_PTS_a1     K_PTS_a2    K_PTS_a3    K_PTS_g6p   n_PTS_g6p   
K_PTS_a1  = 3082.3;         
K_PTS_a2  = 0.01;
K_PTS_a3  = 245.3;
K_PTS_g6p = 2.15;
n_PTS_g6p = 3.66;

K = zeros(86,1);
K(1) = 3082.3;         
K(2) = 0.01;
K(3) = 245.3;
K(4) = 2.15;
K(5) = 3.66;


%---------------------------------------------------------------------
% 2. PGI (phosphoglucoisomerase)
%---------------------------------------------------------------------
 global K_PGI_g6p K_PGI_f6p K_PGI_eq K_PGI_g6p_6pginh K_PGI_f6p_6pginh
K_PGI_g6p = 2.9;            
K_PGI_f6p = 0.266;
K_PGI_eq  =  0.1725;
K_PGI_g6p_6pginh = 0.2;
K_PGI_f6p_6pginh = 0.2;

K(6) = 2.9;            
K(7) = 0.266;
K(8) =  0.1725;
K(9) = 0.2;
K(10) = 0.2;

%---------------------------------------------------------------------
% 3. PFK (phosphofructokinase)
%---------------------------------------------------------------------
 global K_PFK_f6p_s  K_PFK_atp_s     K_PFK_adp_a     K_PFK_adp_b     K_PFK_adp_c
 global K_PFK_amp_a  K_PFK_amp_b     K_PFK_pep       L_PFK n_PFK
K_PFK_f6p_s = 0.325;        
K_PFK_atp_s = 0.123; 
K_PFK_adp_a = 128.; 
K_PFK_adp_b = 3.89; 
K_PFK_adp_c = 4.14;
K_PFK_amp_a = 19.1; 
K_PFK_amp_b = 3.2; 
K_PFK_pep = 3.26;    
L_PFK = 5629067;        
n_PFK = 11.1;

K(11) = 0.325;        
K(12) = 0.123; 
K(13) = 128.; 
K(14) = 3.89; 
K(15) = 4.14;
K(16) = 19.1; 
K(17) = 3.2; 
K(18) = 3.26;    
K(19) = 5629067;        
K(20) = 11.1;

%---------------------------------------------------------------------
% 4. ALDO (aldolase)
%---------------------------------------------------------------------
 global K_ALDO_fdp K_ALDO_dhap K_ALDO_gap K_ALDO_gap_inh V_ALDO_blf K_ALDO_eq
K_ALDO_fdp  = 1.75;         
K_ALDO_dhap = 0.088;
K_ALDO_gap  = 0.088; 
K_ALDO_gap_inh = 0.6;  
V_ALDO_blf = 2; 
K_ALDO_eq  = 0.144;

K(21) = 1.75;         
K(22) = 0.088;
K(23) = 0.088; 
K(24) = 0.6;  
K(25) = 2; 
K(26) = 0.144;

%---------------------------------------------------------------------
% 5. TIS (triosephosphate isomerase)
%---------------------------------------------------------------------
 global K_TIS_dhap K_TIS_gap K_TIS_eq
K_TIS_dhap = 2.8;           
K_TIS_gap  = 0.3;
K_TIS_eq   = 1.39;

K(27) = 2.8;           
K(28) = 0.3;
K(29) = 1.39;

%---------------------------------------------------------------------
% 6. GAPDH (glyceraldehyde 3-phosphate dehydrogenase)
%---------------------------------------------------------------------
 global K_GAPDH_gap K_GAPDH_pgp K_GAPDH_nad K_GAPDH_nadh K_GAPDH_eq
K_GAPDH_gap  = 0.683;       
K_GAPDH_pgp  = 0.0000104; 
K_GAPDH_nad  = 0.252; 
K_GAPDH_nadh = 1.09;
K_GAPDH_eq   = 0.63;

K(30) = 0.683;       
K(31) = 0.0000104; 
K(32) = 0.252; 
K(33) = 1.09;
K(34) = 0.63;

%---------------------------------------------------------------------
% 7. PGK (phosphoglucerate kinase)
%---------------------------------------------------------------------
 global K_PGK_pgp K_PGK_3pg K_PGK_adp K_PGK_atp K_PGK_eq
K_PGK_pgp = 0.0468;         
K_PGK_3pg = 0.473; 
K_PGK_adp = 0.185; 
K_PGK_atp = 0.653;
K_PGK_eq  = 1934.4;

K(35) = 0.0468;         
K(36) = 0.473; 
K(37) = 0.185; 
K(38) = 0.653;
K(39) = 1934.4;

%---------------------------------------------------------------------
% 8. PGM (former PGluMu) (phosphoglucerate mutase)
%---------------------------------------------------------------------
 global K_PGM_3pg K_PGM_2pg K_PGM_eq
K_PGM_3pg = 0.2;            
K_PGM_2pg = 0.369;
K_PGM_eq  = 0.188;

K(40) = 0.2;            
K(41) = 0.369;
K(42) = 0.188;

%---------------------------------------------------------------------
% 9. ENO (enolase)
%---------------------------------------------------------------------
 global K_ENO_2pg K_ENO_pep K_ENO_eq
K_ENO_2pg = 0.1;            
K_ENO_pep = 0.135;
K_ENO_eq  = 6.73;

K(43) = 0.1;            
K(44) = 0.135;
K(45) = 6.73;

%---------------------------------------------------------------------
% 10. PK (pyruvate kinase)
%---------------------------------------------------------------------
global K_PK_pep K_PK_adp K_PK_atp K_PK_fdp K_PK_amp L_PK n_PK
K_PK_pep = 0.31;            
K_PK_adp = 0.26;
K_PK_atp = 22.5;
K_PK_fdp = 0.19;
K_PK_amp = 0.2;
L_PK = 1000;
n_PK = 4;

K(46) = 0.31;            
K(47) = 0.26;
K(48) = 22.5;
K(49) = 0.19;
K(50) = 0.2;
K(51) = 1000;
K(52) = 4;

%---------------------------------------------------------------------
% 11. PDH (pyruvate dehydrogenase)
%---------------------------------------------------------------------
global K_PDH_pyr n_PDH
K_PDH_pyr = 1159.0;         
n_PDH = 3.68;

K(53) = 1159.0;         
K(54) = 3.68;

%---------------------------------------------------------------------
% 12. PepCxylase (pep carboxylase)
%---------------------------------------------------------------------
global K_PepCxylase_pep K_PepCxylase_fdp n_PepCxylase_fdp
K_PepCxylase_pep = 4.07;    
K_PepCxylase_fdp = 0.7;
n_PepCxylase_fdp = 4.21;

K(55) = 4.07;    
K(56) = 0.7;
K(57) = 4.21;

%---------------------------------------------------------------------
% 13. PGlucoM (former PGM) (phosphoglucomutase)
%---------------------------------------------------------------------
global K_PGlucoM_g6p    K_PGlucoM_g1p   K_PGlucoM_eq
K_PGlucoM_g6p = 1.038;      
K_PGlucoM_g1p = 0.0136;
K_PGlucoM_eq  = 0.196;

K(58) = 1.038;      
K(59) = 0.0136;
K(60) = 0.196;
%---------------------------------------------------------------------
% 14. G1PAT (glucose 1-phosphate adenyltransferase)
%---------------------------------------------------------------------
global K_G1PAT_g1p K_G1PAT_atp K_G1PAT_fdp n_G1PAT_fdp
K_G1PAT_g1p = 3.2;          
K_G1PAT_atp = 4.42;
K_G1PAT_fdp = 0.119;
n_G1PAT_fdp = 1.2;

K(61) = 3.2;          
K(62) = 4.42;
K(63) = 0.119;
K(64) = 1.2;

%---------------------------------------------------------------------
% GROUP OF PARAMETERS
%---------------------------------------------------------------------
global K_RPPK_rib5p K_G3PDH_dhap K_SerSynth_3pg K_Synth1_pep K_Synth2_pyr
K_RPPK_rib5p = 0.1;         % 15. RPPK      (ribose phosphate pyrophosphokinase)
K_G3PDH_dhap = 1.0;         % 16. G3PDH     (glycerol 3-phosphate-dehydrogenase)
K_SerSynth_3pg = 1.0;       % 17. SerSynth  (serine synthesis)
K_Synth1_pep = 1.0;         % 18. Synth1    (empirical)
K_Synth2_pyr = 1.0;         % 19. Synth2    (empirical)

K(65) = 0.1;         % 15. RPPK      (ribose phosphate pyrophosphokinase)
K(66) = 1.0;         % 16. G3PDH     (glycerol 3-phosphate-dehydrogenase)
K(67) = 1.0;       % 17. SerSynth  (serine synthesis)
K(68) = 1.0;         % 18. Synth1    (empirical)
K(69) = 1.0;         % 19. Synth2    (empirical)

%---------------------------------------------------------------------
% 20. DAHPS (dahp synthase)
%---------------------------------------------------------------------
global K_DAHPS_e4p K_DAHPS_pep n_DAHPS_e4p n_DAHPS_pep
K_DAHPS_e4p = 0.035;        
K_DAHPS_pep = 0.0053;
n_DAHPS_e4p = 2.6;
n_DAHPS_pep = 2.2;

K(70) = 0.035;        
K(71) = 0.0053;
K(72) = 2.6;
K(73) = 2.2;

%---------------------------------------------------------------------
% 21. G6PDH (glucose-6-phosphate dehydrogenase)
%---------------------------------------------------------------------
global K_G6PDH_g6p  K_G6PDH_nadp    K_G6PDH_nadph_nadphinh   K_G6PDH_nadph_g6pihn
K_G6PDH_g6p = 14.4;         
K_G6PDH_nadp = 0.0246;
K_G6PDH_nadph_nadphinh = 0.01; 
K_G6PDH_nadph_g6pihn = 6.43;

K(74) = 14.4;         
K(75) = 0.0246;
K(76) = 0.01; 
K(77) = 6.43;

%---------------------------------------------------------------------
% 22. PGDH  (6-phosphogluconate dehydrogenase)
%---------------------------------------------------------------------
global K_PGDH_6pg K_PGDH_nadp K_PGDH_nadph_inh K_PGDH_atp_inh
K_PGDH_6pg = 37.5;          
K_PGDH_nadp = 0.0506;
K_PGDH_nadph_inh = 0.0138;
K_PGDH_atp_inh = 208;

K(78) = 37.5;          
K(79) = 0.0506;
K(80) = 0.0138;
K(81) = 208;

%---------------------------------------------------------------------
% GROUP OF PARAMETERS
%---------------------------------------------------------------------
global K_Ru5P_eq K_R5PI_eq K_TKa_eq K_TKb_eq K_TA_eq
K_Ru5P_eq  = 1.4;           % 23. Ru5P  (ribulose phosphate epimerase)
K_R5PI_eq = 4.0;            % 24. R5PI  (ribose phosphate isomerase) 
K_TKa_eq  = 1.2;            % 25. TKa   (transketolase a)   
K_TKb_eq  = 10.0;           % 26. TKb   (transketolase b)   
K_TA_eq  = 1.05;            % 27. TA    (transaldolase)   

K(82) = 1.4;           % 23. Ru5P  (ribulose phosphate epimerase)
K(83) = 4.0;            % 24. R5PI  (ribose phosphate isomerase) 
K(84) = 1.2;            % 25. TKa   (transketolase a)   
K(85) = 10.0;           % 26. TKb   (transketolase b)   
K(86) = 1.05;            % 27. TA    (transaldolase)   

% END OF FUNCTION: Set_Model_Pars_Mod