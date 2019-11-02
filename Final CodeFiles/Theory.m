% script m-file Theory.m
% code for checking on the correctness of my attempts to work the business
% through algebraically. This code checks how well a given method for
% computing information at acquisition explains the assumed facts about
% excitatory conditioning, which are, basically, that trials to acquisition
% is proportionate to the duty cycle T/C, where T is the average time
% between USs when the CS is present and C is the average basal time, that
% is, 1/lambda_raw, where lambda_raw is Nb/Tb. And, moreover, this holds no
% whether one changes the duty cycle by varying either C or T while holding
% the other constant in a protocol with no USs in ITIs or by varying the
% rate of USs in the ITIs 

%% Varying C/T with no ITI USs (June 9, 2017)
% T/C = 1/100 very small duty cycle produces very rapid acquisition
Ncs = 5; % assumed trials to acquisition
C = 10000; % raw US-US interval
T = 100; % Trial duration = US-US interval in presence of CS
Tcs = Ncs*T; % cumulative CS time at acquisition
Tb = Ncs*C; % cumulative background (i.e., session) time at acquisition
Nb = Ncs; % no USs during ITIs

GsmallTC = InfoGains2(Tb,Tcs,Nb,Ncs,alpha); % 4 different ways of computing
% the info gained

%%
% T/C = 1/2 very large duty cycle produces very slow acquisition (50-fold
% change
Ncs = 250; % assumed trials to acquisition (50-fold increase)
C = 200; % raw US-US interval
T = 100; % Trial duration = US-US interval in presence of CS
Tcs = Ncs*T; % cumulative CS time at acquisition
Tb = Ncs*C; % cumulative background (i.e., session) time at acquisition
Nb = Ncs; % no USs during ITIs

GlargeTC = InfoGains2(Tb,Tcs,Nb,Ncs,alpha); % 4 different ways of computing
% the info gained

%{
[GsmallTC;GlargeTC] =
        Method 1     Method 2       Method 3     Method 4
        500.00         23.03         23.63         19.05
        500.00        173.29        170.37       1147.68
Only Method 1 (the hack) captures the excitatory duty-cycle data
%}


% Code below is what I used a few days ago (early June)
% Niti = 0;
% alpha = .5;
% lamCS = (Ncs+alpha)/(Ncs*T); % cumulative # of USs during CSs divided by
% % cumulative time on the CS clock
% lamRaw = (Ncs+alpha)/(Ncs*C); % cumulative # of USs divided by cumulative
% % session time
% lamITI = alpha/(Ncs*(C-T));
% DklCSrw = log(lamCS/lamRaw)+lamRaw/lamCS-1;
% DklITIrw = log(lamITI/lamRaw)+lamRaw/lamITI-1;
% H = (Ncs+alpha)*DklCSrw + (Niti+alpha)*DklITIrw;
% A(2,:)=[Ncs C T lamCS lamRaw lamITI DklCSrw DklITIrw H]
% %%
% LambRatio = logspace(-2,2);
% Dkl = log(LambRatio)'+fliplr(LambRatio)' - 1;
% approx = fliplr(LambRatio)' - 1; 
% CA{2} = [LambRatio' Dkl approx approx-Dkl];
% %%    
% str = char({'For rate ratios, lam0/lam1,';...
%     'from .01 to 100,';...
%     'in 50 equal logarithmic steps,';...
%     'the columns of Cell 2 of this cell array are:';...
%     'Col 1 = lam0/lam1';
%     'Col 2 =  Dkl(lam0||lam1) =log(lam0/lam1)+lam1/lam0-1';...
%     'Col 3 = the scalar approximation, lam1/lam0';...
%     'Col 4 = the error in the approximation'});
% CA{1} = str;
% 
% save('/Users/galliste/Dropbox/inhibitoryexperiments_all/LinearApproxToDkl','CA')