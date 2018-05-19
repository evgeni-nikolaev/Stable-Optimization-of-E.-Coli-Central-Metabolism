%=====================================================================
% FUNCTION: ecoli_reuss_rhs_mod
%=====================================================================
function [dcdt] = ecoli_reuss_rhs_mod(t,c)
%
%   PURPOSE: Assigns the right hand sides for the Reuss' dynamical model of Escherichia coli
%
%   Last Modified: 2004-12-14
%

%disp('*** START *** ecoli_reuss_rhs_mod(t,c)')        
%disp(t);

n_cons = 17;

% %---------------------------------------------------------------------
% % Unbalanced metabolites
% %---------------------------------------------------------------------
% c_atp = 4.27;   
% c_adp = 0.595;  
% c_amp = 0.955;  
% c_nadph = 0.062;  
% c_nadp = 0.195;  
% c_nadh = 0.1;    
% c_nad = 1.47;   
% 
% %---------------------------------------------------------------------
% % Fixed concentrations
% %---------------------------------------------------------------------
% c_glc_ext = 0.0556; 

%---------------------------------------------------------------------
% Dynamic concentrations
%---------------------------------------------------------------------
min_c = min(c);

if min_c < 0
    for i=1:n_cons
        if c(i) < 0
            c(i) = 0.0001;
        end            
    end            
end    

% c_g6p = c(1);
% c_f6p = c(2);
% c_fdp = c(3);
% c_gap = c(4);
% c_dhap = c(5);
% c_pgp = c(6);
% c_3pg = c(7);
% c_2pg = c(8);
% c_pep = c(9);
% c_pyr = c(10);
% c_6pg = c(11);
% c_ribu5p = c(12);
% c_xyl5p = c(13);
% c_sed7p = c(14);
% c_rib5p = c(15);
% c_e4p = c(16);
% c_g1p = c(17);

%=====================================================================
% Kinetic Rates
%=====================================================================
n_rts = 30;
rate = zeros(n_rts,1);
%rate = ecoli_reuss_rates_mod(t,c);

%   Plug ecoli_reuss_rates_mod function to calculate rate

%=====================================================================
% FUNCTION: ecoli_reuss_rates_mod
%=====================================================================
%function [rate]=ecoli_reuss_rates_mod(t,c)
%
%   PURPOSE: Computes the reaction rates for the Reuss' dynamical model of Escherichia coli
%
%   Last modified: 2004-12-14
%
% disp('*** START *** ecoli_reuss_rhs_mod(t,c)')


%---------------------------------------------------------------------
% Unbalanced metabolites
%---------------------------------------------------------------------
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
c_glc_ext = 0.0556; 

%---------------------------------------------------------------------
% Dynamic concentrations
%---------------------------------------------------------------------
c_g6p = c(1);
c_f6p = c(2);
c_fdp = c(3);
c_gap = c(4);
c_dhap = c(5);
c_pgp = c(6);
c_3pg = c(7);
c_2pg = c(8);
c_pep = c(9);
c_pyr = c(10);
c_6pg = c(11);
c_ribu5p = c(12);
c_xyl5p = c(13);
c_sed7p = c(14);
c_rib5p = c(15);
c_e4p = c(16);
c_g1p = c(17);

%---------------------------------------------------------------------
% Maximal rates
%---------------------------------------------------------------------
global rmax K reg;

r_PTS_max = rmax(1);    
r_PGI_max = rmax(2);
r_PFK_max = rmax(3);
r_ALDO_max = rmax(4);
r_TIS_max = rmax(5); 
r_GAPDH_max = rmax(6);
r_PGK_max = rmax(7);
r_PGM_max = rmax(8);                % former PGluMu
r_ENO_max = rmax(9);
r_PK_max = rmax(10);
r_PDH_max = rmax(11);
r_PepCxylase_max = rmax(12);
r_PGlucoM_max = rmax(13);            % former PGM
r_G1PAT_max = rmax(14);
r_RPPK_max = rmax(15);
r_G3PDH_max = rmax(16);
r_SerSynth_max = rmax(17);
r_Synth1_max = rmax(18);
r_Synth2_max = rmax(19);
r_DAHPS_max = rmax(20);
r_G6PDH_max = rmax(21);
r_PGDH_max = rmax(22);
r_Ru5P_max = rmax(23); 
r_R5PI_max = rmax(24);
r_TKa_max = rmax(25);
r_TKb_max = rmax(26); 
r_TA_max = rmax(27);
r_MurSynth_max = rmax(28);
r_TrpSynth_max = rmax(29);
r_MetSynth_max = rmax(30);

%---------------------------------------------------------------------
% Regulation
%---------------------------------------------------------------------
REG_PTS_g6p         = reg(1);    % PTS   inhibition  by  g6p 
REG_PGI_6pg         = reg(2);    % PGI   inhibition  by  6pg
REG_PFK_pep         = reg(3);    % PFK   inhibition  by  pep
REG_PFK_adp         = reg(4);    % PFK   activation  by  adp
REG_PFK_amp         = reg(5);    % PFK   activation  by  amp
REG_PK_amp          = reg(6);    % PK    activation  by  amp
REG_PK_fdp          = reg(7);    % PK    activation  by  fdp
REG_PK_atp          = reg(8);    % PK    inhibition  by  atp
REG_G1PAT_fdp       = reg(9);    % G1PAT activation  by  fdp
REG_G6PDH_nadph     = reg(10);   % G6PDH inhibition  by  nadph
REG_PGDH_atp        = reg(11);   % PGDH  inhibition  by  atp
REG_PGDH_nadph      = reg(12);   % PGDH  inhibition  by  nadph
REG_PEPCxylase_fdp  = reg(13);   % PEPCxylase activatin by fdp

%--------------------------------------------------------------------
% K's
%--------------------------------------------------------------------
K_PTS_a1 = K(1);   
K_PTS_a2 = K(2);
K_PTS_a3 = K(3);
K_PTS_g6p = K(4);
n_PTS_g6p = K(5);
K_PGI_g6p = K(6);            
K_PGI_f6p = K(7);
K_PGI_eq  = K(8);
K_PGI_g6p_6pginh = K(9);
K_PGI_f6p_6pginh = K(10);
K_PFK_f6p_s = K(11);        
K_PFK_atp_s = K(12); 
K_PFK_adp_a = K(13); 
K_PFK_adp_b = K(14); 
K_PFK_adp_c = K(15);
K_PFK_amp_a = K(16); 
K_PFK_amp_b = K(17); 
K_PFK_pep = K(18);    
L_PFK = K(19);        
n_PFK = K(20);
K_ALDO_fdp  = K(21);         
K_ALDO_dhap = K(22);
K_ALDO_gap  = K(23); 
K_ALDO_gap_inh = K(24);  
V_ALDO_blf = K(25); 
K_ALDO_eq  = K(26);
K_TIS_dhap = K(27);           
K_TIS_gap  = K(28);
K_TIS_eq   = K(29);
K_GAPDH_gap  = K(30);       
K_GAPDH_pgp  = K(31); 
K_GAPDH_nad  = K(32); 
K_GAPDH_nadh = K(33);
K_GAPDH_eq   = K(34);
K_PGK_pgp = K(35);         
K_PGK_3pg = K(36); 
K_PGK_adp = K(37); 
K_PGK_atp = K(38);
K_PGK_eq  = K(39);
K_PGM_3pg = K(40);            
K_PGM_2pg = K(41);
K_PGM_eq  = K(42);
K_ENO_2pg = K(43);            
K_ENO_pep = K(44);
K_ENO_eq  = K(45);
K_PK_pep = K(46);            
K_PK_adp = K(47);
K_PK_atp = K(48);
K_PK_fdp = K(49);
K_PK_amp = K(50);
L_PK = K(51);
n_PK = K(52);
K_PDH_pyr = K(53);         
n_PDH = K(54);
K_PepCxylase_pep = K(55);    
K_PepCxylase_fdp = K(56);
n_PepCxylase_fdp = K(57);
K_PGlucoM_g6p = K(58);      
K_PGlucoM_g1p = K(59);
K_PGlucoM_eq  = K(60);
K_G1PAT_g1p = K(61);          
K_G1PAT_atp = K(62);
K_G1PAT_fdp = K(63);
n_G1PAT_fdp = K(64);
K_RPPK_rib5p = K(65);         % 15. RPPK      (ribose phosphate pyrophosphokinase)
K_G3PDH_dhap = K(66);         % 16. G3PDH     (glycerol 3-phosphate-dehydrogenase)
K_SerSynth_3pg = K(67);       % 17. SerSynth  (serine synthesis)
K_Synth1_pep = K(68);         % 18. Synth1    (empirical)
K_Synth2_pyr = K(69);         % 19. Synth2    (empirical)
K_DAHPS_e4p = K(70);        
K_DAHPS_pep = K(71);
n_DAHPS_e4p = K(72);
n_DAHPS_pep = K(73);
K_G6PDH_g6p = K(74);         
K_G6PDH_nadp = K(75);
K_G6PDH_nadph_nadphinh = K(76); 
K_G6PDH_nadph_g6pihn = K(77);
K_PGDH_6pg = K(78);          
K_PGDH_nadp = K(79);
K_PGDH_nadph_inh = K(80);
K_PGDH_atp_inh = K(81);
K_Ru5P_eq  = K(82);           % 23. Ru5P  (ribulose phosphate epimerase)
K_R5PI_eq = K(83);            % 24. R5PI  (ribose phosphate isomerase) 
K_TKa_eq  = K(84);            % 25. TKa   (transketolase a)   
K_TKb_eq  = K(85);           % 26. TKb   (transketolase b)   
K_TA_eq  = K(86);            % 27. TA    (transaldolase)   

%---------------------------------------------------------------------
% 1. PTS (phosphotransferase system: g6p inhibition)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_PTS_a1;
% global K_PTS_a2;
% global K_PTS_a3;
% global K_PTS_g6p; 
% global n_PTS_g6p;

% nonlinear terms and feedbacks 
fb_PTS_1 = c_pep/c_pyr;
fb_PTS_2 = K_PTS_a2*fb_PTS_1;
fb_PTS_3 = K_PTS_a3*c_glc_ext;
fb_PTS_4 = c_glc_ext*fb_PTS_1;
fb_PTS_g6p = (REG_PTS_g6p)*(c_g6p)^n_PTS_g6p/K_PTS_g6p;   % g6p inhibition

% rate equation
r_PTS = r_PTS_max*c_glc_ext*fb_PTS_1/(K_PTS_a1 + fb_PTS_2 + fb_PTS_3 + fb_PTS_4)/(1 + fb_PTS_g6p);

%fprintf(fid,'%s', 'r_PTS = ');
%fprintf(fid,'%18.6f\n',r_PTS);

%---------------------------------------------------------------------
% 2. PGI (phosphoglucoisomerase: reversible Michaelis-Menten kinetics 
%    with 6pg inhibitionh)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_PGI_g6p;
% global K_PGI_f6p;
% global K_PGI_eq;
% global K_PGI_g6p_6pginh;
% global K_PGI_f6p_6pginh;

% nonlinear terms and feedbacks 
fb_PGI_1 = c_f6p/K_PGI_eq;
fb_PGI_2 = (REG_PGI_6pg)*c_6pg/K_PGI_f6p_6pginh;              % 6pg inhibition
fb_PGI_3 = c_f6p/K_PGI_f6p/(1.0 + fb_PGI_2);
fb_PGI_4 = (REG_PGI_6pg)*c_6pg/K_PGI_g6p_6pginh;              % 6pg inhibition

%rate equation
r_PGI_UP = r_PGI_max*(c_g6p - fb_PGI_1);
r_PGI_DN = K_PGI_g6p*(1.0 + fb_PGI_3 + fb_PGI_4) + c_g6p;
r_PGI = r_PGI_UP/r_PGI_DN;

%fprintf(fid,'%s', 'r_PGI = ');
%fprintf(fid,'%18.6f\n',r_PGI);

%---------------------------------------------------------------------
% 3. PFK (phosphofructokinase: four-state allosteric model with 
%    adp and adp activation, and pep inhibition instead of atp inhibition)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_PFK_f6p_s;   
% global K_PFK_atp_s; 
% global K_PFK_adp_a; 
% global K_PFK_adp_b; 
% global K_PFK_adp_c;
% global K_PFK_amp_a; 
% global K_PFK_amp_b; 
% global K_PFK_pep;    
% global L_PFK;        
% global n_PFK;

% nonlinear terms and feedbacks 
fb_PFK_pep   = (REG_PFK_pep)*c_pep/K_PFK_pep;   % pep inhibition
fb_PFK_adp_b = c_adp/K_PFK_adp_b;
fb_PFK_amp_b = c_amp/K_PFK_amp_b;
A = 1.0 + fb_PFK_pep + fb_PFK_adp_b + fb_PFK_amp_b;

fb_PFK_adp_a = (REG_PFK_adp)*c_adp/K_PFK_adp_a;               % adp activation
fb_PFK_amp_b = (REG_PFK_amp)*c_amp/K_PFK_amp_a;               % amp activation
B = 1.0 + fb_PFK_adp_a + fb_PFK_amp_b;

AB = A/B;

fb_PFK_adp_c = c_adp/K_PFK_adp_c;
fb_PFK_atp_s = K_PFK_atp_s*(1.0 + fb_PFK_adp_c);

fb_PFK_f6p_s = c_f6p/K_PFK_f6p_s/AB;
fb_PFK_L = L_PFK/(1.0 + fb_PFK_f6p_s)^n_PFK;

fb_PFK_f6p_s_AB = K_PFK_f6p_s*AB;

% rate equation
r_PFK_UP = r_PFK_max*c_atp*c_f6p;
r_PFK_DN = (c_atp + K_PFK_atp_s*(1.0 + fb_PFK_adp_c))*(c_f6p + fb_PFK_f6p_s_AB)*(1 + fb_PFK_L);
r_PFK = r_PFK_UP/r_PFK_DN;

%fprintf(fid,'%s', 'r_PFK = ');
%fprintf(fid,'%18.6f\n',r_PFK);

%---------------------------------------------------------------------
% 4. ALDO (aldolase: ordered uni-bi mechanism)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_ALDO_fdp;
% global K_ALDO_dhap;
% global K_ALDO_gap; 
% global K_ALDO_gap_inh;  
% global V_ALDO_blf; 
% global K_ALDO_eq;

% nonlinear terms and feedbacks 
fb_ALDO_1 = c_gap*c_dhap/K_ALDO_eq;
fb_ALDO_2 = K_ALDO_gap*c_dhap/K_ALDO_eq/V_ALDO_blf;
fb_ALDO_3 = K_ALDO_dhap*c_gap/K_ALDO_eq/V_ALDO_blf;
fb_ALDO_4 = c_fdp*c_gap/K_ALDO_gap_inh;
fb_ALDO_5 = c_dhap*c_gap/K_ALDO_eq/V_ALDO_blf;

% rate equation
r_ALDO_UP = r_ALDO_max*(c_fdp - fb_ALDO_1);
r_ALDO_DN = K_ALDO_fdp + c_fdp + fb_ALDO_2 + fb_ALDO_3 + fb_ALDO_4 + fb_ALDO_5;
r_ALDO = r_ALDO_UP/r_ALDO_DN;

%fprintf(fid,'%s', 'r_ALDO = ');
%fprintf(fid,'%18.6f\n',r_ALDO);

%---------------------------------------------------------------------
% 5. TIS (triosephosphate isomerase: reversible Michaelis-Menten kinetics)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_TIS_dhap;
% global K_TIS_gap;
% global K_TIS_eq;

% nonlinear terms and feedbacks 
fb_TIS_1 = c_gap/K_TIS_eq;
fb_TIS_2 = c_gap/K_TIS_gap;

% rate equation
r_TIS_UP = r_TIS_max*(c_dhap - fb_TIS_1);
r_TIS_DN = K_TIS_dhap*(1.0 + fb_TIS_2) + c_dhap;
r_TIS = r_TIS_UP/r_TIS_DN;

%fprintf(fid,'%s', 'r_TIS = ');
%fprintf(fid,'%18.6f\n',r_TIS);

%---------------------------------------------------------------------
% 6. GAPDH (glyceraldehyde 3-phosphate dehydrogenase:
%    two substrate reversible Michaelis-Menten kinetics)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_GAPDH_gap;
% global K_GAPDH_pgp;
% global K_GAPDH_nad;
% global K_GAPDH_nadh;
% global K_GAPDH_eq;

% nonlinear terms and feedbacks 
fb_GAPDH_pgp_nadh = c_pgp*c_nadh/K_GAPDH_eq;
fb_GAPDH_pgp = c_pgp/K_GAPDH_pgp;
fb_GAPDH_nadh = c_nadh/K_GAPDH_nadh;

% rate equation
r_GAPDH_UP = r_GAPDH_max*(c_gap*c_nad - fb_GAPDH_pgp_nadh);
r_GAPDH_DN = (K_GAPDH_gap*(1.0 + fb_GAPDH_pgp) + c_gap)*(K_GAPDH_nad*(1.0 + fb_GAPDH_nadh) + c_nad);
r_GAPDH = r_GAPDH_UP/r_GAPDH_DN;

%fprintf(fid,'%s', 'r_GAPDH = ');
%fprintf(fid,'%18.6f\n',r_GAPDH);

%---------------------------------------------------------------------
% 7. PGK (phosphoglucerate kinase: two substrate reversible Michaelis-Menten kinetics)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_PGK_pgp;
% global K_PGK_3pg;
% global K_PGK_adp;
% global K_PGK_atp;
% global K_PGK_eq;

% nonlinear terms and feedbacks 
fb_PGK_atp_3pg = c_atp*c_3pg/K_PGK_eq;
fb_PGK_atp = c_atp/K_PGK_atp;
fb_PGK_3pg = c_3pg/K_PGK_3pg;

% rate equation
r_PGK_UP = r_PGK_max*(c_adp*c_pgp - fb_PGK_atp_3pg);
r_PGK_DN = (K_PGK_adp*(1.0 + fb_PGK_atp) + c_adp)*(K_PGK_pgp*(1.0 + fb_PGK_3pg) + c_pgp);
r_PGK = r_PGK_UP/r_PGK_DN;

%fprintf(fid,'%s', 'r_PGK = ');
%fprintf(fid,'%18.6f\n',r_PGK);

%---------------------------------------------------------------------
% 8. PGM (former PGluMu)
%    (phosphoglucerate mutase: reversible Michaelis-Menten kinetics)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_PGM_3pg; 
% global K_PGM_2pg;
% global K_PGM_eq;

% nonlinear terms and feedbacks 
fb_PGM_1 = c_2pg/K_PGM_eq;
fb_PGM_2 = c_2pg/K_PGM_2pg;

% rate equation
r_PGM_UP = r_PGM_max*(c_3pg - fb_PGM_1);
r_PGM_DN = K_PGM_3pg*(1.0 + fb_PGM_2) + c_3pg;
r_PGM = r_PGM_UP/r_PGM_DN;

%fprintf(fid,'%s', 'r_PGM = ');
%fprintf(fid,'%18.6f\n',r_PGM);

%---------------------------------------------------------------------
% 9. ENO (enolase: reversible Michaelis-Menten kinetics)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_ENO_2pg;
% global K_ENO_pep;
% global K_ENO_eq;

% nonlinear terms and feedbacks 
fb_ENO_1 = c_pep/K_ENO_eq;
fb_ENO_2 = c_pep/K_ENO_pep;

% rate equation
r_ENO_UP = r_ENO_max*(c_2pg - fb_ENO_1);
r_ENO_DN = K_ENO_2pg*(1.0 + fb_ENO_2) + c_2pg;
r_ENO = r_ENO_UP/r_ENO_DN;

%fprintf(fid,'%s', 'r_ENO = ');
%fprintf(fid,'%18.6f\n',r_ENO);

%---------------------------------------------------------------------
% 10. PK (pyruvate kinase: with fdp activation, atp inhibition  
%     and additional term for amp activation)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_PK_pep;
% global K_PK_adp; 
% global K_PK_atp; 
% global K_PK_fdp; 
% global K_PK_amp; 
% global L_PK; 
% global n_PK; 

% nonlinear terms and feedbacks 
fb_PK_pep = c_pep/K_PK_pep; 
fb_PK_atp = (REG_PK_atp)*c_atp/K_PK_atp; % atp inhibition
fb_PK_fdp = (REG_PK_fdp)*c_fdp/K_PK_fdp; % fdp activation
fb_PK_amp = (REG_PK_amp)*c_amp/K_PK_amp; % amp activation
fb_PK_L = L_PK*( (1.0 + fb_PK_atp)/(fb_PK_fdp + fb_PK_amp + 1.0) )^n_PK; 

% rate equation
r_PK_UP = r_PK_max*c_adp*c_pep*(fb_PK_pep + 1.0)^(n_PK - 1);
r_PK_DN = K_PK_pep*(fb_PK_L + (fb_PK_pep + 1.0)^n_PK)*(c_adp + K_PK_adp);
r_PK = r_PK_UP/r_PK_DN;

%fprintf(fid,'%s', 'r_PK = ');
%fprintf(fid,'%18.6f\n',r_PK);

%---------------------------------------------------------------------
% 11. PDH (pyruvate dehydrogenase: empirical Hill equation)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_PDH_pyr;
% global n_PDH;

% rate equation
r_PDH_UP = r_PDH_max*c_pyr^n_PDH;
r_PDH_DN = K_PDH_pyr + c_pyr^n_PDH;
r_PDH = r_PDH_UP/r_PDH_DN;

%fprintf(fid,'%s', 'r_PDH = ');
%fprintf(fid,'%18.6f\n',r_PDH);

%---------------------------------------------------------------------
% 12. PepCxylase (pep carboxylase: impirical equation including
%     allosteric fdp activation)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_PepCxylase_pep;
% global K_PepCxylase_fdp;
% global n_PepCxylase_fdp;

% nonlinear terms and feedbacks 
fb_PepCxylase_fdp = (REG_PEPCxylase_fdp)*(c_fdp/K_PepCxylase_fdp)^n_PepCxylase_fdp; % fdp activation

% rate equation
r_PepCxylase_UP = r_PepCxylase_max*c_pep*(1.0 + fb_PepCxylase_fdp);
r_PepCxylase_DN = K_PepCxylase_pep + c_pep;
r_PepCxylase = r_PepCxylase_UP/r_PepCxylase_DN;

%fprintf(fid,'%s', 'r_PepCxylase = ');
%fprintf(fid,'%18.6f\n',r_PepCxylase);

%---------------------------------------------------------------------
% 13. PGlucoM (former PGM)
%     (phosphoglucomutase: reversible Michaelis-Menten kinetics)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_PGlucoM_g6p    K_PGlucoM_g1p   K_PGlucoM_eq 

% nonlinear terms and feedbacks 
fb_PGlucoM_1 = c_g1p/K_PGlucoM_eq;
fb_PGlucoM_2 = c_g1p/K_PGlucoM_g1p;

% rate equation
r_PGlucoM_UP = r_PGlucoM_max*(c_g6p - fb_PGlucoM_1);
r_PGlucoM_DN = K_PGlucoM_g6p*(1.0 + fb_PGlucoM_2) + c_g6p;
r_PGlucoM = r_PGlucoM_UP/r_PGlucoM_DN;

%fprintf(fid,'%s', 'r_PGlucoM = ');
%fprintf(fid,'%18.6f\n',r_PGlucoM);

%---------------------------------------------------------------------
% 14. G1PAT (glucose 1-phosphate adenyltransferase: 
%            empirical two-substrate equation including allosteric fdp activation)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_G1PAT_g1p;
% global K_G1PAT_atp;
% global K_G1PAT_fdp;
% global n_G1PAT_fdp;
 
% nonlinear terms and feedbacks 
fb_G1PAT_fdp = (REG_G1PAT_fdp)*(c_fdp/K_G1PAT_fdp)^n_G1PAT_fdp;     % fdp activation

% rate equation
r_G1PAT_UP = r_G1PAT_max*c_g1p*c_atp*(1.0 + fb_G1PAT_fdp);
r_G1PAT_DN = (K_G1PAT_g1p + c_g1p)*(K_G1PAT_atp + c_atp);
r_G1PAT = r_G1PAT_UP/r_G1PAT_DN;

%fprintf(fid,'%s', 'r_G1PAT = ');
%fprintf(fid,'%18.6f\n',r_G1PAT);

%---------------------------------------------------------------------
% 15. RPPK (ribose phosphate pyrophosphokinase: Michaelis-Menten kinetics)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_RPPK_rib5p;

% rate equation
r_RPPK_UP = r_RPPK_max*c_rib5p;
r_RPPK_DN = K_RPPK_rib5p + c_rib5p;
r_RPPK = r_RPPK_UP/r_RPPK_DN;

%fprintf(fid,'%s', 'r_RPPK_max = ');
%fprintf(fid,'%18.6f\n',r_RPPK_max);

%---------------------------------------------------------------------
% 16. G3PDH (glycerol 3-phosphate-dehydrogenase: Michaelis-Menten kinetics)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_G3PDH_dhap;

% rate equation
r_G3PDH_UP = r_G3PDH_max*c_dhap;
r_G3PDH_DN = K_G3PDH_dhap + c_dhap;
r_G3PDH = r_G3PDH_UP/r_G3PDH_DN;

%fprintf(fid,'%s', 'r_G3PDH = ');
%fprintf(fid,'%18.6f\n',r_G3PDH);

%---------------------------------------------------------------------
% 17. SerSynth (serine synthesis: Michaelis-Menten kinetics)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_SerSynth_3pg;

% rate equation
r_SerSynth_UP = r_SerSynth_max*c_3pg;
r_SerSynth_DN = K_SerSynth_3pg + c_3pg;
r_SerSynth = r_SerSynth_UP/r_SerSynth_DN;

%fprintf(fid,'%s', 'r_SerSynth = ');
%fprintf(fid,'%18.6f\n',r_SerSynth);

%---------------------------------------------------------------------
% 18. Synth1 (empirical equation)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_Synth1_pep;

% rate equation
r_Synth1_UP = r_Synth1_max*c_pep;
r_Synth1_DN = K_Synth1_pep + c_pep;
r_Synth1 = r_Synth1_UP/r_Synth1_DN;

%fprintf(fid,'%s', 'r_Synth1 = ');
%fprintf(fid,'%18.6f\n',r_Synth1);

%---------------------------------------------------------------------
% 19. Synth2 (empirical equation)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_Synth2_pyr;

% rate equation
r_Synth2_UP = r_Synth2_max*c_pyr;
r_Synth2_DN = K_Synth2_pyr + c_pyr;
r_Synth2 = r_Synth2_UP/r_Synth2_DN;

%fprintf(fid,'%s', 'r_Synth2 = ');
%fprintf(fid,'%18.6f\n',r_Synth2);

%---------------------------------------------------------------------
% 20. DAHPS (dahp synthase: two substrates Hill equation)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_DAHPS_e4p;
% global K_DAHPS_pep;
% global n_DAHPS_e4p;
% global n_DAHPS_pep;

% nonlinear terms and feedbacks 
fb_DAHPS_e4p = (c_e4p)^n_DAHPS_e4p;
fb_DAHPS_pep = (c_pep)^n_DAHPS_pep;

% rate equation
r_DAHPS_UP = r_DAHPS_max*fb_DAHPS_e4p*fb_DAHPS_pep;
r_DAHPS_DN = (K_DAHPS_e4p + fb_DAHPS_e4p)*(K_DAHPS_pep + fb_DAHPS_pep);
r_DAHPS = r_DAHPS_UP/r_DAHPS_DN;

%fprintf(fid,'%s', 'r_DAHPS = ');
%fprintf(fid,'%18.6f\n',r_DAHPS);

%---------------------------------------------------------------------
% 21. G6PDH (glucose-6-phosphate dehydrogenase: with nadph inhibition and 
%     atp inhibition removed)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_G6PDH_g6p;
% global K_G6PDH_nadp; 
% global K_G6PDH_nadph_nadphinh;
% global K_G6PDH_nadph_g6pihn;

% nonlinear terms and feedbacks 
fb_G6PDH_1 = (REG_G6PDH_nadph)*c_nadph/K_G6PDH_nadph_g6pihn;      % nadph inhibition
fb_G6PDH_2 = (REG_G6PDH_nadph)*c_nadph/K_G6PDH_nadph_nadphinh;    % nadph inhibition

% rate equation
r_G6PDH_UP = r_G6PDH_max*c_g6p*c_nadp;
r_G6PDH_DN = (c_g6p + K_G6PDH_g6p)*(1.0 + fb_G6PDH_1)*(K_G6PDH_nadp*(1.0 + fb_G6PDH_2) + c_nadp);
r_G6PDH = r_G6PDH_UP/r_G6PDH_DN;

%fprintf(fid,'%s', 'r_G6PDH = ');
%fprintf(fid,'%18.6f\n',r_G6PDH);

%---------------------------------------------------------------------
% 22. PGDH (6-phosphogluconate dehydrogenase: atp and nadph inhibitions)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_PGDH_6pg;
% global K_PGDH_nadp; 
% global K_PGDH_nadph_inh;
% global K_PGDH_atp_inh;

% nonlinear terms and feedbacks 
fb_PGDH_nadph = (REG_PGDH_nadph)*c_nadph/K_PGDH_nadph_inh;   % nadph inhibition
fb_PGDH_atp   = (REG_PGDH_atp)*c_atp/K_PGDH_atp_inh;         % atp inhibition

% rate equation
r_PGDH_UP = r_PGDH_max*c_6pg*c_nadp;
r_PGDH_DN = (c_6pg + K_PGDH_6pg)*(c_nadp + K_PGDH_nadp*(1.0 + fb_PGDH_nadph)*(1.0 + fb_PGDH_atp));
r_PGDH = r_PGDH_UP/r_PGDH_DN;

%fprintf(fid,'%s', 'r_PGDH = ');
%fprintf(fid,'%18.6f\n',r_PGDH);

%---------------------------------------------------------------------
% 23. Ru5P (ribulose phosphate epimerase: first order kinetics)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_Ru5P_eq;

% nonlinear terms and feedbacks 
fb_Ru5P_xyl5p = c_xyl5p/K_Ru5P_eq;

% rate equation
r_Ru5P = r_Ru5P_max*(c_ribu5p - fb_Ru5P_xyl5p); 

%fprintf(fid,'%s', 'r_Ru5P = ');
%fprintf(fid,'%18.6f\n',r_Ru5P);

%---------------------------------------------------------------------
% 24. R5PI (ribose phosphate isomerase: first order kinetics)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_R5PI_eq;

% nonlinear terms and feedbacks 
fb_R5PI_rib5p = c_rib5p/K_R5PI_eq;

% rate equation
r_R5PI = r_R5PI_max*(c_ribu5p - fb_R5PI_rib5p);

%fprintf(fid,'%s', 'r_R5PI = ');
%fprintf(fid,'%18.6f\n',r_R5PI);

%---------------------------------------------------------------------
% 25. TKa (transketolase a: first order kinetics)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_TKa_eq;

% rate equation
r_TKa = r_TKa_max*(c_rib5p*c_xyl5p - c_sed7p*c_gap/K_TKa_eq);

%fprintf(fid,'%s', 'r_TKa = ');
%fprintf(fid,'%18.6f\n',r_TKa);

%---------------------------------------------------------------------
% 26. TKb (transketolase b: first order kinetics)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_TKb_eq;

% rate equation
r_TKb = r_TKb_max*(c_xyl5p*c_e4p - c_f6p*c_gap/K_TKb_eq); 

%fprintf(fid,'%s', 'r_TKb = ');
%fprintf(fid,'%18.6f\n',r_TKb);

%---------------------------------------------------------------------
% 27. TA (transaldolase)
%---------------------------------------------------------------------
% kinetic constants and parameters
% global K_TA_eq;

% rate equation
r_TA = r_TA_max*(c_gap*c_sed7p - c_e4p*c_f6p/K_TA_eq);

%fprintf(fid,'%s', 'r_TA = ');
%fprintf(fid,'%18.6f\n',r_TA);

%---------------------------------------------------------------------
% 28. MurSynth (mureine synthesis)
%---------------------------------------------------------------------

% rate equation
r_MurSynth = r_MurSynth_max;

%---------------------------------------------------------------------
% 29. TrpSynth (tryptophan synthesis)
%---------------------------------------------------------------------
% rate equation
r_TrpSynth = r_TrpSynth_max;

%---------------------------------------------------------------------
% 30. MetSynth (methionine synthesis)
%---------------------------------------------------------------------
% rate equation
r_MetSynth = r_MetSynth_max;

%---------------------------------------------------------------------
% Generation of a rate-vector
%---------------------------------------------------------------------
%global n_rts;
%n_rts = 30;
%rate = zeros(n_rts,1);

rate(1)  = r_PTS;
rate(2)  = r_PGI;
rate(3)  = r_PFK;
rate(4)  = r_ALDO;
rate(5)  = r_TIS;
rate(6)  = r_GAPDH;
rate(7)  = r_PGK;
rate(8)  = r_PGM;
rate(9)  = r_ENO;
rate(10) = r_PK;
rate(11) = r_PDH;
rate(12) = r_PepCxylase;
rate(13) = r_PGlucoM;
rate(14) = r_G1PAT;
rate(15) = r_RPPK;
rate(16) = r_G3PDH;
rate(17) = r_SerSynth;
rate(18) = r_Synth1;
rate(19) = r_Synth2;
rate(20) = r_DAHPS;
rate(21) = r_G6PDH;
rate(22) = r_PGDH;
rate(23) = r_Ru5P; 
rate(24) = r_R5PI;
rate(25) = r_TKa;
rate(26) = r_TKb;
rate(27) = r_TA;
rate(28) = r_MurSynth;
rate(29) = r_TrpSynth;
rate(30) = r_MetSynth;

%fclose(fid);

% END OF FUNCTION: Ecoli_Reuss_Rates_Mod



r_PTS = rate(1);
r_PGI = rate(2);
r_PFK = rate(3);
r_ALDO = rate(4);
r_TIS = rate(5);
r_GAPDH = rate(6);
r_PGK = rate(7);
r_PGM = rate(8);
r_ENO = rate(9);
r_PK = rate(10);
r_PDH = rate(11);
r_PepCxylase = rate(12);
r_PGlucoM = rate(13);
r_G1PAT = rate(14);
r_RPPK = rate(15);
r_G3PDH = rate(16);
r_SerSynth = rate(17);
r_Synth1 = rate(18);
r_Synth2 = rate(19);
r_DAHPS = rate(20);
r_G6PDH = rate(21);
r_PGDH = rate(22);
r_Ru5P = rate(23); 
r_R5PI = rate(24);
r_TKa = rate(25);
r_TKb = rate(26);
r_TA = rate(27);
r_MurSynth = rate(28);
r_TrpSynth = rate(29);
r_MetSynth = rate(30);

%---------------------------------------------------------------------
% MASS BALANCES ODES
%---------------------------------------------------------------------
dcdt = zeros(n_cons,1);

STO = 65;

% c_g6p = c(1)
dcdt(1) = STO*r_PTS - r_PGI - r_G6PDH - r_PGlucoM;

% c_f6p = c(2)
dcdt(2) = r_PGI - r_PFK + r_TKb + r_TA - 2*r_MurSynth;

% c_fdp = c(3)
dcdt(3) = r_PFK - r_ALDO;

% c_gap = c(4)
dcdt(4) = r_ALDO + r_TIS - r_GAPDH + r_TKa + r_TKb - r_TA + r_TrpSynth;

% c_dhap = c(5)
dcdt(5) = r_ALDO - r_TIS - r_G3PDH;

% c_pgp = c(6)
dcdt(6) = r_GAPDH - r_PGK;

% c_3pg = c(7)
dcdt(7) = r_PGK - r_PGM - r_SerSynth;

% c_2pg = c(8)
dcdt(8) = r_PGM - r_ENO;

% c_pep = c(9)
dcdt(9) = r_ENO - r_PK - STO*r_PTS - r_PepCxylase - r_DAHPS - r_Synth1;

% c_pyr = c(10)
dcdt(10) = r_PK + STO*r_PTS - r_PDH - r_Synth2 + r_MetSynth + r_TrpSynth;

% c_6pg = c(11)
dcdt(11) = r_G6PDH - r_PGDH;

% c_ribu5p = c(12)
dcdt(12) = r_PGDH - r_Ru5P - r_R5PI;

% c_xyl5p = c(13)
dcdt(13) = r_Ru5P - r_TKa - r_TKb;

% c_sed7p = c(14)
dcdt(14) = r_TKa - r_TA;

% c_rib5p = c(15)
dcdt(15) = r_R5PI - r_TKa - r_RPPK;

% c_e4p = c(16)
dcdt(16) = r_TA - r_TKb - r_DAHPS;

% c_g1p = c(17)
dcdt(17) = r_PGlucoM - r_G1PAT;

% END OF FUNCTION: ecoli_reuss_rhs_mod