% script mfile AcrossExperStats.m Code for compiling statistics across
% the 6 inhibitory acquisition experiment
load /Users/galliste/Dropbox/InhibitoryExperiments_All/ExperimentStructures/All6structures
global Experiment

%% CS durs, ITI durs & US-US
E1_CSdurs = [10;20;40;80];
E1_ITIdurs = [20;20;20;20];
E1_USUS = [20;20;20;20];

E2_CSdurs = [10;40;10]; % only 3 because in 10_30 group, no S acquired
E2_ITIdurs = [20;20;20];
E2_USUS = [20;20;20];

E3_CSdurs = [30;50;30;50];
E3_ITIdurs = [20;20;20;20];
E3_USUS = [20;20;20;20];

E4_CSdurs = [20;40;20;40;80];
E4_ITIdurs = [20;20;20;20;20];
E4_USUS = [20;20;40;40;40];

E5_CSdurs = [30;60;30;60];
E5_ITIdurs = [20;20;80;80];
E5_USUS = [20;20;20;20];

E6_CSdurs = [80;80;160;80];
E6_ITIdurs = [80;20;20;10];
E6_USUS = [20;20;20;20];

%% Subjects' Trials to Acquisition by Group
E1_TtA_G10 = E1.Grp10sAcqPts; %8x1 array
E1_TtA_G20 = E1.Grp20sAcqPts; %8x1 array
E1_TtA_G40 = E1.Grp40sAcqPts; %8x1 array
E1_TtA_G80 = E1.Grp80sAcqPts; %8x1 array

E2_TtA_Grps10 = [E2.GrpCS10_AcqPts;E2.GrpCS10X4_AcqPts]; %16x1 array
E2_TtA_G40 = E2.GrpCS40_AcqPts; %8x1 array

E3_TtA_G30f = E3.Grp30fixAcqPts; %8x1 array
E3_TtA_G30v = E3.Grp30varAcqPts; %8x1 array
E3_TtA_G50f = E3.Grp50fixAcqPts; %8x1 array
E3_TtA_G50v = E3.Grp50varAcqPts; %8x1 array

E4_TtA_G2020 = E4.GrpUS20_CS20AcqPts; %8x1 array
E4_TtA_G2040 = E4.GrpUS20_CS40AcqPts; %8x1 array
E4_TtA_G4020 = E4.GrpUS40_CS20AcqPts; %7x1 array
E4_TtA_G4040 = E4.GrpUS40_CS40AcqPts; %8x1 array
E4_TtA_G4080 = E4.GrpUS40_CS80AcqPts; %8x1 array

E5_TtA_G10 = E5.GrpITI20_CS30_AcqPts; %8x1 array
E5_TtA_G20 = E5.GrpITI20_CS60_AcqPts; %8x1 array
E5_TtA_G40 = E5.GrpITI80_CS30_AcqPts; %8x1 array
E5_TtA_G80 = E5.GrpITI80_CS60_AcqPts; %8x1 array

E6_TtA_G8_80_80 = E6.Grp8_CS80_ITI80SimpleAcqPts; %8x1 array
E6_TtA_32_80_20 = E6.Grp32_CS80_ITI20SimpleAcqPts; %8x1 array
E6_TtA_32_160_20 = E6.Grp32_CS160_ITI20SimpleAcqPts; %8x1 array
E6_TtA_64_80_10 = E6.Grp64_CS80_ITI10SimpleAcqPts; %8x1 array


%% Median Trials To Acquisition
E1_MdnTrlsToAcq = E1.MedianTrlsToAcq(1:4,2); % 4x1 array
E2_MdnTrlsToAcq = E2.MedianTrlsToAcq([1 2 4],2); % 4x1 array
E3_MdnTrlsToAcq = E3.MedianTrlsToAcq(:,2); % 4x1 array
E4_MdnTrlsToAcq = E4.MedianTrlsToAcq(:,2); % 5x1 array
E5_MdnTrlsToAcq = E5.MedianTrlsToAcq(:,2); % 4x1 array
E6_MdnTrlsToAcq = E6.MedianTrlsToAcq(:,2); % 4x1 array

%% Post Acq CS-ITI Difference
E1_G10_CSUSPstAcqRateDiff = E1.Grp10sMnPostAcqRateDiff; % 8x1 array
E1_G20_CSUSPstAcqRateDiff = E1.Grp20sMnPostAcqRateDiff; % 8x1 array
E1_G40_CSUSPstAcqRateDiff = E1.Grp40sMnPostAcqRateDiff; % 8x1 array
E1_G80_CSUSPstAcqRateDiff = E1.Grp80sMnPostAcqRateDiff; % 8x1 array

E2_Grps10_CSUSPstAcqRateDiff = [E2.GrpCS10MnPostAcqRateDiff;...
    E2.GrpCS10X4MnPostAcqRateDiff]; % 16x1 array
E2_G40_CSUSPstAcqRateDiff = E2.GrpCS40MnPostAcqRateDiff; % 8x1 array

E3_G30fPkRateDiffs = E3.Grp30fixMnPostAcqRateDiff; % 8x1 array
E3_G30vPkRateDiffs = E3.Grp30varMnPostAcqRateDiff; % 8x1 array
E3_G50fPkRateDiffs = E3.Grp50fix30MnPostAcqRateDiff; % 8x1 array
E3_G50vPkRateDiffs = E3.Grp50varMnPostAcqRateDiff; % 8x1 array

E4_G2020PkRateDiffs = E4.GrpUS20_CS20MnPostAcqRateDiffs; % 8x1 array
E4_G2040PkRateDiffs = E4.GrpUS20_CS40MnPostAcqRateDiffs; % 8x1 array
E4_G4020PkRateDiffs = E4.GrpUS40_CS20MnPostAcqRateDiffs; % 7x1 array
E4_G4040PkRateDiffs = E4.GrpUS40_CS40MnPostAcqRateDiffs; % 8x1 array
E4_G4080PkRateDiffs = E4.GrpUS40_CS80MnPostAcqRateDiffs; % 8x1 array 

E5_G2030CSUSPstAcqRateDiff = E5.GrpITI20_CS30PstAcqRateDiffs; % 12x1 array
E5_G2060CSUSPstAcqRateDiff = E5.GrpITI20_CS60PstAcqRateDiffs; % 12x1 array
E5_G8030CSUSPstAcqRateDiff = E5.GrpITI80_CS30PstAcqRateDiffs; % 12x1 array
E5_G8060CSUSPstAcqRateDiff = E5.GrpITI80_CS60PstAcqRateDiffs; % 12x1 array

E6_8_80_80CSUSPstAcqRateDiff = E6.Grp8_CS80_ITI80PstAcqRateDiffs; % 8x1 array
E6_32_80_20CSUSPstAcqRateDiff = E6.Grp32_CS80_ITI20PstAcqRateDiffs; % 8x1 array
E6_32_160_20CSUSPstAcqRateDiff = E6.Grp32_CS160_ITI20PstAcqRateDiffs; % 8x1 array
E6_64_80_10CSUSPstAcqRateDiff = E6.Grp64_CS80_ITI10PstAcqRateDiffs; % 12x1 array

%% Post Acquisition Within-CS Poke Rate Profile
E1_G10PkRatePrfls = E1.Grp10sPstAcqProfile; % 4x10 array
E1_G20PkRatePrfls = E1.Grp20sPstAcqProfile; % 7x10
E1_G40PkRatePrfls = E1.Grp40sPstAcqProfile; % 8x10
E1_G80PkRatePrfls = E1.Grp80sPstAcqProfile; % 8x10

E2_Grps10PkRatePrfls = E2.GrpsCS10PstAcqProfile; % 9x10 array
E2_G40PkRatePrfls = E2.Grp40PstAcqProfile; % 8x10

E3_G30fPkRatePrfls = E3.G30fixPstAcqPksPrSecByDecile; % 60x2 array
E3_G30vPkRatePrfls = E3.G30varPstAcqPksPrSecByDecile; % 80x2
E3_G50fPkRatePrfls = E3.G50fixPstAcqPksPrSecByDecile; % 80x2
E3_G50vPkRatePrfls = E3.G50varPstAcqPksPrSecByDecile; % 80x2

E4_G2020PkRatePrfls = E4.G2020PstAcqPksPrSecByDecile; % 88x2 array (includes 11th bins w all 0s)
E4_G2040PkRatePrfls = E4.G2040PstAcqPksPrSecByDecile; % 88x2
E4_G4020PkRatePrfls = E4.G4020PstAcqPksPrSecByDecile; % 77x2
E4_G4040PkRatePrfls = E4.G4040PstAcqPksPrSecByDecile; % 88x2
E4_G4080PkRatePrfls = E4.G4080PstAcqPksPrSecByDecile; % 88x2

E5_G2030PkRatePrfls = E5.G2030PstAcqPksPrSecByDecile; % 132x2 array
E5_G2060PkRatePrfls = E5.G2060PstAcqPksPrSecByDecile; % 132x2 array
E5_G8030PkRatePrfls = E5.G8030PstAcqPksPrSecByDecile; % 121x2 array
E5_G8060PkRatePrfls = E5.G8060PstAcqPksPrSecByDecile; % 132x2 array

E6_8_80_80PkRatePrfls = E6.G8_80_80PstAcqPksPrSecByDecile; % 77x2 array (includes 11th bins w all 0s)
E6_32_80_20PkRatePrfls = E6.G32_80_20PstAcqPksPrSecByDecile; % 88x2
E6_32_160_20PkRatePrfls = E6.G32_160_20PstAcqPksPrSecByDecile; % 88x2
E6_64_80_10PkRatePrfls = E6.G64_80_10PstAcqPksPrSecByDecile; % 88x2

%% Informativeness
E1_G10_Inform = E1.Grp10sInformativeness; % 8x1 array
E1_G20_Inform = E1.Grp10sInformativeness; % 8x1 array
E1_G40_Inform = E1.Grp10sInformativeness; % 8x1 array
E1_G80_Inform = E1.Grp10sInformativeness; % 8x1 array

E2_G10_Inform = [E2.GrpCS10Informativeness;E2.GrpCS10X4Informativeness]; % 16x1 array
E2_G10_30_Inform = E2.GrpCS10_30Informativeness;% 8x1 array
E2_G40_Inform = E2.GrpCS40Informativeness; % 8x1 array

E3_G30fInform = E3.Grp30fixInformativeness; % 8x1 array
E3_G30vInform = E3.Grp30varInformativeness; % 8x1 array
E3_G50fInform = E3.Grp50fixInformativeness; % 8x1 array
E3_G50vInform = E3.Grp50varInformativeness; % 8x1 array

E4_2020Inform = E4.US20_CS20Informativeness; % 8x1 array
E4_2040Inform = E4.US20_CS40Informativeness; % 8x1 array
E4_4020Inform = E4.US40_CS20Informativeness; % 7x1 array
E4_4040Inform = E4.US40_CS40Informativeness; % 8x1 array
E4_4080Inform = E4.US40_CS80Informativeness; % 8x1 array

E5_G2030Inform = E5.GrpITI20_CS30Informativeness; % 12x1 array
E5_G2060Inform = E5.GrpITI20_CS60Informativeness; % 12x1 array
E5_G8030Inform = E5.GrpITI80_CS30Informativeness; % 12x1 array
E5_G8060Inform = E5.GrpITI80_CS60Informativeness; % 12x1 array

E6_8_80_80Inform = E6.Grp8_CS80_ITI80Informativeness; % 8x1 array
E6_32_80_20Inform = E6.Grp32_CS80_ITI20Informativeness; % 8x1 array
E6_32_160_20Inform = E6.Grp32_CS160_ITI20Informativeness; % 8x1 array
E6_64_80_10Inform = E6.Grp64_CS80_ITI10Informativeness; % 8x1 array

%% Subjects' USs at Acquisition by Group 
E1_USsAtAcq_G10 = E1.Grp10sUSsAtAcq; % 4x1 array
E1_USsAtAcq_G20 = E1.Grp20sUSsAtAcq; % 7x1 array
E1_USsAtAcq_G40 = E1.Grp40sUSsAtAcq; % 8x1 array
E1_USsAtAcq_G80 = E1.Grp80sUSsAtAcq; % 8x1 array

E2_USsAtAcq_G10 = E2.Grps10USsAtAcq; %11x1 array
E2_USsAtAcq_G40 = E2.GrpCS40USsAtAcq; %8x1 array

E3_USsAtAcq_G30f = E3.Grp30fUSsAtAcq; % 6x1 array
E3_USsAtAcq_G30v = E3.Grp30vUSsAtAcq; % 8x1 array
E3_USsAtAcq_G50f = E3.Grp50fUSsAtAcq; % 8x1 array
E3_USsAtAcq_G50v = E3.Grp50vUSsAtAcq; % 8x1 array

E4_USsAtAcq_G2020 = E4.G2020USsAtAcq; % 6x1 array
E4_USsAtAcq_G2040 = E4.G2040USsAtAcq; % 8x1 array
E4_USsAtAcq_G4020 = E4.G4020USsAtAcq; % 7x1 array
E4_USsAtAcq_G4040 = E4.G4040USsAtAcq; % 8x1 array
E4_USsAtAcq_G4080 = E4.G4080USsAtAcq; % 8x1 array

E5_USsAtAcq_G2030 = E5.G2030USsAtAcq; % 4x1 array
E5_USsAtAcq_G2060 = E5.G2060USsAtAcq; % 7x1 array
E5_USsAtAcq_G8030 = E5.G8030USsAtAcq; % 8x1 array
E5_USsAtAcq_G8060 = E5.G8060USsAtAcq; % 8x1 array

E6_USsAtAcq_G8_80_80 = E6.G8_80_80USsAtAcq; % 7x1 array
E6_USsAtAcq_G32_80_20 = E6.G32_80_20USsAtAcq; % 8x1 array
E6_USsAtAcq_G32_160_20 = E6.G32_160_20USsAtAcq; % 8x1 array
E6_USsAtAcq_G64_80_10 = E6.G64_80_10USsAtAcq; % 8x1 array

%% Across Experiment Arrays
ExpGrps = [[ones(4,1) (1:4)'];[2*ones(4,1) (1:4)'];[3*ones(4,1) (1:4)'];...
    [4*ones(5,1) (1:5)'];[5*ones(4,1) (1:4)'];[6*ones(4,1) (1:4)']]; % 25x1 groups

GrpNms ={'Grp10s';'Grp20s';'Grp40s';'Grp80s';'GrpCS10';'GrpCS40';'GrpCS10_30';...
    'GrpCS10X4';'Grp30fix';'Grp30var';'Grp50fix';'Grp50var';'GrpUS20_CS20';...
    'GrpUS20_CS40';'GrpUS40_CS20';'GrpUS40_CS40';'GrpUS40_CS80';'GrpITI20_CS30';...
    'GrpITI20_CS60';'GrpITI80_CS30';'GrpITI80_CS60';'Grp8_CS80_ITI80';...
    'Grp32_CS80_ITI20';'Grp32_CS160_ITI20';'Grp64_CS80_ITI10'} % 25x1 names


MdnTrlsToAcq =[E1_MdnTrlsToAcq;E2_MdnTrlsToAcq;E3_MdnTrlsToAcq;...
     E4_MdnTrlsToAcq;E5_MdnTrlsToAcq;E6_MdnTrlsToAcq]; % 24x1   
 
% 3-Col Array w E in 1st col, Grp # (1:25) in 2nd col and subject index #s in 3rd col
Subs = double.empty(0,3);
g = 1;
nG = [4 4 4 5 4 4];
for E = 1:6
    for eg = 1:nG(E) % stepping through the groups in an experiment
        IndxNs =eval(['E' num2str(E) '.' GrpNms{g} '''']); % index #s of subjects in the g group
        nr = length(IndxNs);
        Subs(end+1:end+nr,:) = [repmat(E,nr,1) g*(ones(nr,1)) IndxNs];
        g=g+1;
    end
end

%% Informativeness & Median Trials to Acquisition by Group

% InformAndMdnTrlsToAcq = double.empty(0,2);
% for g = 1:25 % stepping through the groups
%     I = eval(['E' num2str(ExpGrps(g,1) '.' GrpNms{g}
%     InformAndMdnTrlsToAcq(g,:) = [
%         end

InformAndMdnTrlsToAc = [1 1 E1.Grp10sInformativeness(1);...
    1 2 E1.Grp20sInformativeness(1);...
    1 3 E1.Grp40sInformativeness(1);...
    1 4 E1.Grp80sInformativeness(1);...
    2 5 E2.GrpCS10Informativeness(1);...
    2 6 E2.GrpCS40Informativeness(1);...
    2 7 E2.GrpCS10_30Informativeness(1);...
    2 8 E2.GrpCS10X4Informativeness(1);...
    3 9 E3.Grp30fixInformativeness(1);...
    3 10 E3.Grp30varInformativeness(1);...
    3 11 E3.Grp50fixInformativeness(1);...
    3 12 E3.Grp50varInformativeness(1);...
    4 13 E4.US20_CS20Informativeness(1);...
    4 14 E4.US20_CS40Informativeness(1);...
    4 15 E4.US40_CS20Informativeness(1);...
    4 16 E4.US40_CS40Informativeness(1);...
    4 17 E4.US40_CS80Informativeness(1);...
    5 18 E5.GrpITI20_CS30Informativeness(1);...
    5 19 E5.GrpITI20_CS60Informativeness(1);...
    5 20 E5.GrpITI80_CS30Informativeness(1);...
    5 21 E5.GrpITI80_CS60Informativeness(1);...
    6 22 E6.Grp8_CS80_ITI80Informativeness(1);...
    6 23 E6.Grp32_CS80_ITI20Informativeness(1);...
    6 24 E6.Grp32_CS160_ITI20Informativeness(1);...
    6 25 E6.Grp64_CS80_ITI10Informativeness(1)];

%% Inserting out of range median trial to acq
MdnTrlsToAcq = [MdnTrlsToAcq(1:6);5000;MdnTrlsToAcq(7:end)]

InformAndMdnTrlsToAc = [InformAndMdnTrlsToAc MdnTrlsToAcq];
%%
LV = InformAndMdnTrlsToAc(:,4)<5000;
loglog(InformAndMdnTrlsToAc(LV,3),InformAndMdnTrlsToAc(LV,4),'k*')
xlabel('CSoff Informativeness=\lambda_I_T_I/\lambda_C (log scale)')
ylabel('Trials to Acquisition (log scale)')
hold on
loglog([1.25 5],[400 100],'k--')
title('Gibbon & Balsam Ride Again','FontWeight','normal')

%% Pst Acq CS-ITI diff vs Informativeness
CSITIdiffVsInf = ...
[E1.Grp10sInformativeness E1.Grp10sMnPostAcqRateDiff;...
E1.Grp20sInformativeness E1.Grp20sMnPostAcqRateDiff;...
E1.Grp40sInformativeness E1.Grp40sMnPostAcqRateDiff;...
E1.Grp80sInformativeness E1.Grp80sMnPostAcqRateDiff;...
[E2.GrpCS10Informativeness;E2.GrpCS10X4Informativeness] [E2.GrpCS10MnPostAcqRateDiff;E2.GrpCS10X4MnPostAcqRateDiff];...
E2.GrpCS40Informativeness E2.GrpCS40MnPostAcqRateDiff;...
E3.Grp30fixInformativeness E3.Grp30fixMnPostAcqRateDiff;...
E3.Grp30varInformativeness E3.Grp30varMnPostAcqRateDiff;...
E3.Grp50fixInformativeness E3.Grp50fix30MnPostAcqRateDiff;...
E3.Grp50varInformativeness E3.Grp50varMnPostAcqRateDiff;...
E4.US20_CS20Informativeness E4.GrpUS20_CS20MnPostAcqRateDiffs;...
E4.US20_CS40Informativeness E4.GrpUS20_CS40MnPostAcqRateDiffs;...
E4.US40_CS20Informativeness E4.GrpUS40_CS20MnPostAcqRateDiffs;...
E4.US40_CS40Informativeness E4.GrpUS40_CS40MnPostAcqRateDiffs;...
E4.US40_CS80Informativeness E4.GrpUS40_CS80MnPostAcqRateDiffs;...
E5.GrpITI20_CS30Informativeness E5.GrpITI20_CS30PstAcqRateDiffs;...
E5.GrpITI20_CS60Informativeness E5.GrpITI20_CS60PstAcqRateDiffs;...
E5.GrpITI80_CS30Informativeness E5.GrpITI80_CS30PstAcqRateDiffs;...
E5.GrpITI80_CS60Informativeness E5.GrpITI80_CS60PstAcqRateDiffs;...
E6.Grp8_CS80_ITI80Informativeness E6.Grp8_CS80_ITI80PstAcqRateDiffs;...
E6.Grp32_CS80_ITI20Informativeness E6.Grp32_CS80_ITI20PstAcqRateDiffs;...
E6.Grp32_CS160_ITI20Informativeness E6.Grp32_CS160_ITI20PstAcqRateDiffs;...
E6.Grp64_CS80_ITI10Informativeness E6.Grp64_CS80_ITI10PstAcqRateDiffs]
%%
figure;loglog(CSITIdiffVsInf(:,1),CSITIdiffVsInf(:,2),'k*')
xlabel('CSoff Informativeness=\lambda_I_T_I/\lambda_C (log scale)')
ylabel('CS-ITI Pokes/s (log scale)')
xlim([1 10])
%% loglog data
CSITIdiffVsInfLgLg = log10(CSITIdiffVsInf);
figure
plot(CSITIdiffVsInfLgLg(:,1),CSITIdiffVsInfLgLg(:,2),'k*')
set(gca,'YTick',[-2 -1.7 -1.3 -1 -.7 -.3 0],'YTickLabel',...
    {'.01' '.02' '.05' '.1' '.2' '.5' '1'},'XTick',[.1 .3 .7 1],'XTickLabel',...
    {'1.3' '2' '5' '10'})
xlabel('CSoff Informativeness=\lambda_I_T_I/\lambda_C (log scale)')
ylabel('ITI-CS Pokes/s (log scale)')
%%
Ivals = unique(CSITIdiffVsInf(:,1));
StdDiff = nan(size(Ivals));
r = 1;
for v = Ivals'
    LV = CSITIdiffVsInf(:,1)==v;
    StdDiff(r) = nanstd(log10(CSITIdiffVsInf(LV,2)));
    r = r+1;
end
MnStd = mean(StdDiff(StdDiff>0)); % standard deviation of the logarithms
CoV = 10^MnStd; % CoV of the ITI-CS rate diff (multiplicative factor by
% that gives deviation out a given predicted mean

%% Fitting Weibull function to the data on the median post-acquisition
% ITI-CS poke rate difference
beta0 = [0.35 4.00 1.20]
modelfun=@(b,x)b(1)*(1-2.^-((x/b(2)).^b(3)));
mdl=fitnlm(Ivals,MdnDiff,modelfun,beta0)
%{
Nonlinear regression model:
    y ~ F(b,x)

Estimated Coefficients:
          Estimate     SE     tStat    pValue
          ________    ____    _____    ______=

    b1    0.32        0.03    9.81     0.00  
    b2    3.45        0.45    7.59     0.00  
    b3    1.54        0.32    4.78     0.00  


Number of observations: 26, Error degrees of freedom: 23
Root Mean Squared Error: 0.0376
R-Squared: 0.863,  Adjusted R-Squared 0.851
F-statistic vs. zero model: 227, p-value = 3.19e-17
%}

%%
figure;plot(Ivals,MdnDiff,'k*')
hold on;plot(1:12,wblfun(1:12,.32,3.45,1.54),'k-')
ylim([0 .37])
xlabel('CSoff Informativeness=\lambda_I_T_I/\lambda_C','FontSize',18)
ylabel('ITI-CS Poke/s','FontSize',18)
% text(.5,.37,'Pk/s diff = .35*(1-2^{-(I/3.45)^{1.54}})','FontSize',18)
lgh=legend('Median Poke Rate Difference','Pk/s diff = .35*(1-2^{-(I/3.45)^{1.54}})','location','S');
set(lgh,'FontSize',18); set(gca,'FontSize',18)

%%
Sbs1 = [E1.Grp10s E1.Grp20s E1.Grp40s E1.Grp80s ];
A1 = nan(length(Sbs1),3);
r=1;
for S = Sbs1
    if ~isempty(E1.Subject(S).USsAtAcquisition)
        A1(r,:) = [E1.Subject(S).CSoffInformativeness E1.Subject(S).AcqPt E1.Subject(S).USsAtAcquisition];
    else
        A1(r,:) = [E1.Subject(S).CSoffInformativeness E1.Subject(S).AcqPt nan];
    end
    r=r+1;
end

%%
Sbs2 = [E2.GrpCS10 E2.GrpCS10X4 E2.GrpCS40];
A2 = nan(length(Sbs2),3);
r=1;
for S = Sbs2
    if ~isempty(E2.Subject(S).USsAtAcquisition)
        A2(r,:) = [E2.Subject(S).CSoffInformativeness E2.Subject(S).AcqPt E2.Subject(S).USsAtAcquisition];
    else
        A2(r,:) = [E2.Subject(S).CSoffInformativeness E2.Subject(S).AcqPt nan];
    end
    r=r+1;
end
%%
Sbs3 = [E3.Grp30fix E3.Grp30var E3.Grp50fix E3.Grp50var];
A3 = nan(length(Sbs3),3);
r=1;
for S = Sbs3
    if ~isempty(E3.Subject(S).USsAtAcquisition)
        A3(r,:) = [E3.Subject(S).CSoffInformativeness E3.Subject(S).AcqPt E3.Subject(S).USsAtAcquisition];
    else
        A3(r,:) = [E3.Subject(S).CSoffInformativeness E3.Subject(S).AcqPt nan];
    end
    r=r+1;
end

%%
Sbs4 = [E4.GrpUS20_CS20 E4.GrpUS20_CS40 E4.GrpUS40_CS20 E4.GrpUS40_CS40 E4.GrpUS40_CS80];
A4 = nan(length(Sbs4),3);
r=1;
for S = Sbs4
    if ~isempty(E4.Subject(S).USsAtAcquisition)
        A4(r,:) = [E4.Subject(S).CSoffInformativeness E4.Subject(S).AcqPt E4.Subject(S).USsAtAcquisition];
    else
        A4(r,:) = [E4.Subject(S).CSoffInformativeness E4.Subject(S).AcqPt nan];
    end
    r=r+1;
end

%%
Sbs5 = [E5.GrpITI20_CS30 E5.GrpITI20_CS60 E5.GrpITI80_CS30 E5.GrpITI80_CS60];
A5 = nan(length(Sbs5),3);
r=1;
for S = Sbs5
    if ~isempty(E5.Subject(S).USsAtAcquisition)
        A5(r,:) = [E5.Subject(S).CSoffInformativeness E5.Subject(S).AcqPt E5.Subject(S).USsAtAcquisition];
    else
        A5(r,:) = [E5.Subject(S).CSoffInformativeness E5.Subject(S).AcqPt nan];
    end
    r=r+1;
end

%%
Sbs6 = [E6.Grp8_CS80_ITI80 E6.Grp32_CS80_ITI20 E6.Grp32_CS160_ITI20 E6.Grp64_CS80_ITI10];
A6 = nan(length(Sbs6),3);
r=1;
for S = Sbs6
    if ~isempty(E6.Subject(S).USsAtAcquisition)
        A6(r,:) = [E6.Subject(S).CSoffInformativeness E6.Subject(S).SimpleAcqPt E6.Subject(S).USsAtAcquisition];
    else
        A6(r,:) = [E6.Subject(S).CSoffInformativeness E6.Subject(S).SimpleAcqPt nan];
    end
    r=r+1;
end

%% 
tblA = [A1;A2;A3;A4;A5;A6];
C1 = tblA(:,1); % informativeness
C2 = tblA(:,3); % USs to acquisition
C3 = tblA(:,2); % trials to acquisition
DatTbl = table(C1,C2,C3,'VariableNames',{'Informativeness' 'USsToAcq' 'TrlsToAcq'})


%%
A1=[E1.Grp10sUSsPerITI;E1.Grp20sUSsPerITI;E1.Grp40sUSsPerITI;E1.Grp80sUSsPerITI];
A2=[E2.GrpCS10USsPerITI;E2.GrpCS10X4USsPerITI;E2.GrpCS40USsPerITI];
A3=[E3.Grp30fixUSsPerITI;E3.Grp30varUSsPerITI;E3.Grp50fixUSsPerITI;E3.Grp50varUSsPerITI];
A4=[E4.GrpUS20_CS20USsPerITI;E4.GrpUS20_CS40USsPerITI;E4.GrpUS40_CS20USsPerITI;...
    E4.GrpUS40_CS40USsPerITI;E4.GrpUS40_CS80USsPerITI];
A5=[E5.GrpITI20_CS30USsPerITI;E5.GrpITI20_CS60USsPerITI;E5.GrpITI80_CS30USsPerITI;...
    E5.GrpITI80_CS60USsPerITI];
A6=[E6.Grp8_CS80_ITI80USsPerITI;E6.Grp32_CS80_ITI20USsPerITI;...
    E6.Grp32_CS160_ITI20USsPerITI;E6.Grp64_CS80_ITI10USsPerITI];

Aus = [A1;A2;A3;A4;A5;A6];
Dtbl2=table(Aus,'VariableNames',{'USsPerITI'})

%% Building the "Master" array
MA = double.empty(0,24);
CA =cell(0);
for e = 1:6 % building
    A = eval(['E' num2str(e) '.TableArray']);
    L = length(A);
    MA(end+1:end+L,:) = A;
    CA(end+1:end+L,1) = eval(['E' num2str(e) '.GrpCharArray']);
end
%%
% Creating DataTable from master array and cell array
DataTable = [cell2table(CA) array2table(MA)]; % creating table
DataTable = DataTable(:,[2 3 1 4:25]);
DataTable.Properties.VariableNames ={'E' 'G' 'Gnam' 'Sidx' ...
    'CSdr' 'ForV' 'ITIdr' 'USUSint' 'USsAtCSoff' 'Infrmtvns' 'NxInf' 'TrlToAcq' 'CSITIdif' ...
    'CSPstPreDif' 'ITIPstPreDif' 'd1' 'd2' 'd3' 'd4' 'd5' 'd6' 'd7' 'd8' 'd9' 'd10'};
save DataTable DataTable

% Sorting DataTable by Experiment # and the Group #
DataTable = sortrows(DataTable,[1 2])
save DataTable DataTable

%% Effect of Other Variables on Profile
load /Users/galliste/Dropbox/InhibitoryExperiments_All/SummaryStats/SubBySubDataTable
T=DataTable;
PltTbl40 = T(T.CSdr==40,[1 2 5:11 16:25]);
PltTbl80 = T(T.CSdr==80,[1 2 5:11 16:25]);
%
figure
subplot(2,1,1)
    plot(1:10,mean(PltTbl40{PltTbl40{:,6}<30,10:19}))
    hold on
    plot(1:10,mean(PltTbl40{PltTbl40{:,6}>30,10:19}),'k--')
    xlim([.5 10.5])
    set(gca,'XTick',[1 5 10],'XTickLabel',{'1' '20' '40'})
    xlabel('Elapsed time in CS (s)')
    ylabel('Pokes/s Post Acquisition')
    legend('{\it N}_{US|CS}*\lambda_{ITI}/\lambda_C = 3',...
        '{\it N}_{US|CS}*\lambda_{ITI}/\lambda_C = 1.5','location','N')
    text(3,.25,'{\it ITI}=20, {\it US-US}=20, {\it N}_{US|CSoff}=1')
    text(4.5,.22,'\lambda_{ITI}/\lambda_C=3')
    text(3,.135,'{\it ITI}=20, {\it US-US}=20, {\it N}_{US|CSoff}=.5')
    text(4,.075,'\lambda_{ITI}/\lambda_C=3')

subplot(2,1,2)
    plot(1:10,mean(PltTbl80{PltTbl80{:,6}<30,10:19}))
    hold on
    plot(1:10,mean(PltTbl80{PltTbl80{:,6}>30,10:19}),'k--')
    xlim([.5 10.5])
    set(gca,'XTick',[1 5 10],'XTickLabel',{'1' '40' '80'})
    xlabel('Elapsed time in CS (s)')
    ylabel('Pokes/s Post Acquisition')
    legend('{\it N}_{US|CS}*\lambda_{ITI}/\lambda_C = 5',...
        '{\it N}_{US|CS}*\lambda_{ITI}/\lambda_C = 2.5','location','N')
    text(1.5,.24,'{\it ITI}=20, {\it US-US}=20, {\it N}_{US|CSoff}=1')
    text(3,.21,'\lambda_{ITI}/\lambda_C=5')
    text(2,.09,'{\it ITI}=20, {\it US-US}=20, {\it N}_{US|CSoff}=.5')
    text(7,.13,'\lambda_{ITI}/\lambda_C=5')
    
   
%% Group Medians Table
A = nan(26,11);
GrpMdnsTbl = array2table(A,'VariableNames',{'CSdr' 'ForV' ...
    'ITIdr' 'USUSint' 'USsAtCSoff' 'Infrmtvns' 'NxInf' 'TrlToAcq' 'CSITIdif' ...
    'CSPstPreDif' 'ITIPstPreDif'});
[GrpName,IA,IC] = unique(T(:,'Gnam'));
GrpName = [array2table(IA) GrpName]; % adding a column that will enable me
% to sort the table so that the groups are in the same order as in T
GrpName = sortrows(GrpName,'IA');
GrpName = GrpName(:,2);

GrpMdnsTbl = [GrpName GrpMdnsTbl];

for r = 1:height(GrpName) % stepping through the groups in T
       GrpMdnsTbl{r,2:12} = nanmedian(T{strcmp(T.Gnam,GrpName{r,1}),5:15});
end

%% Group Means Table
A = nan(26,11);
GrpMnsTbl = array2table(A,'VariableNames',{'CSdr' 'ForV' ...
    'ITIdr' 'USUSint' 'USsAtCSoff' 'Infrmtvns' 'NxInf' 'TrlToAcq' 'CSITIdif' ...
    'CSPstPreDif' 'ITIPstPreDif'});
GrpMnsTbl = [GrpName GrpMnsTbl];

for r = 1:height(GrpName) % stepping through the groups in T
       GrpMnsTbl{r,2:12} = nanmean(T{strcmp(T.Gnam,GrpName{r,1}),5:15});
end

%% Group Std Table
A = nan(26,11);
GrpStdTbl = array2table(A,'VariableNames',{'CSdr' 'ForV' ...
    'ITIdr' 'USUSint' 'USsAtCSoff' 'Infrmtvns' 'NxInf' 'TrlToAcq' 'CSITIdif' ...
    'CSPstPreDif' 'ITIPstPreDif'});
GrpStdTbl = [GrpName GrpStdTbl];

for r = 1:height(GrpName) % stepping through the groups in T
       GrpStdTbl{r,2:12} = nanstd(T{strcmp(T.Gnam,GrpName{r,1}),5:15});
end

%% Group Post-Acquisition CS Deciles Tables
A = nan(26,10);
GrpPstAcqCSDecileMnsTbl = array2table(A,'VariableNames',{'d1' 'd2' ...
    'd3' 'd4' 'd5' 'd6' 'd7' 'd8' 'd9' 'd10'});
GrpPstAcqCSDecileMnsTbl = [GrpName GrpPstAcqCSDecileMnsTbl];

for r = 1:height(GrpName) % stepping through the groups in T
       GrpPstAcqCSDecileMnsTbl{r,2:11} = nanmean(T{strcmp(T.Gnam,GrpName{r,1}),end-9:end});
end
%%
A = nan(26,10);
GrpPstAcqCSDecileStdErTbl = array2table(A,'VariableNames',{'d1' 'd2' ...
    'd3' 'd4' 'd5' 'd6' 'd7' 'd8' 'd9' 'd10'});
GrpMdnsTbl = [GrpName GrpPstAcqCSDecileStdErTbl];

for r = 1:height(GrpName) % stepping through the groups in T
       GrpPstAcqCSDecileStdErTbl{r,2:11} = stder(T{strcmp(T.Gnam,GrpName{r,1}),end-9:end});
end

%% Amalgamating groups with same protocols parameters 

VN = {'CSdr' 'ForV' 'ITIdr' 'USUSint' 'USsAtCSoff' 'Infrmtvns' 'NxInf' 'TrlToAcq' 'CSITIdif' ...
    'CSPstPreDif' 'ITIPstPreDif' 'd1' 'd2' 'd3' 'd4' 'd5' 'd6' 'd7' 'd8' 'd9' 'd10'};

ParamAcqTbl = array2table(nan(17,21),'VariableNames',VN);

ParamAcqTbl{1,:} = [CS10F20ITI20USUStbl{1,4:10} median(CS10F20ITI20USUStbl{:,11}) ...
    nanmean(CS10F20ITI20USUStbl{:,12:end})];
LV10f22020 = (MA(:,4)<15)&(MA(:,5)>0)&(MA(:,6)==20)&(MA(:,7)==20); 

A10 = MA(LV10f2020,:); % all the subjects
% with 10s fixed-duration CS, 20s average ITI duration and 20s average
% US-US interval; 23 subjects; 13 acquired

ParamAcqTbl{1,:}= [A10(1,4:10) nanmedian(A10(:,11)) ...
    nanmean(A10(:,12:end))];

%
LV202020 = (MA(:,4)==20) & (MA(:,7)==20);
A202020 = MA(LV202020,:);
ParamAcqTbl{2,:} = [A202020(1,4:10) nanmedian(A202020(:,11)) ...
    nanmean(A202020(:,12:end))];  
%
LV202040 = (MA(:,4)==20) & (MA(:,7)>20);
A202040 = MA(LV202040,:);
ParamAcqTbl{3,:} = [A202040(1,4:10) nanmedian(A202040(:,11)) ...
    nanmean(A202040(:,12:end))];  
%%
LV30f2020 = (MA(:,4)==30)&(MA(:,5)>0)&(MA(:,6)==20)&(MA(:,7)==20); 
A30f2020 = MA(LV30f2020,:);
ParamAcqTbl{4,:} = [A30f2020(1,4:10) nanmedian(A30f2020(:,11)) ...
    nanmean(A30f2020(:,12:end))];
%%
LV30v2020 = (MA(:,4)==30)&(MA(:,5)<1)&(MA(:,6)==20)&(MA(:,7)==20); 
A30v2020 = MA(LV30v2020,:);
ParamAcqTbl{5,:} = [A30v2020(1,4:10) nanmedian(A30v2020(:,11)) ...
    nanmean(A30v2020(:,12:end))];
%%
LV30f8020 = (MA(:,4)==30)&(MA(:,5)>0)&(MA(:,6)==80)&(MA(:,7)==20); 
A30f8020 = MA(LV30f8020,:);
ParamAcqTbl{6,:} = [A30f8020(1,4:10) nanmedian(A30f8020(:,11)) ...
    nanmean(A30f8020(:,12:end))];
%
LV402020 = (MA(:,4)==40)&(MA(:,6)==20)&(MA(:,7)==20); 
A402020 = MA(LV402020,:);
ParamAcqTbl{7,:} = [A402020(1,4:10) nanmedian(A402020(:,11)) ...
    nanmean(A402020(:,12:end))];
%
LV402039 = (MA(:,4)==40)&(MA(:,6)==20)&(MA(:,7)>25); 
A402039 = MA(LV402039,:);
ParamAcqTbl{8,:} = [A402039(1,4:10) nanmedian(A402039(:,11)) ...
    nanmean(A402039(:,12:end))];
%
LV50f2020 = (MA(:,4)==50)&(MA(:,5)>0)&(MA(:,6)==20)&(MA(:,7)==20); 
A50f2020 = MA(LV50f2020,:);
ParamAcqTbl{9,:} = [A50f2020(1,4:10) nanmedian(A50f2020(:,11)) ...
    nanmean(A50f2020(:,12:end))];
%
LV50v2020 = (MA(:,4)==50)&(MA(:,5)<1)&(MA(:,6)==20)&(MA(:,7)==20); 
A50v2020 = MA(LV50v2020,:);
ParamAcqTbl{10,:} = [A50v2020(1,4:10) nanmedian(A50v2020(:,11)) ...
    nanmean(A50v2020(:,12:end))];
%
LV602020 = (MA(:,4)==60)&(MA(:,6)==20)&(MA(:,7)==20); 
A602020 = MA(LV602020,:);
ParamAcqTbl{11,:} = [A602020(1,4:10) nanmedian(A602020(:,11)) ...
    nanmean(A602020(:,12:end))];
%
LV608020 = (MA(:,4)==60)&(MA(:,6)==80)&(MA(:,7)==20); 
A608020 = MA(LV608020,:);
ParamAcqTbl{12,:} = [A608020(1,4:10) nanmedian(A608020(:,11)) ...
    nanmean(A608020(:,12:end))];
%
LV802020 = (MA(:,4)>79)&(MA(:,4)<81)&(MA(:,6)==20)&(MA(:,7)==20); 
A802020 = MA(LV802020,:);
ParamAcqTbl{13,:} = [A802020(1,4:10) nanmedian(A802020(:,11)) ...
    nanmean(A802020(:,12:end))];
%
LV802039 = (MA(:,4)>79)&(MA(:,4)<81)&(MA(:,6)==20)&(MA(:,7)>25); 
A802039 = MA(LV802039,:);
ParamAcqTbl{14,:} = [A802039(1,4:10) nanmedian(A802039(:,11)) ...
    nanmean(A802039(:,12:end))];
%
LV808020 = (MA(:,4)>79)&(MA(:,4)<81)&(MA(:,6)==80)&(MA(:,7)==20); 
A808020 = MA(LV808020,:);
ParamAcqTbl{15,:} = [A808020(1,4:10) nanmedian(A808020(:,11)) ...
    nanmean(A808020(:,12:end))];
%
LV801020 = (MA(:,4)>79)&(MA(:,4)<81)&(MA(:,6)<15)&(MA(:,7)<25); 
A801020 = MA(LV801020,:);
ParamAcqTbl{16,:} = [A801020(1,4:10) nanmedian(A801020(:,11)) ...
    nanmean(A801020(:,12:end))];
%
LV1602020 = MA(:,4)>81; 
A1602020 = MA(LV1602020,:);
ParamAcqTbl{17,:} = [A1602020(1,4:10) nanmedian(A1602020(:,11)) ...
    nanmean(A1602020(:,12:end))];

save PredictorsAndResultsTbl ParamAcqTbl
save PredictorAndResultsArraysByGroup A10 A202020 A202040 A30f2020 A30v2020 A30f8020 ...
    A402020 A402039 A50f2020 A50v2020 A602020 A608020 A802020 A802039 A808020 ...
    A801020 A1602020

%% Computing standard errors & putting them in a table
ArrayNames = {'A10' 'A202020' 'A202040' 'A30f2020' 'A30v2020' 'A30f8020' ...
    'A402020' 'A402039' 'A50f2020' 'A50v2020' 'A602020' 'A608020' 'A802020' ...
    'A802039' 'A808020' 'A801020' 'A1602020'};

Ase = nan(17,13);
for a = 1:17
    A = eval(ArrayNames{a});
    Ase(a,:) = stder2(A(:,12:end));
    %{
    function se = stder2(v)
    se = nanstd(v)./sqrt(sum(~isnan(v)));
    %}
end    
%
VrN = {'CSITIdif' 'CSPstPreDif' 'ITIPstPreDif' 'd1' 'd2' 'd3' 'd4' 'd5' 'd6' 'd7' 'd8' 'd9' 'd10'};
ResultsStdErrorTbl = array2table(Ase,'VariableNames',VrN);

writetable(ResultsStdErrorTbl,'ResultsStdErrorTbl.txt')
%% linear plots of Trials to Acquisition vs Informativeness & NxInformativeness
figure;subplot(2,1,1);plot(ParamAcqTbl.Infrmtvns,ParamAcqTbl.TrlToAcq,'k*')
xlabel('Informativeness (\lambda_{ITI}/\lambda_C)'); ylabel('Trials To Acquisition')
subplot(2,1,2);plot(ParamAcqTbl.NxInf,ParamAcqTbl.TrlToAcq,'k*')
xlabel('{\itN}_{USs|CSoff}x\lambda_{ITI}/\lambda_C'); ylabel('Trials To Acquisition')


%% loglog plots of trials to acquisitiion vs just informativeness or vs
% N_USs|CSoff X informativeness, with  separate plots for varying N_USs|CSoff
% code for figure whose file is named TrlToAcqVsInfvns&NxsinvnsLogLog
LV1 = ParamAcqTbl.USsAtCSoff==1;
LVm1 = ParamAcqTbl.USsAtCSoff>1;
LVl1 = ParamAcqTbl.USsAtCSoff<1;
%
figure;subplot(2,1,1);loglog(ParamAcqTbl.Infrmtvns(LV1),ParamAcqTbl.TrlToAcq(LV1),'k*')
hold on
loglog(ParamAcqTbl.Infrmtvns(LVm1),ParamAcqTbl.TrlToAcq(LVm1),'r+')
loglog(ParamAcqTbl.Infrmtvns(LVl1),ParamAcqTbl.TrlToAcq(LVl1),'go')
xlabel('Informativeness=\lambda_{ITI}/\lambda_C( log scale)')
ylabel('Trials To Acquisition (log scale)')
legend('{\itN}_{USs|CSoff} = 1','{\itN}_{USs|CSoff} > 1','{\itN}_{USs|CSoff} < 1',...
    'location','NE')
xlim([.99 10]);ylim([100 500])
set(gca,'XTick',[1 2 3 5 10],'XTickLabel',{'1' '2' '3' '5' '10'})
%
subplot(2,1,2);loglog(ParamAcqTbl.NxInf(LV1),ParamAcqTbl.TrlToAcq(LV1),'k*')
hold on
loglog(ParamAcqTbl.NxInf(LVm1),ParamAcqTbl.TrlToAcq(LVm1),'r+')
loglog(ParamAcqTbl.NxInf(LVl1),ParamAcqTbl.TrlToAcq(LVl1),'go')
xlabel('{\itN}_{USs|CSoff}x\lambda_{ITI}/\lambda_C (log scale)')
ylabel('Trials To Acquisition (log scale)' )
xlim([.99 10]);ylim([100 500])
set(gca,'XTick',[1 2 3 5 10],'XTickLabel',{'1' '2' '3' '5' '10'})

%% Fitting k/log(N_USs|CSoff X Informativeness) model to data on median
% trials to acquisition vs N_USs|CSoff X Informativeness in subplot(2,1,1)
% in immediately preceding cell
load('PredictorsAndResultsTbl.mat')
%
LV1 = ParamAcqTbl.USsAtCSoff==1;
LVm1 = ParamAcqTbl.USsAtCSoff>1;
LVl1 = ParamAcqTbl.USsAtCSoff<1;
%
xD = [ParamAcqTbl.NxInf(LV1);ParamAcqTbl.NxInf(LVm1);ParamAcqTbl.NxInf(LVl1)];
yD = [ParamAcqTbl.TrlToAcq(LV1);ParamAcqTbl.TrlToAcq(LVm1);ParamAcqTbl.TrlToAcq(LVl1)];
D = sortrows([xD,yD]);
% plot(xD,yD,'k*')
%%
beta0 = 70;
modelfun=@(b,x)b./log(x);
mdl = fitnlm(xD,yD,modelfun,beta0);
%{
Estimated Coefficients:
          Estimate     SE     tStat    pValue
          ________    ____    _____    ______

    b1    6.42        2.77    2.31     0.03 
%}
%%
D = sortrows([xD,yD]);
%%
close all
figure
subplot(2,2,1)
    plot(D(:,1),D(:,2),'*');ylim([0 500])
subplot(2,2,2)
    semilogx(D(:,1),D(:,2),'*');ylim([0 500])
subplot(2,2,3)
    semilogy(D(:,1),D(:,2),'*');ylim([10 500])
subplot(2,2,4)
    loglog(D(:,1),D(:,2),'*');ylim([10 500])
%% Plots of Rate differences vs predictors
StdErTbl=readtable('ResultsStdErrorTbl')

%% CS-ITI post-Acquisition rate difference
figure
subplot(3,2,1)
    plot(ParamAcqTbl.CSdr,ParamAcqTbl.CSITIdif,'k*')
    xlabel('CS duration (s)')
subplot(3,2,2)
    plot(ParamAcqTbl.ITIdr,ParamAcqTbl.CSITIdif,'k*')
    xlabel('ITI Duration (s)')
subplot(3,2,3)
    plot(ParamAcqTbl.USUSint,ParamAcqTbl.CSITIdif,'k*')
    xlabel('Mean US-US Interval (s)')
    xlim([19 41])
    ylabel('Mean Post-Acquisition CS-ITI Poke Rate Difference')
subplot(3,2,4)
    plot(ParamAcqTbl.USsAtCSoff,ParamAcqTbl.CSITIdif,'k*')
    xlabel('Mean {\itN}_{USs|CSoff}')
subplot(3,2,5)
    plot(ParamAcqTbl.Infrmtvns,ParamAcqTbl.CSITIdif,'k*')
    xlabel('\lambda_{ITI}/\lambda_C')
subplot(3,2,6)
    plot(ParamAcqTbl.NxInf,ParamAcqTbl.CSITIdif,'k*')
    xlabel('{\itN}_{USs|CSoff} X \lambda_{ITI}/\lambda_C')
    
%% CS Pre-Post rate difference
figure
subplot(3,2,1)
    plot(ParamAcqTbl.CSdr,ParamAcqTbl.CSPstPreDif,'k*')
    xlabel('CS duration (s)')
subplot(3,2,2)
    plot(ParamAcqTbl.ITIdr,ParamAcqTbl.CSPstPreDif,'k*')
    xlabel('ITI Duration (s)')
subplot(3,2,3)
    plot(ParamAcqTbl.USUSint,ParamAcqTbl.CSPstPreDif,'k*')
    xlabel('Mean US-US Interval (s)')
    xlim([19 41])
    ylabel('PostAcq-PreAcq CS Poke Rate Difference')
subplot(3,2,4)
    plot(ParamAcqTbl.USsAtCSoff,ParamAcqTbl.CSPstPreDif,'k*')
    xlabel('Mean {\itN}_{USs|CSoff}')
subplot(3,2,5)
    plot(ParamAcqTbl.Infrmtvns,ParamAcqTbl.CSPstPreDif,'k*')
    xlabel('\lambda_{ITI}/\lambda_C')
subplot(3,2,6)
    plot(ParamAcqTbl.NxInf,ParamAcqTbl.CSPstPreDif,'k*')
    xlabel('{\itN}_{USs|CSoff} X \lambda_{ITI}/\lambda_C')
    
%% ITI Pre-Post rate difference
figure
subplot(3,2,1)
    plot(ParamAcqTbl.CSdr,ParamAcqTbl.ITIPstPreDif,'k*')
    xlabel('CS duration (s)')
subplot(3,2,2)
    plot(ParamAcqTbl.ITIdr,ParamAcqTbl.ITIPstPreDif,'k*')
    xlabel('ITI Duration (s)')
subplot(3,2,3)
    plot(ParamAcqTbl.USUSint,ParamAcqTbl.ITIPstPreDif,'k*')
    xlabel('Mean US-US Interval (s)')
    xlim([19 41])
    ylabel('PostAcq-PreAcq ITI Poke Rate Difference')
subplot(3,2,4)
    plot(ParamAcqTbl.USsAtCSoff,ParamAcqTbl.ITIPstPreDif,'k*')
    xlabel('Mean {\itN}_{USs|CSoff}')
subplot(3,2,5)
    plot(ParamAcqTbl.Infrmtvns,ParamAcqTbl.ITIPstPreDif,'k*')
    xlabel('\lambda_{ITI}/\lambda_C')
subplot(3,2,6)
    plot(ParamAcqTbl.NxInf,ParamAcqTbl.ITIPstPreDif,'k*')
    xlabel('{\itN}_{USs|CSoff} X \lambda_{ITI}/\lambda_C')
    
%% Post-Acquisition CS Decile Profile Plots
figure
subplot(2,2,1)
    errorbar(1:10,ParamAcqTbl{4,12:end},StdErTbl{4,4:end},StdErTbl{4,4:end})
    hold on
    errorbar(1:10,ParamAcqTbl{5,12:end},StdErTbl{5,4:end},StdErTbl{5,4:end},'k--')
    xlim([.50 10.5])
    ylabel('Pokes/s')
    set(gca,'XTick',[2 4 6 8 10],'XTickLabel',{'6' '12' '18' '24' '30'})
    legend('fixed','exponential','location','NE')
    text(6,.42,'\lambda_{ITI}/\lambda_C = 2.5')
subplot(2,2,2)
    errorbar(1:10,ParamAcqTbl{9,12:end},StdErTbl{9,4:end},StdErTbl{9,4:end})
    hold on
    errorbar(1:10,ParamAcqTbl{10,12:end},StdErTbl{10,4:end},StdErTbl{10,4:end},'k--')
    xlim([.50 10.5])
    set(gca,'XTick',[2 4 6 8 10],'XTickLabel',{'10' '20' '30' '40' '50'})
    text(6,.55,'\lambda_{ITI}/\lambda_C = 3.5')
    
% load /Users/galliste/Dropbox/InhibitoryExperiments_All/SummaryStats/SubBySubDataTable
% T=DataTable;
% PltTbl40 = T(T.CSdr==40,[1 2 5:11 16:25]);
% PltTbl80 = T(T.CSdr==80,[1 2 5:11 16:25]);
%

subplot(2,2,3)
    plot(1:10,mean(PltTbl40{PltTbl40{:,6}<30,10:19}))
    hold on
    plot(1:10,mean(PltTbl40{PltTbl40{:,6}>30,10:19}),'k--')
    xlim([.5 10.5])
    set(gca,'XTick',[1 5 10],'XTickLabel',{'1' '20' '40'})
    xlabel('Elapsed time in CS (s)')
    ylabel('Pokes/s')
    legend('{\it N}_{US|CS}*\lambda_{ITI}/\lambda_C = 3',...
        '{\it N}_{US|CS}*\lambda_{ITI}/\lambda_C = 1.5','location','N')
    text(2,.3,'{\it ITI}=20, {\it US-US}=20')
    text(3,.27,'{\it N}_{US|CSoff}=1')
    text(4.5,.22,'\lambda_{ITI}/\lambda_C=3')
    text(2,.15,'{\it ITI}=20, {\it US-US}=20')
    text(3,.12,'{\it N}_{US|CSoff}=.5')
    text(4,.075,'\lambda_{ITI}/\lambda_C=3')

subplot(2,2,4)
    plot(1:10,mean(PltTbl80{PltTbl80{:,6}<30,10:19}))
    hold on
    plot(1:10,mean(PltTbl80{PltTbl80{:,6}>30,10:19}),'k--')
    xlim([.5 10.5])
    set(gca,'XTick',[1 5 10],'XTickLabel',{'1' '40' '80'})
    xlabel('Elapsed time in CS (s)')
    legend('{\it N}_{US|CS}*\lambda_{ITI}/\lambda_C = 5',...
        '{\it N}_{US|CS}*\lambda_{ITI}/\lambda_C = 2.5','location','N')
    text(1.5,.22,'{\it ITI}=20, {\it US-US}=20')
    text(2,.19,'{\it N}_{US|CSoff}=1')
    text(3,.16,'\lambda_{ITI}/\lambda_C=5')
    text(2.5,.085,'{\it ITI}=20, {\it US-US}=20')
    text(7,.13,'\lambda_{ITI}/\lambda_C=5')
    text(6.5,.105,'{\it N}_{US|CSoff}=.5')
    