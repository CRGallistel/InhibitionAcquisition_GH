% Trying out normalizing SIs
TSlimit('Subjects',Experiment.Grp10s)
TSlimit('Sessions','all')
TSlimit('Phases','all')
TSsettrialtype('CS')
SI = 1; % intervals into which CS is to be partitioned = 1/10 of CS dur
TSapplystat('PkRatePerCSsubInterval',{'Pktms' 'TrialDuration'},@PksPerSbInt,SI)
% Creates field at the Trial level that gives the poke rate within
% successive sub-intervals of the CS
%{
function O =PksPerSbInt(PkTms,TD,subInterval)
% Output is the poking rate within each successive subInterval of the CS.
% TD is the trial duration; PkTms is the vector of times within the CS at
% which pokes occurred
Edges=0:subInterval:TD+.001; % edges for histc command
O = zeros(1,length(Edges)-1);
O = histc(PkTms',Edges)/subInterval;% poke rates in successive sub-interval
O(end)=[]; % deleting final value, which is always 0
%}

TSlimit('Subjects',Experiment.Grp20s)
TSlimit('Sessions','all')
TSlimit('Phases','all')
TSsettrialtype('CS')
SI = 2; % intervals into which CS is to be partitioned = 1/10 of CS dur
TSapplystat('PkRatePerCSsubInterval',{'Pktms' 'TrialDuration'},@PksPerSbInt,SI)

TSlimit('Subjects',Experiment.Grp40s)
TSsettrialtype('CS')
SI = 4; % intervals into which CS is to be partitioned = 1/10 of CS dur
TSapplystat('PkRatePerCSsubInterval',{'Pktms' 'TrialDuration'},@PksPerSbInt,SI)

TSlimit('Subjects',Experiment.Grp80s)
TSsettrialtype('CS')
SI = 8; % intervals into which CS is to be partitioned = 1/10 of CS dur
TSapplystat('PkRatePerCSsubInterval',{'Pktms' 'TrialDuration'},@PksPerSbInt,SI)

%%
TSlimit('Subjects',[Experiment.Grp10s Experiment.Grp20s Experiment.Grp40s Experiment.Grp80s])

TScombineover('PkRatePerCSsubInt','PkRatePerCSsubInterval') % session level
%
TScombineover('PkRatePerCSsbInt','PkRatePerCSsubInt') % subject level; each
% row is a trial

%%
TSapplystat({'PreAcqPkRatePerCSsbInt' 'PostAcqPkRatePerCSsbInt' ...
    'NormPostAcqRatesBySbInt'},...
    {'PkRatePerCSsbInt' 'AcqPt'},@PrePostRatesBySbInt)
%{
function [Pre,Post,Nrmd]=PrePostRatesBySbInt(RateArray,AcqPt)
if AcqPt < 1500
    Pre = mean(RateArray(1:AcqPt-1,:));
    Post = mean(RateArray(AcqPt:end,:));
    Nrmd = Post./Pre;
else % did not aquire
    Pre = mean(RateArray);
    Post = [];
    Nrmd = [];
end   
%}
%% Aggregating by groups
TSlimit('Subjects',Experiment.Grp10s)
TScombineover('G10NrmPstAcqRtsBySbInt','NormPostAcqRatesBySbInt')

TSlimit('Subjects',Experiment.Grp20s)
TScombineover('G20NrmPstAcqRtsBySbInt','NormPostAcqRatesBySbInt')

TSlimit('Subjects',Experiment.Grp40s)
TScombineover('G40NrmPstAcqRtsBySbInt','NormPostAcqRatesBySbInt')

TSlimit('Subjects',Experiment.Grp80s)
TScombineover('G80NrmPstAcqRtsBySbInt','NormPostAcqRatesBySbInt')
%%
figure
M10 = mean(Experiment.G10NrmPstAcqRtsBySbInt);
[L10,IL10] = min(M10);
plot(M10)
hold on

M20 = mean(Experiment.G20NrmPstAcqRtsBySbInt);
[L20,IL20] = min(M20);
plot(M20)

M40 = mean(Experiment.G40NrmPstAcqRtsBySbInt);
[L40,IL40] = min(M40);
plot(M40)

M80 = mean(Experiment.G80NrmPstAcqRtsBySbInt);
[L80,IL80] = min(M80);
plot(M80)

plot(xlim,[1 1],'k:')
xlabel('CS Duration','FontSize',18)
ylabel('PostAcqSubIntervals/PreAcqSubIntervals')
legend('CS10s','CS20s','CS40s','CS80s','location','NE')
title('Experiment 1 fixed CS')
%% Exponential falls plotted semilogx
figure
semilogx(1:IL10,M10(1:IL10))
hold on
semilogx(1:IL20,M20(1:IL20))
semilogx(1:IL40,M40(1:IL40))
semilogx(1:IL80,M80(1:IL80))
xlim([.9 40])
set(gca,'XTick',[1 2 5 10 20],'XTickLabels',{'1' '2' '5' '10' '20'})
semilogx([1 26],[1.7 .71],'k--')
plot(xlim,[1 1],'k:',xlim,[1.7 1.7],'k:')
xlabel('CS Duration (s, log scale)'); ylabel('PostAcgSubIntRate/PreAcqSubIntRate')
text(10,1.4,'tc = 0.30/s')
legend('CS10s','CS20s','CS40s','CS80s','location','SW')

%% Four linear rises with scaled slopes
figure
subplot(2,2,1)
plot((IL80+1:length(M80))-IL80,M80(IL80+1:end),'k',[1 55],[.5 .5+.016*54],'k--')
title('80s CS')

subplot(2,2,2)
plot((IL40+1:length(M40))-IL40,M40(IL40+1:end),'k',[1 15],[.92 .92+(2*.016)*14],'k--')
title('40s CS')
%
subplot(2,2,3)
plot((IL20+1:length(M20))-IL20,M20(IL20+1:end),'k',[1 12],[L20 L20+(4*.016)*11],'k--')
title('20s CS')
xlabel('Rise Portion of CS (s)')
ylabel('                                             PostAcqSubIntRates/PreAcqSubIntRates')
%
subplot(2,2,4)
plot((IL10+1:length(M10))-IL10,M10(IL10+1:end),[1 5],[L10 L10+(8*.016)*4],'k--')
title('10s CS')
xlabel('Rise Portion of CS (s)')