%This is the script for analyzing the 6th and final experiment in the
%sequence of experiments on the acquisition of an inhibitory CS.
%% Creating an Experiment structure
ExpName='/Users/galliste/Dropbox/InhibitoryExperiments_All/ExperimentStructures/InhibExper6_background';
TSinitexperiment(ExpName,1007,101:132,'Rat','Balsam') % Creates an
% Experiment structure and fills in the following fields:
% Experiment.Name = '/Users/galliste/Dropbox/InhibitoryExperiments_All/ExperimentStructures/InhibExper6_background';
% Experiment.ID = 1006;
% Experiment.Subjects = the row vector [701 402 403 ... 732]
% Experiment.Species = Rat
% Experiment.Lab = Balsam
% The TSinitexperiment function counts the number of elements in the vector
% of subject ID numbers and then fills in another field:
% Experiment.NumSubjects = 32

% Loading into the structure information necessary to the loading of data

TSsetloadparameters('InputTimeUnit',0.1,'OutputTimeUnit',1,'LoadFunction',...
'TSloadBalsamRaw','FilePrefix','!','FileExtension','') 

%% Loading data

cd('C:\Users\pbalsam\Dropbox\Conditioned Inhibition\Rat CI\Background Excitation exp summer 2016 exp 6\Data\Phase 1 CI') % makes Data directory the current directory (Dr contains the complete path to Data directory)
for d = 1:33 % stepping through the Day subfolder
    FN = ['Day ' num2str(d)]; % constructing the name of the folder containing
    % the files we want to load
   
    TSloadsessions(FN) % calling TSloadsession to load the files in that directory
end
%%
%for d = 45:62 % stepping through the Day subfolder
%    FN = ['Ph 2 Day ' num2str(d)]; % constructing the name of the folder containing
    % the files we want to load
   
 %   TSloadsessions(FN) % calling TSloadsession to load the files in that directory
    
%% Importing (or creating) event codes into the Experiment structure and
% then "declaring" them

TSimporteventcodes


%% Creating fields at the Experiment level that specify which subjects are
% in which groups (experimental conditions). We originally entered ID #s
% here instead of index numbers, which was a mistake. The -100 converts 
% after each vector of ID #s converts the ID #s to the appropriate index #s

cd /Users/galliste/Dropbox/InhibitoryExperiments_All/Final CodeFiles/Exper6_background
% This is here to be sure that one is in the right directory when running
% the cells that follow after stripping the Experiment structure down to
% the raw data

Experiment.Grp8_CS80_ITI80 = [101 102 109 110 117 118 125 126]-100; % The group for which the
% inhibitory CS lasted 30s. During the CSs no pellets were delivered.
% Pellets were delivered at random during the ITIs. I excluded Subject 110
% from this group because the #s of trials it had per sessions were very
% different from the other Ss--CRG
%
Experiment.Grp32_CS80_ITI20 = [103 104 111 112 119 120 127 128]-100; % see above

Experiment.Grp32_CS160_ITI20 = [105 106 113 114 121 122 129 130]-100; % see above

Experiment.Grp64_CS80_ITI10 = [107 108 115 116 123 124 131 132]-100; % see above
 
%% Defining CS trial type and computing basic statistics
TSlimit('Subjects','all')
TSlimit('Sessions','all')
TSlimit('Phases','all')
TSdefinetrialtype('CS',[Toneon Toneoff]) % defines stretches of data between
% tone ons and tone offs as CS type trials, enabling us to compute
% statistics for these stretches of data. This trial definition is stored
% in a field at the Experiment level

TStrialstat('UStms',@TSparse,'result=time(1)-starttime;',Pelletdelivered)
% Finds all of the instances of the above-defined trial type and computes
% the times within each CS trial (measured from beginning of trial) at
% which a pellet was delivered. This creates a field at the Trial level
% named UStms, in which it stores these times. TSparse is a helper
% function: it calls TSmatch to search within each trial for the specified
% event (Pelletdelivered) and it then computes for each such event the
% difference between the session time at which it occurred [time(1)] and 
% the session time when the trial started (startime). This computation is
% specified by the code in single quotes: 'result=time(1)-starttime;'
% This command reports an error in processing the data for Session 20 of
% Subject 40 and does not compute the trials for that session. So, to
% trouble-shoot, we limit the data to be processed to that session for that
% subject and rerun the command:

TStrialstat('Pktms',@TSparse,'result=time(1)-starttime;',Pokestart)
% Computes the times within each CS trial (measured from beginning of 
% trial) at which poke was initiated and stores them in a field named 
% PkTms, which it creates at the Trial level.

TSapplystat('NumUSs','UStms',@numel) % Creates a field named
% NumUSs at the Trial level under the CS trial type, into which it puts the 
% number of USs (pellet delivered) during the CS. The helper function is
% Matlab's numel function, which takes arrays as input and gives as output
% the number of elements in the array.
%
TSapplystat('NumPks','Pktms',@numel) % This command creates
% a field named 'NumPks' at the Trial level under the CS trial typoe, using
% the data in the field PkTms and the numel function has its helper
%
TSapplystat('PkRate',{'NumPks' 'TrialDuration'},@rdivide) % Takes the
% datum (number) in the NumPks field and the datum (number) in the
% TrialDuration field, divides the former by the latter to produce the rate
% of poking during a CS, and puts the rate into a field  named PkRate,
% which it creates at the Trial level under the CS trial type. The helper
% function is Matlab's rdivide, which divides the elements of one array by
% the elements of another array of the same size, element by element. In
% this case, however, the "arrays" are just single numbers

% Aggregating ststistics from the CS trials into fields at the Session and
% Subject levels.

TScombineover('CSPkRates','PkRate') % Aggregates the data in the PkRate fields
% at the Trial level under the CS trial type into a single field at the
% Session level, to which it assigns the name CSPkRates

TScombineover('CSdurs','TrialDuration') % Aggregates the data from the
% TrialDuration fields at the Trial level under the CS trial type into a 
% field at the Session level, to which it assigns the name CSdurs. The 
% TrialDuration fields at the Trial level were created automatically when
% we computed the first CS trial statistic. During this computation, the
% sysem found all the CS trials and recorded some basic statistics,
% including their duration

TScombineover('NumCSUSs','NumUSs') % Aggregates the data from the NumUSs
% fields at the Trial level under the CS trial type into a field at the
% Session level, to which it assigns the name NumCSUSs

TScombineover('AllCSPkRates','CSPkRates') % Aggregates the vector of CS poke
% rates in the CSPkRates fields at the Session level into a field at the
% Subject level, to which it assigns the name AllCSPkRates

TScombineover('AllCSdurs','CSdurs') % Aggregates the vector of CS durations
% in the CSdurs fields at the Session level into a field at the Subject
% level, to which it assigns the name AllCSdurs

TScombineover('AllCSUSs','NumCSUSs') % Aggregates the vector of pellet
% deliveries during the CSs in the NumCSUSs field at the Session level into
% a field at the Subject level, to which it assigns the name AllCSUSs

TSsaveexperiment

%% Phase: There were two phases for each subject, an acquisition phase and
% a Resistance-to-Reinforcement phase. The following code put 2-digit
% numbers in the Phase field for every session. The first digit identifies
% the group and the second the phase. Thus 11 indicates that that session
% was an acquisition session for a subject in the first group, while 32
% indicates a session that was a Resistance-to-Reinforcement session for a
% subject in the third group
for S = 1:32
    B = Experiment.Subject(S).Session(1).TrialCS.NumTrials;
    for s=1:Experiment.Subject(S).NumSessions
        if Experiment.Subject(S).Session(s).TrialCS.NumTrials == B
            % Session was an acquisition session
            if ismember(S,Experiment.Grp8_CS80_ITI80)
                Experiment.Subject(S).Session(s).Phase = 11;
            elseif ismember(S,Experiment.Grp32_CS80_ITI20)
                Experiment.Subject(S).Session(s).Phase = 21;
            elseif ismember(S,Experiment.Grp32_CS160_ITI20)
                Experiment.Subject(S).Session(s).Phase = 31;
            else
                Experiment.Subject(S).Session(s).Phase = 41;
            end
        else % Session was a resistance-to-reinforcement session
            if ismember(S,Experiment.Grp8_CS80_ITI80)
                Experiment.Subject(S).Session(s).Phase = 12;
            elseif ismember(S,Experiment.Grp32_CS80_ITI20)
                Experiment.Subject(S).Session(s).Phase = 22;
            elseif ismember(S,Experiment.Grp32_CS160_ITI20)
                Experiment.Subject(S).Session(s).Phase = 32;
            else
                Experiment.Subject(S).Session(s).Phase = 42;
            end
        end
    end
end

%% Defining ITI trial type and computing basic statistics

TSdefinetrialtype('ITI',{[Sessionstart Toneon] [Toneoff Toneon]}) % the ITI
% trial type. When we define a new trial type, it becomes the active trial
% type. Thus, the commands that follow will use that trial type rather than
% the CS trial type used by the preceding suite of commands. This trial
% type is the interval before each CS. Notice that two different event
% vectors are needed to define that interval. The first vector,
% [Sessionstart ToneOn] picks out the interval before the first CS; the 2nd
% vector, [ToneOff ToneOn], picks out the intervals between subsequent CSs
%
TStrialstat('UStms',@TSparse,'result=time(1)-starttime;',Pelletdelivered)
% Finds all of the instances of the ITI trial type and computes
% the times within each ITI trial (measured from beginning of trial) at
% which a pellet was delivered. This creates a field at the Trial level
% under the ITI trial type named UStms, in which it stores these times.

TStrialstat('PkTms',@TSparse,'result=time(1)-starttime;',Pokestart)
% Computes the times within each ITI trial (measured from beginning of 
% trial) at which poke was initiated and stores them in a field named 
% PkTtms at the Trial level under the ITI trial type.
%
TSapplystat('NumUSs','UStms',@numel) % Creates a field named
% NumUSs at the Trial level under the ITI trial type, into which it puts 
% the  number of USs (pellet delivered) during the ITI

TSapplystat('NumPks','PkTms',@numel) % Creates
% a field named 'NumPks' at the Trial level under the ITI trial type, into
% which it puts the number of elements in the PkTms field of the same trial

TSapplystat('PkRate',{'NumPks' 'TrialDuration'},@rdivide) % Takes the
% datum (number) in the NumPks field and the datum (number) in the
% TrialDuration field, divides the former by the latter to produce the rate
% of poking during a ITI, and puts the rate into a field  named PkRate,
% which it creates at the Trial level under the ITI trial type

% Aggregating ststistics from the ITI trials into fields at the Session and
% Subject levels

TScombineover('ITIPkRates','PkRate') % Aggregates the data in the PkRate fields
% at the Trial level under the ITI trial type into a single field at the
% Session level, to which it assigns the name CSPkRates

TScombineover('ITIdurs','TrialDuration') % Aggregates the data from the
% TrialDuration fields at the Trial level under the ITI trial type into a 
% field at the Session level, to which it assigns the name CSdurs. The 
% TrialDuration fields at the Trial level were created automatically when
% we computed the first ITI trial statistic. During this computation, the
% sysem found all the CS trials and recorded some basic statistics,
% including their duration

TScombineover('NumITIUSs','NumUSs') % Aggregates the data from the NumUSs
% fields at the Trial level under the CS trial type into a field at the
% Session level, to which it assigns the name NumCSUSs

TScombineover('AllITIPkRates','ITIPkRates') % Aggregates the vector of ITI poke
% rates in the ITIPkRates fields at the Session level into a field at the
% Subject level, to which it assigns the name AllITIPkRates

TScombineover('AllITIdurs','ITIdurs') % Aggregates the vector of ITI durations
% in the ITIdurs fields at the Session level into a field at the Subject
% level, to which it assigns the name AllITIdurs

TScombineover('AllITIUSs','NumITIUSs') % Aggregates the vector of pellet
% deliveries during the ITIs in the NumITIUSs field at the Session level into
% a field at the Subject level, to which it assigns the name AllITIUSs
%
TScombineover('CumUStmsDrgITIs','UStms','m') % Creates a field named
% IRIsDuringITIs at the Session level that contains the cumulative reward
% times on a clock that only runs during ITIs. Differencing will these
% cumulative times will give the intervals between USs

TSapplystat('IRIsDuringITIs','CumUStmsDrgITIs',@diff) % field at the
% Session level

TScombineover('AllIRIsDuringITIs','IRIsDuringITIs') % field at the Subject
% level
TSsaveexperiment

%% Computing trial-by-trial CS-ITI poke rate differences (CS poke rate on
% each trial minus the poke rate during the preceding ITI)

TSapplystat('CS_ITIrateDiffs',{'AllCSPkRates' 'AllITIPkRates'},@minus) % subject level
% Computes the trial-by-trial differences in the rate of poking during the
% CS and during the ITI that precedes the CS and puts the resulting vector
% of rate differences in a field at the Subject level, to which it assigns
% the name CS_ITIrateDiffs. The poke rates during the CS trials are in the
% AllCSPkRates field; the poke rates during the preceding ITIs are in the
% AllITIPkRates field. The function is Matlab's minus functions,
% which subtracts each element in one vector from the corresponding element
% in the other vector, provided, of course, that the two vectors have the
% same number of elements. I subsequently learned that there were two
% phases in this experiment. The above field sweeps across those two
% phases. The code in the following cell restricts the rate difference
% computation to the first phase, the acquisition phase, during which there
% were no USs during the CSs

%% Confining analyses to the acquisition phases
TSlimit('Subjects','all')
TSlimit('Phases',[11 21 31 41])
TScombineover('AcqCSPokeRates','CSPkRates') % creates field at Subject level
% named 'AcqCSPokeRates' with CS poke rates from the acquisition sessions

TScombineover('AcqITIPokeRates','ITIPkRates') % ditto for ITI poke rates
%
TSapplystat('AcqCSpkRateMean','CSPkRates',@mean) % session level scalar
TSapplystat('AcqITIpkRateMean','ITIPkRates',@mean) % session level scalar
TSapplystat('AcqITI_CSpkRateDiffs',{'ITIPkRates' 'CSPkRates'},@minus)
% session level vector
TSapplystat('AcqITI_CSpkRateDiffsMean','AcqITI_CSpkRateDiffs',@mean)
% session level scalar

%
TSapplystat('AcqCS_ITIrateDiffs',{'AcqCSPokeRates' 'AcqITIPokeRates'},@minus)
% subject level
% creates field at Subject level giving trial-by-trial CS-ITI poke rate
% differences during the acquisition sessions

%% Subject-level Session-by-Session mean CS pk rate ITI pk rate and Cs-ITI
%  pk rate difference
subs = [Experiment.Grp8_CS80_ITI80 Experiment.Grp32_CS80_ITI20 ...
    Experiment.Grp32_CS160_ITI20 Experiment.Grp64_CS80_ITI10];
TSlimit('Subjects',subs)

TScombineover('AcqCSPkRateMeans','AcqCSpkRateMean') % Subject level col vec
TSapplystat('AcqCSPkRateMeans','AcqCSPkRateMeans',@transpose) % convert to row vec

TScombineover('AcqITIPkRateMeans','AcqITIpkRateMean') % Subject level col vec
TSapplystat('AcqITIPkRateMeans','AcqITIPkRateMeans',@transpose) % convert to row vec
%
TScombineover('AcqITI_CS_PkRateDiffMeans','AcqITI_CSpkRateDiffsMean')
% Subject level col vec
TSapplystat('AcqITI_CS_PkRateDiffMeans','AcqITI_CS_PkRateDiffMeans',@transpose) % convert to row vec

%% Aggregating Session by Session Mean CS, ITI and ITI-CS poke rates to
% groups at Experiment level
TSlimit('Subjects',Experiment.Grp8_CS80_ITI80)
TScombineover('G8_C80_I80_AcqCSPkRateMeans','AcqCSPkRateMeans')
TScombineover('G8_C80_I80_AcqITIPkRateMeans','AcqITIPkRateMeans')
TScombineover('G8_C80_I80_AcqRateDiffMeans','AcqITI_CS_PkRateDiffMeans')

TSlimit('Subjects',Experiment.Grp32_CS80_ITI20)
TScombineover('G32_C80_I20_AcqCSPkRateMeans','AcqCSPkRateMeans')
TScombineover('G32_C80_I20_AcqITIPkRateMeans','AcqITIPkRateMeans')
TScombineover('G32_C80_I20_AcqRateDiffMeans','AcqITI_CS_PkRateDiffMeans')

TSlimit('Subjects',Experiment.Grp32_CS160_ITI20)
TScombineover('G32_C160_I20_AcqCSPkRateMeans','AcqCSPkRateMeans')
TScombineover('G32_C160_I20_AcqITIPkRateMeans','AcqITIPkRateMeans')
TScombineover('G32_C160_I20_AcqRateDiffMeans','AcqITI_CS_PkRateDiffMeans')

TSlimit('Subjects',Experiment.Grp64_CS80_ITI10)
TScombineover('G64_C80_I10_AcqCSPkRateMeans','AcqCSPkRateMeans')
TScombineover('G64_C80_I10_AcqITIPkRateMeans','AcqITIPkRateMeans')
TScombineover('G64_C80_I10_AcqRateDiffMeans','AcqITI_CS_PkRateDiffMeans')

%% Graphing Session-by-Session CS, ITI & Diff Poke Rate Means by Group
figure
subplot(2,2,1)
plot(mean(Experiment.G8_C80_I80_AcqCSPkRateMeans),'k-')
hold on
plot(mean(Experiment.G32_C80_I20_AcqCSPkRateMeans),'k--')
plot(mean(Experiment.G32_C160_I20_AcqCSPkRateMeans),'k-.')
plot(mean(Experiment.G64_C80_I10_AcqCSPkRateMeans),'k:')
ylim([0 .6]);xlim([0 33])
xlabel('Session')
ylabel('CS Poke Rate ({s^-1})')
legend('G8C80I80','G32C80I20','G32C160I20','G64C80I10','location','NW')

subplot(2,2,2)
plot(mean(Experiment.G8_C80_I80_AcqITIPkRateMeans),'k-')
hold on
plot(mean(Experiment.G32_C80_I20_AcqITIPkRateMeans),'k--')
plot(mean(Experiment.G32_C160_I20_AcqCSPkRateMeans),'k-.')
plot(mean(Experiment.G64_C80_I10_AcqITIPkRateMeans),'k:')
ylim([0 .6]);xlim([0 33])
xlabel('Session')
ylabel('ITI Poke Rate ({s^-1})')

subplot(2,2,4)
plot(mean(Experiment.G8_C80_I80_AcqRateDiffMeans),'k-')
hold on
plot(mean(Experiment.G32_C80_I20_AcqRateDiffMeans),'k--')
plot(mean(Experiment.G32_C160_I20_AcqRateDiffMeans),'k-.')
plot(mean(Experiment.G64_C80_I10_AcqRateDiffMeans),'k:')
ylim([0 .5]);xlim([0 33])
xlabel('Session')
ylabel('ITI-CS Poke Rate ({s^-1})')

subplot(2,2,3) % These p values are obtained from the ANOVAs--see below
text(.1,.85,{'CS ANOVA';'  p_S<0.001; p_G=.002';'  p_S_x_G<.001'})
text(.1,.5,{'ITI ANOVA';'  p_S=0.22; p_G=.002';'  p_S_x_G<.001'})
text(.1,.15,{'ITI-CS ANOVA';'  p_S<0.001; p_G=.02';'  p_S_x_G<.001'})
set(gca,'XTick',[],'YTick',[],'Color',[1 1 1])

%% The above plots reveal that there is something wrong with the data from
% Session 19 in the G64_C80_I10 group. The problem is there in the raw
% data; it does not arise from an error in the code or from a NaN.
% Therefore, it is necessary to delete Session 19 from the data for that
% group, leaving only 20 sessions for that group. For purposes of the
% ANOVAs, I will delete the sessions > 20 from the other groups. There were
% only 21 sessions in that group anyway, as opposed to 30 sessions for the
% other three groups. In this cell, I replace those data with NaNs;
% after which, I rerun the graphic in the above cell
Experiment.G64_C80_I10_AcqCSPkRateMeans(:,19)=nan(8,1);
Experiment.G64_C80_I10_AcqITIPkRateMeans(:,19)=nan(8,1);
Experiment.G64_C80_I10_AcqRateDiffMeans(:,19)=nan(8,1);
% For the ANOVAs that follow, I delete this session and restrict the # of
% sessions for the other three groups to the first 20

%% Creating arrays to be fed to CS ANOVA                         
% 
BadSes = 19; % bad session in 4th group
NumSes = 20; % the number of sessions for group with fewest
TSapplystat('CSpkRateByDayByGroup',{'G8_C80_I80_AcqCSPkRateMeans' ...
    'G32_C80_I20_AcqCSPkRateMeans' 'G32_C160_I20_AcqCSPkRateMeans' ...
    'G64_C80_I10_AcqCSPkRateMeans' 'Grp8_CS80_ITI80' 'Grp32_CS80_ITI20' ...
    'Grp32_CS160_ITI20' 'Grp64_CS80_ITI10'},@vct6,BadSes,NumSes)
    %{
    function Aout = vct6(Gn8c80i80,Gn32c80i20,Gn32c160i20,Gn64c80i10,G1,G2,G3,G4,bd,ns )

    Gn64c80i10(:,bd) = []; % removing bad data column from 4th group, which
    % reduces # sessions in this group to 20

    % reducing # sessions in other 3 groups to 20
    Gn8c80i80(:,ns+1:end) =[];
    Gn32c80i20(:,ns+1:end) =[]; 
    Gn32c160i20(:,ns+1:end) =[]; 

    % building array
    Aout = [reshape(Gn8c80i80,[],1);reshape(Gn32c80i20,[],1);...
        reshape(Gn32c160i20,[],1);reshape(Gn64c80i10,[],1)]; % data column
    Aout(:,2) = repmat((1:20)',8*4,1); % column for session #
    Aout(:,3) = [reshape(repmat(G1,20,1),[],1);reshape(repmat(G2,20,1),[],1);...
        reshape(repmat(G3,20,1),[],1);reshape(repmat(G4,20,1),[],1)]; % sub IDs
    Aout(:,4) = [ones(8*20,1);2*ones(8*20,1);3*ones(8*20,1);4*ones(8*20,1)];
    % group IDs
    % NB cannot do interactions btw CSnum, CSdur & ITIdur because these are
    only partially crossed, so no point in having columns for them
    %}
    
% Creating array to be fed to ITI ANOVA
TSapplystat('ITIpkRateByDayByGroup',{'G8_C80_I80_AcqITIPkRateMeans' ...
    'G32_C80_I20_AcqITIPkRateMeans' 'G32_C160_I20_AcqITIPkRateMeans' ...
    'G64_C80_I10_AcqITIPkRateMeans' 'Grp8_CS80_ITI80' 'Grp32_CS80_ITI20' ...
    'Grp32_CS160_ITI20' 'Grp64_CS80_ITI10'},@vct6,BadSes,NumSes)

% Creating array to be fed to ITI-CS ANOVA
TSapplystat('RateDiffMeansByDayByGroup',{'G8_C80_I80_AcqRateDiffMeans' ...
    'G32_C80_I20_AcqRateDiffMeans' 'G32_C160_I20_AcqRateDiffMeans' ...
    'G64_C80_I10_AcqRateDiffMeans' 'Grp8_CS80_ITI80' 'Grp32_CS80_ITI20' ...
    'Grp32_CS160_ITI20' 'Grp64_CS80_ITI10'},@vct6,BadSes,NumSes)

%% CS  ANOVA
VarNames = {'Session', 'Subject','Group'};
% Subject is nested within group, so:
NestMatrx = [0 0 0;0 0 1;0 0 0];
% Subject (the 2nd factor) is a random factor, so
rnd = 2;
% The model type is 'interaction' (only the 2-way interactions), so:
mdl = 'interaction';
% I assume we should use the type 3 sum of squares (the default)
TSapplystat('CSpkRateBySesByGrpANOVApVals','CSpkRateByDayByGroup',...
    @GroupBySesANOVA6,mdl,NestMatrx,rnd,VarNames)
%{
      Source                   Sum Sq.   d.f.   Mean Sq.     F     Prob>F
    ---------------------------------------------------------------------
      Session                  0.14248    19    0.0075      1.94   0.0098
      Subject(Group)           0.43639    28    0.01559     4.04   0     
      Group                    0.23042     3    0.07681     4.93   0.0071
      Session*Subject(Group)   2.05393   532    0.00386      Inf      NaN
      Session*Group            0.41249    57    0.00724     1.87   0.0002
      Error                    0           0    0                        
      Total                    3.27572   639                                 
%}
%% ITI Poke Rate by Session & Group ANOVA
VarNames = {'Session', 'Subject','Group'};
% Subject is nested within group, so:
NestMatrx = [0 0 0;0 0 1;0 0 0];
% Subject (the 2nd factor) is a random factor, so
rnd = 2;
% The model type is 'interaction' (only the 2-way interactions), so:
mdl = 'interaction';
% I assume we should use the type 3 sum of squares (the default)
TSapplystat('ITIpkRateBySesByGrpANOVApVals','ITIpkRateByDayByGroup',...
    @GroupBySesANOVA6,mdl,NestMatrx,rnd,VarNames)
%{
      Source                   Sum Sq.   d.f.   Mean Sq.     F     Prob>F
    ---------------------------------------------------------------------
      Session                   0.3992    19    0.02101     1.24   0.2225
      Subject(Group)            6.1026    28    0.21795    12.82   0     
      Group                     2.4552     3    0.81838     3.75   0.022 
      Session*Subject(Group)    9.0438   532    0.017        Inf      NaN
      Session*Group             2.1082    57    0.03699     2.18   0     
      Error                     0          0    0                        
      Total                    20.1091   639                                                              
%}
%% ITI-CS Poke Rate Difference by Session & Group ANOVA
VarNames = {'Session', 'Subject','Group'};
% Subject is nested within group, so:
NestMatrx = [0 0 0;0 0 1;0 0 0];
% Subject (the 2nd factor) is a random factor, so
rnd = 2;
% The model type is 'interaction' (only the 2-way interactions), so:
mdl = 'interaction';
% I assume we should use the type 3 sum of squares (the default)
TSapplystat('RateDiffMeansByDayByGroupANOVApvals','RateDiffMeansByDayByGroup',...
    @GroupBySesANOVA6,mdl,NestMatrx,rnd,VarNames)
%{
       Source                   Sum Sq.   d.f.   Mean Sq.     F     Prob>F
    ---------------------------------------------------------------------
      Session                   0.5506    19    0.02898     2.42   0.0007
      Subject(Group)            5.6579    28    0.20207    16.9    0     
      Group                     3.7731     3    1.25769     6.22   0.0022
      Session*Subject(Group)    6.3615   532    0.01196      Inf      NaN
      Session*Group             1.6836    57    0.02954     2.47   0     
      Error                     0          0    0                        
      Total                    18.0267   639                                
%}
TSsaveexperiment

%% Trials to Acquisition, as estimated by the point in the cumulative diff record, at
% which the cumulative record of rate differences is down by dwn from its
% maximum value and ends at least 2*dwn below 0
TSlimit('Subjects','all')
dwn = 5; % amount by which cum rec must decline from its maximum
TSapplystat('SimpleAcqPt','AcqCS_ITIrateDiffs',@SimpleAcqPt,dwn)
%{
function AP = SimpleAcqPt(Diffs,dwn)
% dwn is the threshold fall in the record
AP = 1500; % greater than total # of trials
CmSm = cumsum(Diffs); % cumulative record of differences
[Mx,Imx] = max(CmSm); % maximum of cumulative record
APtent = find(CmSm(Imx:end) < Mx-dwn,1)+Imx; % trial at which record has
% dropped by dwn from its maximum
if (CmSm(end)< -2*dwn) && (CmSm(end) < CmSm(APtent)-dwn) % record continued
    % fall after crossing the threshold for "acquisition" and ended at
    % least 2*dwn below 0
    AP = APtent;
end
%}

% Aggregating trials to acquisition by group at Experiment level
  
TSlimit('Subjects',Experiment.Grp8_CS80_ITI80)
TScombineover('Grp8_CS80_ITI80SimpleAcqPts','SimpleAcqPt')

TSlimit('Subjects',Experiment.Grp32_CS80_ITI20)
TScombineover('Grp32_CS80_ITI20SimpleAcqPts','SimpleAcqPt')

TSlimit('Subjects',Experiment.Grp32_CS160_ITI20)
TScombineover('Grp32_CS160_ITI20SimpleAcqPts','SimpleAcqPt')

TSlimit('Subjects',Experiment.Grp64_CS80_ITI10)
TScombineover('Grp64_CS80_ITI10SimpleAcqPts','SimpleAcqPt')

TSsaveexperiment

% CDFs of Trials to Acquisition by Groups
 
TSapplystat('',{'Grp8_CS80_ITI80SimpleAcqPts' 'Grp32_CS160_ITI20SimpleAcqPts' ...
    'Grp32_CS80_ITI20SimpleAcqPts' 'Grp64_CS80_ITI10SimpleAcqPts'},...
    @TSplotcdfs,'Rows',1,'Cols',1,'DataCols',{(1) (1) (1) (1)},'Xlbl',...
    'Acquisition Trial','Xlm',[0 500])

set(get(gca,'Children'),'LineWidth',2)
set(gca,'FontSize',14)
xlabel('Acquisition Trial','FontSize',14)
ylabel('Cumulative Fraction of Subjects','FontSize',14)

legend('Grp8-80-80','Grp32-80-20','Grp32-160-20','Grp64-80-10','Location','SE')
title('Experiment 6: CDFs for Trials To Acquisition')

%  
% Adding field at Experiment level with median acquisition trial
TSapplystat('MedianTrlsToAcq',...
    {'Grp8_CS80_ITI80SimpleAcqPts' 'Grp32_CS80_ITI20SimpleAcqPts' ...
    'Grp32_CS160_ITI20SimpleAcqPts' 'Grp64_CS80_ITI10SimpleAcqPts'},...
    @AcqMedians,[88080 328020 3216020 648010]) % the last argument in this
% call gives the purely numerical group identification numbers to be put in
% the the first column of the array. Thus the first column identifies the
% group and the 2nd column gives the median trials to acquisition for that
% group
%
%{
function AM = AcqMedians(varargin)
% all but the last argument in varargin are column arrays of acquisition
% points from the usestat fields specified in the call. The last argument
% is a row vector of purely numerical group ID numbers. The number of
% elements in this group should match the number of arrays passed in from
% usestat fields
if numel(varargin{end})==length(varagin)-1 % number of group ID numbers is
    % the same as the number of arrays for which medians will be computed
    AM(:,1) = varargin{end}'; % group identification #s in Col 1
    for r = 1:length(varagin)-1 % filling in the medians in Col 2
        AM(r,2) = median(varargin{r});
    end
else
    fprintf('\nError: Number of group identification numbers is not equal to number of medians!\n')
end

AM(AM(:,2)==1500,2) = nan; % medians of 1500 converted to nans,
% because we initialized estimated acquisition points to 1500 for graphic
% reasons (so that failures to acquire were evident in cumulative
% distributions of acquisition points). 1500 is more than the total # of
% trials  
%}

%% Post-acquisition response-rate diffs
TSlimit('Subjects','all')
TSapplystat('PostAcqMnRateDiff',{'AcqCS_ITIrateDiffs' 'SimpleAcqPt'},@PostAcqMnRateDiff)
% field at the Subject level giving the mean CS-ITI rate difference over
% the post-acquisition trials
%{
function df = PostAcqMnRateDiff(Dfs,AP)
if AP<1500
    df = mean(Dfs(AP:end));
else
    df=nan;
end
%}

% Aggregating post acqusition mean CS-ITI rate differences

TSlimit('Subjects',Experiment.Grp8_CS80_ITI80)
TScombineover('Grp8_CS80_ITI80PstAcqRateDiffs','PostAcqMnRateDiff')

TSlimit('Subjects',Experiment.Grp32_CS80_ITI20)
TScombineover('Grp32_CS80_ITI20PstAcqRateDiffs','PostAcqMnRateDiff')

TSlimit('Subjects',Experiment.Grp32_CS160_ITI20)
TScombineover('Grp32_CS160_ITI20PstAcqRateDiffs','PostAcqMnRateDiff')

TSlimit('Subjects',Experiment.Grp64_CS80_ITI10)
TScombineover('Grp64_CS80_ITI10PstAcqRateDiffs','PostAcqMnRateDiff')

% Post- Pre- Acquisition mean poke rate differences for CS and ITI
TSlimit('Subjects','all')
TSapplystat({'CSpreAcqPstAcqPkRateDiff' 'ITIpreAcqPstAcqPkRateDiff'},...
    {'AllCSPkRates' 'AllITIPkRates' 'SimpleAcqPt'},@PrePostDiffs)
%{
function [CSdiff,ITIdiff]=PrePostDiffs(CSrates,ITIrates,AcqPt)
CSdiff=[];ITIdiff=[];
if AcqPt<1500
    CSdiff = mean(CSrates(AcqPt:end)) - mean(CSrates(1:AcqPt-1));
    ITIdiff = mean(ITIrates(AcqPt:end)) - mean(ITIrates(1:AcqPt-1));
end    
%}
% Aggregating to groups at Experiment level
TSlimit('Subjects',Experiment.Grp8_CS80_ITI80)
TScombineover('G8_80_80PrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('G8_80_80PrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')
%
TSlimit('Subjects',Experiment.Grp32_CS80_ITI20)
TScombineover('G32_80_20PrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('G32_80_20PrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')

TSlimit('Subjects',Experiment.Grp32_CS160_ITI20)
TScombineover('G32_160_20PrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('G32_160_20PrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')

TSlimit('Subjects',Experiment.Grp64_CS80_ITI10)
TScombineover('G64_80_10PrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('G64_80_10PrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')


% Distributions of the pre- and post-acq poke rate differences
CSdiffs=[Experiment.G8_80_80PrePstCSpkRateDiffs;Experiment.G32_80_20PrePstCSpkRateDiffs;...
    Experiment.G32_160_20PrePstCSpkRateDiffs;Experiment.G64_80_10PrePstCSpkRateDiffs];
ITIdiffs=[Experiment.G8_80_80PrePstITIpkRateDiffs;Experiment.G32_80_20PrePstITIpkRateDiffs;...
    Experiment.G32_160_20PrePstITIpkRateDiffs;Experiment.G64_80_10PrePstITIpkRateDiffs];
%
figure
h1 = cdfplot(CSdiffs);
set(h1,'LineWidth',2,'LineStyle','--')
set(gca,'FontSize',14)
hold on
h2 = cdfplot(ITIdiffs);
set(h2,'LineWidth',2,'Color','k')
set(gca,'FontSize',14)
plot([0 0],ylim,'k:')
xlabel('mean(PostAcqRate) ? mean(PreAcqRate)','FontSize',18)
ylabel('Cumulative Fraction of Subjects','FontSize',18)
legend('CS','ITI','location','SE')
title('Experiment 6 ("Background")')

TSsaveexperiment

%% Informativeness
TSlimit('Subjects','all')
TSsettrialtype('ITI')
TScombineover('NumITIUSs_s','NumUSs') % to session level
TScombineover('ITITrialDurs','TrialDuration')  % to session level
TSapplystat('SessionDuration','TSData',@SesDur) % creates field at Session
% level giving session duration
TScombineover('NumITIUSs_S','NumITIUSs_s') % to subject level
TScombineover('SessionDurations','SessionDuration') % to subject level
TScombineover('ITITrialDurs_S','ITITrialDurs') % to subject level

% Computing Informativeness
TSapplystat('lambdaR_ITI',{'NumITIUSs_S' 'ITITrialDurs_S'},@Rate) %Subject level
% the rate during the ITI is the sum of the total # of USs during ITIs
% divided by the total ITI time
%{
function R = Rate(N,T)
R = sum(N)/sum(T);
end
%}
TSapplystat('lambdaR_C',{'NumITIUSs_S' 'SessionDurations'},@Rate) % Subject level
% The contextual rate is the total # of USs, which in this experiment is
% the total # of ITIUSs, because they only occurred during the ITIs,
% divided by the total session time
TSapplystat('CSoffInformativeness',{'lambdaR_ITI' 'lambdaR_C'},@rdivide) % Subject level
% The informativeness is the rate during the ITI divided by the contextual
% rate

% Aggregating Informativeness by Groups to Experiment level
TSlimit('Subjects',Experiment.Grp8_CS80_ITI80)
TScombineover('Grp8_CS80_ITI80Informativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.Grp32_CS80_ITI20)
TScombineover('Grp32_CS80_ITI20Informativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.Grp32_CS160_ITI20)
TScombineover('Grp32_CS160_ITI20Informativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.Grp64_CS80_ITI10)
TScombineover('Grp64_CS80_ITI10Informativeness','CSoffInformativeness')

%% Subject-by-Subject Within-CS, Post-Acq Poke Rate Profiles
TSlimit('Subjects','all')
TSsettrialtype('CS')
TScombineover('CSpkTms','Pktms','t') % to Session level
TScombineover('CSPkTms_S','CSpkTms','t') % to Subject level
TrlsPerSes = 32;
TSapplystat('CSPkTms_S','CSPkTms_S',@addCumTrlsCol,TrlsPerSes)
%{
function AugA = addCumTrlsCol(A,TrlsPerSes)
% adds column giving cumulative trials
A(:,end+1) = (A(:,3)-1)*TrlsPerSes+A(:,2);
AugA=A;
end
%}
TrlsPerSes = 32;
TSapplystat('CSPkTms_S','CSPkTms_S',@addCumTrlsCol,TrlsPerSes)
%{
function AugA = addCumTrlsCol(A,TrlsPerSes)
% adds column giving cumulative trials
A(:,end+1) = (A(:,3)-1)*TrlsPerSes+A(:,2);
AugA=A;
end
%}
%
NumBins = 10;
TSapplystat('PkRateProfileInCSpostAcq',{'CSPkTms_S' 'AllCSdurs' 'SimpleAcqPt'},...
    @Profile,NumBins)
%{
function O = Profile(Tms,durs,AcqTrl,nb)
% Tms is 4-col array w within-CS poke times in col 1, trial # in col 2,
% session # in col 3 and cumulative trial # in col 4
O = double.empty(0,nb); % initializing
TtlTrls = max(Tms(:,4));
if AcqTrl>TtlTrls
    return
end 
SecsPerBin = durs(1)/nb; % bin width in seconds
Edges = 0:SecsPerBin:nb*SecsPerBin; %
LV = Tms(:,4)>=AcqTrl; % flags post-acquisition trials
N = histc(Tms(LV,1),Edges); % pk counts in each bin
PstAcqTrls = TtlTrls - AcqTrl; % # of post-acq trials
O = N/(PstAcqTrls*SecsPerBin); % pokes/s in each bin
end
%}
TSsaveexperiment
%
% Graphing Subject-by-Subject Within-CS, Post-Acq Poke Frequency Profiles
G = {Experiment.Grp8_CS80_ITI80 Experiment.Grp32_CS80_ITI20 ...
    Experiment.Grp32_CS160_ITI20 Experiment.Grp64_CS80_ITI10};
Names ={'9-80-80' '32-80-20' '32-160-20' '64-80-10'};
Xlbl = {{'1' '40' '80'};{'1' '40' '80'};{'1' '80' '160'};{'1' '40' '80'}};
for g = 1:length(G)
    figure
    plt = 1;
    for S = G{g}
        subplot(4,2,plt)
        if isempty(Experiment.Subject(S).PkRateProfileInCSpostAcq)
            text(.4,.5,'Never Acquired')
            plt=plt+1;
            continue
        end
        subplot(4,2,plt)
            bar(Experiment.Subject(S).PkRateProfileInCSpostAcq(1:10),1)
            xlim([.5 10.5])
            title(['S' num2str(S)])
            set(gca,'XTick',[1 5 10],'XTickLabel',Xlbl{g})
            if plt>6
                xlabel('Time Elapsed in CS (s)')
            else
                xlabel('')
            end
            if mod(plt,2)>0
                ylabel('Pks/s')
            end
        plt=plt+1;
    end
    saveas(gcf,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 6' ...
        '/E6 PstAcqWIcsPkFreqProfile' Names{g} '.pdf'])
end

%% Aggregating Post-Acq CS Decile Profiles by Group to Experiment level
TSlimit('Subjects',Experiment.Grp8_CS80_ITI80)
    TScombineover('G8_80_80PstAcqPksPrSecByDecile','PkRateProfileInCSpostAcq','t') % 
    TSapplystat({'G8_80_80ProfileMean' 'G8_80_80ProfileSE'},'G8_80_80PstAcqPksPrSecByDecile',@ProfMean)
    %{
    function [M,SE] = ProfMean(A)
    % A is 2-col array with deciles repeated in 2nd colin
    A(A(:,1)==0,:)=[]; % deleting 11th bins (always 0)
    Ar = reshape(A(:,1),10,[]);
    M = mean(Ar,2);
    SE = std(Ar,0,2)/sqrt(size(Ar,2));
    %}
TSlimit('Subjects',Experiment.Grp32_CS80_ITI20)
    TScombineover('G32_80_20PstAcqPksPrSecByDecile','PkRateProfileInCSpostAcq','t')
    TSapplystat({'G32_80_20ProfileMean' 'G32_80_20ProfileSE'},'G32_80_20PstAcqPksPrSecByDecile',@ProfMean)
TSlimit('Subjects',Experiment.Grp32_CS160_ITI20)
    TScombineover('G32_160_20PstAcqPksPrSecByDecile','PkRateProfileInCSpostAcq','t')
    TSapplystat({'G32_160_20ProfileMean' 'G32_160_20ProfileSE'},'G32_160_20PstAcqPksPrSecByDecile',@ProfMean)
TSlimit('Subjects',Experiment.Grp64_CS80_ITI10)
    TScombineover('G64_80_10PstAcqPksPrSecByDecile','PkRateProfileInCSpostAcq','t')
    TSapplystat({'G64_80_10ProfileMean' 'G64_80_10ProfileSE'},'G64_80_10PstAcqPksPrSecByDecile',@ProfMean)

%% Errorbar Graphs of Group Within-CS Post-Acq Response Freq Profiles
Nms = {'1' '40' '80'};
figure
Ax1=subplot(2,2,1);
    TSapplystat('',{'G8_80_80ProfileMean' 'G8_80_80ProfileSE'},...
        @EB,Ax1,Nms)
    %{
    function EB(m,se,Ax,Nms)
    figure
    errorbar(Ax,1:10,m,se,se)
    set(gca,'XTick',[1 5 10],'XTickLabel',Nms)    
    %}
        title('8 ITI80, CS80','FontWeight','normal') 
Ax2=subplot(2,2,2);
    Nms = {'1' '40' '80'};
    TSapplystat('',{'G32_80_20ProfileMean' 'G32_80_20ProfileSE'},...
        @EB,Ax2,Nms)
    title('32 ITI20, CS80','FontWeight','normal') 

Ax3=subplot(2,2,3);
    Nms = {'1' '80' '160'};
    TSapplystat('',{'G32_160_20ProfileMean' 'G32_160_20ProfileSE'},...
        @EB,Ax3,Nms);xlabel('Elapsed CS Time (s)')
   title('32 ITI20, CS160','FontWeight','normal')  

Ax4=subplot(2,2,4);
    Nms = {'1' '40' '80'};
    TSapplystat('',{'G64_80_10ProfileMean' 'G64_80_10ProfileSE'},...
        @EB,Ax4,Nms);xlabel('Elapsed CS Time (s)')
    title('64 ITI10, CS80','FontWeight','normal') 


%% Cummulative USs at Acquisition
TSlimit('Subjects','all')
TSapplystat('USsAtAcquisition',{'AllITIUSs' 'SimpleAcqPt'},@USsAtAcq)
% field at Subject level giving the # of USs experience prior to acqusition
%{
function O = USsAtAcq(USs,ap)
O=[]; % initializing
CmUSs = cumsum(USs);
if ap<length(USs) % subject acquired
    O = CmUSs(ap);
end
%}
%
TSlimit('Subjects',Experiment.Grp8_CS80_ITI80)
    TScombineover('G8_80_80USsAtAcq','USsAtAcquisition')
TSlimit('Subjects',Experiment.Grp32_CS80_ITI20)
    TScombineover('G32_80_20USsAtAcq','USsAtAcquisition')
TSlimit('Subjects',Experiment.Grp32_CS160_ITI20)
    TScombineover('G32_160_20USsAtAcq','USsAtAcquisition')
TSlimit('Subjects',Experiment.Grp64_CS80_ITI10)
    TScombineover('G64_80_10USsAtAcq','USsAtAcquisition')    

%% Average # of USs per ITI
TSlimit('Subjects','all')
TSlimit('Phases',[11 21 31 41])
TSapplystat('USperITI',{'AllITIdurs' 'AllITIUSs'},@USsPerITI)

TSlimit('Subjects',Experiment.Grp8_CS80_ITI80)
    TScombineover('Grp8_CS80_ITI80USsPerITI','USperITI')
TSlimit('Subjects',Experiment.Grp32_CS80_ITI20)
    TScombineover('Grp32_CS80_ITI20USsPerITI','USperITI')
TSlimit('Subjects',Experiment.Grp32_CS160_ITI20)
    TScombineover('Grp32_CS160_ITI20USsPerITI','USperITI')
TSlimit('Subjects',Experiment.Grp64_CS80_ITI10)
    TScombineover('Grp64_CS80_ITI10USsPerITI','USperITI')

%% Subject level summary stats for assembly at Experiment level and export 
% to long table
TSlimit('Subjects','all')
E = 6; % Experiment #
TSapplystat({'SummaryArray' 'GroupName'},{'AllCSdurs' 'ITITrialDurs_S' 'NumITIUSs_S' 'SimpleAcqPt' ...
    'CSpreAcqPstAcqPkRateDiff' 'ITIpreAcqPstAcqPkRateDiff'},@SubSummary6,E)
%{
function [Sm,Gnm] = SubSummary6(CSdrs,ITIdrs,ITIUSs,AcqPt,CSprepst,ITIprepst,E)
% 24-column table: Sb# E, G#, Gname, Sidx, Cdr, ForV, Idr, USUS, Infrmtvn,
% N_U_S|CSoff, Product, ActTrl, RateDiff, Cd1,...,Cd10
global Experiment
Sm = nan(1,24); % initializing
Gnm=[];
Sm(1) = E; % experiment #
%% Group # and name
FN = fieldnames(Experiment); % cell array; the names of the groups begin
% w cell 14
r = 1;
G = cell(4,1);
for c = 15:18
    G{r} = FN{c}; % group names
    r = r+1;
end

if strcmp('G',FN{18}(1)) % there's a 5th group
    G{5} = FN{18};
end
%
Gidx = cell(length(G),1);
for c = 1:length(G) % group numerosities and idx #s of subject w/i group
    V = eval(['Experiment.' G{c} '''']); % Col vec of index numbers of
    % subjects in a group
    Gidx{c}=V;
end
% 
sb = evalin('caller','sub'); % subject index #
Sm(3) = sb;
for g = 1:length(Gidx)
    if ismember(sb,Gidx{g})
        Sm(2) = g; % group #
        Gnm = G{g}; % group name string
        break
    end
end
if isempty(Gnm) % this subject was not in any group
    Sm = double.empty(0,24);
    return
end
% At this point I have 1st 3 elements of the row vec
%%
Sm(4) = CSdrs(1); % CS duration was fixed for all groups
Sm(5) = 1;
Titi = sum(ITIdrs);
Niti = sum(ITIUSs);
Sm(6) = mean(ITIdrs); % average ITI duration
Sm(7) = Titi/Niti; % average US-US interval
Sm(8) = Sm(6)/Sm(7); % expected # of US in an ITI
Sm(9) = (Titi+sum(CSdrs))/Titi; % informativeness
Sm(10) = Sm(8)*Sm(9); % product of Informativeness of a CSoff & the expected
% # of USs during the ensuing ITI
Sm(11) = AcqPt;
if E<4 % mean post-acquisition ITI pk rate minus CS poke rate
    Sm(12) = Experiment.Subject(sb).MnPostAcqRateDiff;
else
    Sm(12) = Experiment.Subject(sb).PostAcqMnRateDiff;
end
if ~isempty(CSprepst)
    Sm(13) = CSprepst; % mean CS pk rate after acq - mean before acq
    Sm(14) = ITIprepst; % ditto fo ITI
    if E~=3
        Sm(15:24) = Experiment.Subject(sb).PkRateProfileInCSpostAcq(1:10);
    else
        Sm(15:24) = Experiment.Subject(sb).PstAcqPksPerSecInDeciles(1:10);
    end
end
%}
    
TScombineover('TableArray','SummaryArray') % raising summary vectors to an
% array at the Experiment level
%
TScombineover('GrpCharArray','GroupName','c')
%
TSapplystat('TableArray','TableArray',@sortrows,2) % sort array by group #

%% Putting explanatory text in ExpNotes field
Experiment.ExpNotes = char({'Design:'
    
    ' '
    'Analysis Notes:'
    'The function that estimates the acquisition point'
    'initializes the estimate to 1200, which is not a possible value,'
    'because there were not that many trials. This is done for graphic'
    'reasons (so that failures to acquire are evident in the plots of'
    'the cumulative distributions of trials to acquisition). When we'
    'compute median trials to acquisition for the 5 groups, we set'
    'medians of 1500 to nan'});

TSsaveexperiment