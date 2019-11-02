%This is the script for analyzing the Experiment 5 in the sequence of 6
%experiments on the acquisition of inhibition
%{
Design:
?? to be filled in
%}
%% Creating an Experiment structure
ExpName='/Users/galliste/Dropbox/InhibitoryExperiments_All/ExperimentStructures/InhibExper5_number';
TSinitexperiment(ExpName,1006,[209:232 701:732],'Rat','Balsam') % Creates an
% Experiment structure and fills in the following fields:
% Experiment.Name = /Users/galliste/Dropbox/InhibitoryExperiments_All/ExperimentStructures/InhibExper5_number;
% Experiment.ID = 1006;
% Experiment.Subjects = the row vector [209 210 211 ... 732]
% Experiment.Species = Rat
% Experiment.Lab = Balsam
% The TSinitexperiment function counts the number of elements in the vector
% of subject ID numbers and then fills in another field:
% Experiment.NumSubjects = 32

% Loading into the structure information necessary to the loading of data

TSsetloadparameters('InputTimeUnit',0.1,'OutputTimeUnit',1,'LoadFunction',...
'TSloadBalsamRaw6','FilePrefix','!','FileExtension','') % Put into the
% Experiment structure the information it needs to load raw data files,
% using Variable-Value pairs. The first variable-value pair specifies the
% time unit in seconds in the 1st column of the raw data, that is, the
% original time stamps. In these raw data, that unit is 1 because the raw
% time stamps are in seconds. If the raw time stamps were in 50ths of a
% second, that is, if the number 305 in the first column denoted a session
% time of 6.1 seconds, then we would assign the value .02 to this variable.
% The second variable-value pair specifies the time unit to be used within
% the Experiment struct. If one wants the time unit in time-stamped data
% arrays within the structure to be in seconds, as we do, then one assigns
% 1 to the variable 'OutputTimeUnit'. If we wanted these time stamps
% to be in minutes , then we would assign the value 60 to this variable.
% The third variable-value pair specifies the name of the load function.
% The load function understands the structure of your raw data files and
% extracts from that structure the information required by the
% TSloadsessions function. The last two variable-value pairs allow you to
% specify information about the data file names that will enable the load
% function to distinguish those files from other files (some of them likely
% hidden files!) within the same folder as the data files. In this case,
% all of our data files are named 'Rat###.txt'. Thus, we specify that the
% files to be loaded begin with '!' and have '' as their no-extension

%% Loading data
% The data to be loaded are in 2-col text files with the first 12 rows
% giving header information (Date, Subject ID, Phase, Box #, etc) and the
% remaining rows giving time-stamped numerically encoded events, with the
% time stamps in seconds in the first column and the numerical event codes
% in the second. The files are in folders named Day1, Day2, Day3, etc. The
% simplest way to load the data is to type at the command prompt:

% TSloadsessions
% This calls up a browser, which allows you to browse for one of the
% data-containing folder. When you have found that folder, select it and
% click the Open button. The data files in that folder will be loaded.
% There are, however, 35 such folders. It is tedious to call TSloadsessions
% 35 times, browsing on each occassion. We can automate this process with
% the following code after using Matlab's file browser to make the folder
% that contains the Day 1, Day 2, etc folders Matlab's Current Folder

%%
cd('C:\Users\pbalsam\Dropbox\Conditioned Inhibition\Rat CI\Pooled number inhibition\Data') % makes Data directory the current directory (Dr contains the complete path to Data directory)
for d = 1:24 % stepping through the Day subfolder
    FN = ['Day ' num2str(d)]; % constructing the name of the folder containing
    % the files we want to load
   
    TSloadsessions(FN) % calling TSloadsession to load the files in that directory
end
%%
%for d = 45:62 % stepping through the Day subfolder
%    FN = ['Ph 2 Day ' num2str(d)]; % constructing the name of the folder containing
    % the files we want to load
   
 %   TSloadsessions(FN) % calling TSloadsession to load the files in that directory
% end

%% Importing event codes into the Experiment structure and
% then "declaring" them
TSimporteventcodes
% This command opens a browsing window for you to find the text file that
% contains the event codes and their corresponding numbers.

%% Creating fields at the Experiment level that specify which subjects are
% in which groups (experimental conditions)

Experiment.GrpITI20_CS30 = [1 2 5 6 9 10 13 14 25 26 39 40]; % The group for 
% which the inhibitory CS lasted 30s. During the CSs no pellets were delivered.
% Pellets were delivered at random during the ITIs, which were on average
% 20s long

Experiment.GrpITI20_CS60 = [3 4 7 8 11 12 15 16 31 32 37 38]; % see above

Experiment.GrpITI80_CS30 = [27 28 33 34 43 44 47 48 49 50 53 54]; % see above

Experiment.GrpITI80_CS60 = [29 30 35 36 41 42 45 46 51 52 55 56]; % see above
% Subjects 17:24 are not included in these groups, because they were run
% with erroneous MedPC code

%% Defining CS trial type and computing basic statistics

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

% 
% Aggregating statistics from the CS trials into fields at the Session and
% Subject levels
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

%% Defining ITI trial type and computing basic statistics

TSdefinetrialtype('ITI',{[Sessionstart Toneon] [Toneoff Toneon]}) % the ITI
% trial type. When we define a new trial type, it becomes the active trial
% type. Thus, the commands that follow will use that trial type rather than
% the CS trial type used by the preceding suite of commands. This trial
% type is the interval before each CS. Notice that two different event
% vectors are needed to define that interval. The first vector,
% [Sessionstart ToneOn] picks out the interval before the first CS; the 2nd
% vector, [ToneOff ToneOn], picks out the intervals between subsequent CSs

TStrialstat('UStms',@TSparse,'result=time(1)-starttime;',Pelletdelivered)
% Finds all of the instances of the ITI trial type and computes
% the times within each ITI trial (measured from beginning of trial) at
% which a pellet was delivered. This creates a field at the Trial level
% under the ITI trial type named UStms, in which it stores these times.
%
TStrialstat('PkTms',@TSparse,'result=[time(1)-starttime time(1)-endtime];',Pokestart)
% Creates a 2-column field named PkTms at the Trial level under the ITI
% trial type. First column is the latency from onset of ITI to the poke;
% 2nd column is the negatively signed interval from the poke to the end of
% the ITI, that is, the interval by which the poke preceded the onset of
% the CS
%
TSapplystat('NumUSs','UStms',@numel) % Creates a field named
% NumUSs at the Trial level under the ITI trial type, into which it puts 
% the  number of USs (pellet delivered) during the ITI
%
TSapplystat('NumPks','PkTms',@size,1) % Creates
% a field named 'NumPks' at the Trial level under the ITI trial type, into
% which it puts the number of rows in the PkTms field of the same trial
%
TSapplystat('PkRate',{'NumPks' 'TrialDuration'},@rdivide) % Takes the
% datum (number) in the NumPks field and the datum (number) in the
% TrialDuration field, divides the former by the latter to produce the rate
% of poking during a ITI, and puts the rate into a field  named PkRate,
% which it creates at the Trial level under the ITI trial type

%% Aggregating ststistics from the ITI trials into fields at the Session and
% Subject levels
%
TScombineover('ITIPkRates','PkRate') % Aggregates the data in the PkRate fields
% at the Trial level under the ITI trial type into a single field at the
% Session level, to which it assigns the name CSPkRates
%
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

%
TScombineover('AllITIPkRates','ITIPkRates') % Aggregates the vector of ITI poke
% rates in the ITIPkRates fields at the Session level into a field at the
% Subject level, to which it assigns the name AllITIPkRates
%
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

% Computing trial-by-trial CS-ITI poke rate differences (CS poke rate on
% each trial minus the poke rate during the preceding ITI)

TSapplystat('ITI_CSpkRateDiffs',{'ITIPkRates' 'CSPkRates'},@minus) % session level

TSapplystat('CS_ITIrateDiffs',{'AllCSPkRates' 'AllITIPkRates'},@minus) % subject level
% Computes the trial-by-trial differences in the rate of poking during the
% CS and during the ITI that precedes the CS and puts the resulting vector
% of rate differences in a field at the Subject level, to which it assigns
% the name CS_ITIrateDiffs. The poke rates during the CS trials are in the
% AllCSPkRates field; the poke rates during the preceding ITIs are in the
% AllITIPkRates field. The helper function is Matlab's minus functions,
% which subtracts each element in one vector from the corresponding element
% in the other vector, provided, of course, that the two vectors have the
% same number of elements


%% Session level mean CS pk rate, ITI pk rate and CS-ITI pk rate differences
TSlimit('Subjects',[Experiment.GrpITI20_CS30 Experiment.GrpITI20_CS60 ...
    Experiment.GrpITI80_CS30 Experiment.GrpITI80_CS60])

TSapplystat('MeanCSPkRate','CSPkRates',@mean) % Session level scalar
TScombineover('CSPkRateMeans','MeanCSPkRate') % Subject level col vec
TSapplystat('CSPkRateMeans','CSPkRateMeans',@transpose) % convert to row vec

TSapplystat('MeanITIPkRate','ITIPkRates',@mean) % Session level
TScombineover('ITIPkRateMeans','MeanITIPkRate') % Subject level col vec
TSapplystat('ITIPkRateMeans','ITIPkRateMeans',@transpose) % convert to row vec
%
TSapplystat('MeanITI_CS_PkRateDiff','ITI_CSpkRateDiffs',@mean) % Session level scalar
TScombineover('ITI_CS_PkRateDiffMeans','MeanITI_CS_PkRateDiff') % Subject level col vec
TSapplystat('ITI_CS_PkRateDiffMeans','ITI_CS_PkRateDiffMeans',@transpose) % convert to row vec

% Filling in NaNs for missing sessions
subs=[Experiment.GrpITI20_CS30 Experiment.GrpITI20_CS60 ...
    Experiment.GrpITI80_CS30 Experiment.GrpITI80_CS60];
Not24=double.empty(0,2);
for S=subs
    if Experiment.Subject(S).NumSessions<24
        Not24(end+1,:) = [S Experiment.Subject(S).NumSessions];
    end
end

for S = Not24(:,1)'
        Experiment.Subject(S).CSPkRateMeans(end+1:24)=nan;
        Experiment.Subject(S).ITIPkRateMeans(end+1:24)=nan;
end
%
for S = Not24(:,1)'
        Experiment.Subject(S).ITI_CS_PkRateDiffMeans(end+1:24)=nan;
end
%% Aggregating session by session mean CS, ITI poke and ITI-CS Poke Rates
%  by group at Experiment level
TSlimit('Subjects',Experiment.GrpITI20_CS30)
TScombineover('GrpITI20_CS30_CSPkRateSesMeans','CSPkRateMeans')
TScombineover('GrpITI20_CS30_ITIPkRateSesMeans','ITIPkRateMeans')
TScombineover('GrpITI20_CS30_ITI_CSrateDiffs','ITI_CS_PkRateDiffMeans')
%
TSlimit('Subjects',Experiment.GrpITI20_CS60)
TScombineover('GrpITI20_CS60_CSPkRateSesMeans','CSPkRateMeans')
TScombineover('GrpITI20_CS60_ITIPkRateSesMeans','ITIPkRateMeans')
TScombineover('GrpITI20_CS60_ITI_CSrateDiffs','ITI_CS_PkRateDiffMeans')
%
TSlimit('Subjects',Experiment.GrpITI80_CS30)
TScombineover('GrpITI80_CS30_CSPkRateSesMeans','CSPkRateMeans')
TScombineover('GrpITI80_CS30_ITIPkRateSesMeans','ITIPkRateMeans')
TScombineover('GrpITI80_CS30_ITI_CSrateDiffs','ITI_CS_PkRateDiffMeans')

TSlimit('Subjects',Experiment.GrpITI80_CS60)
TScombineover('GrpITI80_CS60_CSPkRateSesMeans','CSPkRateMeans')
TScombineover('GrpITI80_CS60_ITIPkRateSesMeans','ITIPkRateMeans')
TScombineover('GrpITI80_CS60_ITI_CSrateDiffs','ITI_CS_PkRateDiffMeans')

%% Graphing Session-by-Session CS, ITI & Diff Poke Rate Means by Group
Hanova = figure;
subplot(2,2,1)
plot(mean(Experiment.GrpITI20_CS30_CSPkRateSesMeans),'k-')
hold on
plot(mean(Experiment.GrpITI20_CS60_CSPkRateSesMeans),'k--')
plot(mean(Experiment.GrpITI80_CS30_CSPkRateSesMeans),'k-.')
plot(nanmean(Experiment.GrpITI80_CS60_CSPkRateSesMeans),'k:')
ylim([0 .5]);xlim([0 25])
xlabel('Session')
ylabel('CS Pokes/s')
legend('20-30','20-60','80-30','80-60','location','NW')

subplot(2,2,2)
plot(mean(Experiment.GrpITI20_CS30_ITIPkRateSesMeans),'k-')
hold on
plot(mean(Experiment.GrpITI20_CS60_ITIPkRateSesMeans),'k--')
plot(mean(Experiment.GrpITI80_CS30_ITIPkRateSesMeans),'k-.')
plot(nanmean(Experiment.GrpITI80_CS60_ITIPkRateSesMeans),'k:')
ylim([0 .5]);xlim([0 25])
xlabel('Session')
ylabel('ITI Pokes/s')

subplot(2,2,4)
plot(mean(Experiment.GrpITI20_CS30_ITI_CSrateDiffs),'k-')
hold on
plot(mean(Experiment.GrpITI20_CS60_ITI_CSrateDiffs),'k--')
plot(mean(Experiment.GrpITI80_CS30_ITI_CSrateDiffs),'k-.')
plot(nanmean(Experiment.GrpITI80_CS60_ITI_CSrateDiffs),'k:')
ylim([-.1 .4]);xlim([0 25])
xlabel('Session')
ylabel('ITI-CS Pokes/s')
subplot(2,2,3); % The p values, which are obtained from the ANOVAs,
% will be written into this lower left panel
set(gca,'XTick',[],'YTick',[])
set(Hanova,'Name','E5 ANOVA','Position',[1105.00 1128.00 573.00 742.00]);

%% Building Arrays for ANOVAs
% Reconfiguring fields with mean poke rates by session for subjects in a
% given group

%For CS ANOVA
TSapplystat('GrpITI20_CS30_CSPkRateSesMeans',...
    {'GrpITI20_CS30_CSPkRateSesMeans' 'GrpITI20_CS30'},...
    @AddCSandITIdurs,[1 1]) % removes sessions after 18; reshapes mean poke
    % rates into column vector; adds session, subject, ITIdur and CSdur
    % columns
    %{
    function Aout = AddCSandITIdurs(Ain,Sids,rv)
    % Ain has row for each subject and column for each session. However, there
    % are only 18 sessions for some subjects
    Ain(:,19:end) = []; % getting rid of sessions after 18
    Aout = reshape(Ain,[],1); % col vec w mean poke rates
    Aout(:,2) = repmat((1:18)',length(Sids),1); % col for session
    Aout(:,3) = reshape(repmat(Sids,18,1),[],1); % col for Subject
    % 1st element of rv indicates ITI dur (1=20, 2=80); 2nd element indicates
    % CS dur (1=30, 2=60)
    Aout = [Aout repmat(rv,length(Aout),1)];
    end
    %}
%
TSapplystat('GrpITI20_CS60_CSPkRateSesMeans',...
    {'GrpITI20_CS60_CSPkRateSesMeans' 'GrpITI20_CS60'},...
    @AddCSandITIdurs,[1 2]) % ditto

TSapplystat('GrpITI80_CS30_CSPkRateSesMeans',...
    {'GrpITI80_CS30_CSPkRateSesMeans' 'GrpITI80_CS30'},...
    @AddCSandITIdurs,[2 1]) % ditto

TSapplystat('GrpITI80_CS60_CSPkRateSesMeans',...
    {'GrpITI80_CS60_CSPkRateSesMeans' 'GrpITI80_CS60'},...
    @AddCSandITIdurs,[2 2]) % ditto
% The above arrays have 5 columns: Col 1 gives poke rates; Cols 2:5 give
% the factors: Session, Subject, ITIdur (1 or 2), and CSdur (1 or 2)


% For ITI ANOVA
TSapplystat('GrpITI20_CS30_ITIPkRateSesMeans',...
    {'GrpITI20_CS30_ITIPkRateSesMeans' 'GrpITI20_CS30'},...
    @AddCSandITIdurs,[1 1]) % removes sessions after 18; reshapes mean poke
    % rates into column vector; adds session, subject, ITIdur and CSdur
    % columns
    %{
    function Aout = AddCSandITIdurs(Ain,Sids,rv)
    % Ain has row for each subject and column for each session. However, there
    % are only 18 sessions for some subjects
    Ain(:,19:end) = []; % getting rid of sessions after 18
    Aout = reshape(Ain,[],1); % col vec w mean poke rates
    Aout(:,2) = repmat((1:18)',length(Sids),1); % col for session
    Aout(:,3) = reshape(repmat(Sids,18,1),[],1); % col for Subject
    % 1st element of rv indicates ITI dur (1=20, 2=80); 2nd element indicates
    % CS dur (1=30, 2=60)
    Aout = [Aout repmat(rv,length(Aout),1)];
    end
    %}
%
TSapplystat('GrpITI20_CS60_ITIPkRateSesMeans',...
    {'GrpITI20_CS60_ITIPkRateSesMeans' 'GrpITI20_CS60'},...
    @AddCSandITIdurs,[1 2]) % ditto

TSapplystat('GrpITI80_CS30_ITIPkRateSesMeans',...
    {'GrpITI80_CS30_ITIPkRateSesMeans' 'GrpITI80_CS30'},...
    @AddCSandITIdurs,[2 1]) % ditto

TSapplystat('GrpITI80_CS60_ITIPkRateSesMeans',...
    {'GrpITI80_CS60_ITIPkRateSesMeans' 'GrpITI80_CS60'},...
    @AddCSandITIdurs,[2 2]) % ditto
% The above arrays have 5 columns: Col 1 gives poke rates; Cols 2:5 give
% the factors: Session, Subject, ITIdur (1 or 2), and CSdur (1 or 2)


% For ITI-CS ANOVA
% Reconfiguring fields with mean poke rates by session for subjects in a
% given group
TSapplystat('GrpITI20_CS30_ITI_CSrateDiffs',...
    {'GrpITI20_CS30_ITI_CSrateDiffs' 'GrpITI20_CS30'},...
    @AddCSandITIdurs,[1 1]) % removes sessions after 18; reshapes mean poke
    % rates into column vector; adds session, subject, ITIdur and CSdur
    % columns
    %{
    function Aout = AddCSandITIdurs(Ain,Sids,rv)
    % Ain has row for each subject and column for each session. However, there
    % are only 18 sessions for some subjects
    Ain(:,19:end) = []; % getting rid of sessions after 18
    Aout = reshape(Ain,[],1); % col vec w mean poke rates
    Aout(:,2) = repmat((1:18)',length(Sids),1); % col for session
    Aout(:,3) = reshape(repmat(Sids,18,1),[],1); % col for Subject
    % 1st element of rv indicates ITI dur (1=20, 2=80); 2nd element indicates
    % CS dur (1=30, 2=60)
    Aout = [Aout repmat(rv,length(Aout),1)];
    end
    %}
%
TSapplystat('GrpITI20_CS60_ITI_CSrateDiffs',...
    {'GrpITI20_CS60_ITI_CSrateDiffs' 'GrpITI20_CS60'},...
    @AddCSandITIdurs,[1 2]) % ditto

TSapplystat('GrpITI80_CS30_ITI_CSrateDiffs',...
    {'GrpITI80_CS30_ITI_CSrateDiffs' 'GrpITI80_CS30'},...
    @AddCSandITIdurs,[2 1]) % ditto

TSapplystat('GrpITI80_CS60_ITI_CSrateDiffs',...
    {'GrpITI80_CS60_ITI_CSrateDiffs' 'GrpITI80_CS60'},...
    @AddCSandITIdurs,[2 2]) % ditto
% The above arrays have 5 columns: Col 1 gives poke rates; Cols 2:5 give
% the factors: Session, Subject, ITIdur (1 or 2), and CSdur (1 or 2)

%% CS ANOVA
% Creating array to be fed to CS ANOVA 
TSapplystat('CSpkRateByDayByGroup',{'GrpITI20_CS30_CSPkRateSesMeans' ...
    'GrpITI20_CS60_CSPkRateSesMeans' 'GrpITI80_CS30_CSPkRateSesMeans' ...
    'GrpITI80_CS60_CSPkRateSesMeans'},@vertcat)
% Creates CSpkRateByDayByGroup at Experiment level: a 5-col array; Col 1
% gives poke rates; Cols 2:5 give the factors: Session, Subject,
% CSdur (1 or 2), and FixVsVar(1 or 2)
% 
% Col 1 is the data; remaining columns are the factors:
VarNames = {'Session';'Subject';'ITIdur';'CSdur'};
% Subject is nested within group, so:
NestMatrx = [0 0 0 0;0 0 1 1;0 0 0 0;0 0 0 0]; % subject is nested within
% Group and FixVar
% Subject (the 2nd factor) is a random factor, so
rnd = 2;
% The model type is 'interaction' (only the 2-way interactions), so:
mdl = 'interaction';
% I assume we should use the type 3 sum of squares (the default)
TSapplystat('CSpkRateBySesByGrpANOVApVals','CSpkRateByDayByGroup',...
    @GroupBySesANOVA5,mdl,NestMatrx,rnd,VarNames)
% Field PkRateDiffBySesByGrpANOVApVals at Experiment level with table of p
% values
%{
function ptbl = GroupBySesANOVA5(A,mdl,nst,rnd,vars)
p = anovan(A(:,1),{(A(:,2)) (A(:,3)) (A(:,4)) (A(:,5))},...
    'model',mdl,'nested',nst,'random',rnd,'varnames',vars) 
%
if p(1)<.001
    Pca{1} = 'Session p<.001';
else
    Pca{1} = ['Session p=' num2str(p(1),3)];
end
if p(2)<.001
    Pca{2} = 'Subject(Group) p<.001';
else
    Pca{2} = ['Subject(Group) p=' num2str(p(2),3)];
end
if p(3)<.001
    Pca{3} = 'ITIdur p<.001';
else
    Pca{3} = ['ITIdur p=' num2str(p(3),3)];
end
if p(4)<.001
    Pca{4} = 'CSdur p<.001';
else
    Pca{4} = ['CSdur p=' num2str(p(4),3)];
end
if p(6)<.001
    Pca{5} = 'SessionxITIdur p<.001';
else
    Pca{5} = ['SessionxITIdur p=' num2str(p(6),3)];
end
if p(7)<.001
    Pca{6} = 'SessionxCSdur p<.001';
else
    Pca{6} = ['SessionxCSdur p=' num2str(p(7),3)];
end
if p(8)<.001
    Pca{7} = 'ITIdurxCSdur p<.001';
else
    Pca{7} = ['ITIdurxCSdur p=' num2str(p(8),3)];
end
ptbl = char(Pca) 

  Source                          Sum Sq.   d.f.   Mean Sq.     F     Prob>F
----------------------------------------------------------------------------
  Session                         0.45101    17    0.02653     4.24   0     
  Subject(ITIdur,CSdur)           0.44752    44    0.01017     1.63   0.0072
  ITIdur                          0.39541     1    0.39541    38.88   0     
  CSdur                           0.22858     1    0.22858    22.47   0     
  Session*Subject(ITIdur,CSdur)   4.7864    765    0.00626      Inf      NaN
  Session*ITIdur                  0.58694    17    0.03453     5.52   0     
  Session*CSdur                   0.23345    17    0.01373     2.19   0.0036
  ITIdur*CSdur                    0.00667     1    0.00667     0.66   0.4225
  Error                           0           0    0                        
  Total                           7.13598   863                             
%}
 

%% ITI ANOVA 
TSapplystat('ITIpkRateByDayByGroup',{'GrpITI20_CS30_ITIPkRateSesMeans' ...
    'GrpITI20_CS60_ITIPkRateSesMeans' 'GrpITI80_CS30_ITIPkRateSesMeans' ...
    'GrpITI80_CS60_ITIPkRateSesMeans'},@vertcat)
% Creates CSpkRateByDayByGroup at Experiment level: a 5-col array; Col 1
% gives poke rates; Cols 2:5 give the factors: Session, Subject,
% CSdur (1 or 2), and FixVsVar(1 or 2)

% Col 1 is the data; remaining columns are the factors:
VarNames = {'Session';'Subject';'ITIdur';'CSdur'};
% Subject is nested within group, so:
NestMatrx = [0 0 0 0;0 0 1 1;0 0 0 0;0 0 0 0]; % subject is nested within
% Group and FixVar
% Subject (the 2nd factor) is a random factor, so
rnd = 2;
% The model type is 'interaction' (only the 2-way interactions), so:
mdl = 'interaction';
% I assume we should use the type 3 sum of squares (the default)
TSapplystat('ITIpkRateBySesByGrpANOVApVals','ITIpkRateByDayByGroup',...
    @GroupBySesANOVA5,mdl,NestMatrx,rnd,VarNames)
%{
  Source                          Sum Sq.   d.f.   Mean Sq.     F     Prob>F
----------------------------------------------------------------------------
  Session                          1.4028    17     0.08252    6.1    0     
  Subject(ITIdur,CSdur)            3.6517    44     0.08299    6.14   0     
  ITIdur                           1.9839     1     1.98392   23.9    0     
  CSdur                            0.4068     1     0.40683    4.9    0.0321
  Session*Subject(ITIdur,CSdur)   10.3435   765     0.01352     Inf      NaN
  Session*ITIdur                   1.5777    17     0.09281    6.86   0     
  Session*CSdur                    0.7209    17     0.0424     3.14   0     
  ITIdur*CSdur                     0.0923     1     0.09227    1.11   0.2974
  Error                           -0          0    -0                       
  Total                           20.1796   863                             
%}
    
%% ITI-CS Rate Difference ANOVA
% Creating array to be fed to CS ANOVA 
TSapplystat('ITI_CSpkRateDiffByDayByGroup',{'GrpITI20_CS30_ITI_CSrateDiffs' ...
    'GrpITI20_CS60_ITI_CSrateDiffs' 'GrpITI80_CS30_ITI_CSrateDiffs' ...
    'GrpITI80_CS60_ITI_CSrateDiffs'},@vertcat)
% Creates CSpkRateByDayByGroup at Experiment level: a 5-col array; Col 1
% gives poke rates; Cols 2:5 give the factors: Session, Subject,
% CSdur (1 or 2), and FixVsVar(1 or 2)
% ITI_CS Rate Difference By Session ANOVA
% Col 1 is the data; remaining columns are the factors:
VarNames = {'Session';'Subject';'ITIdur';'CSdur'};
% Subject is nested within group, so:
NestMatrx = [0 0 0 0;0 0 1 1;0 0 0 0;0 0 0 0]; % subject is nested within
% Group and FixVar
% Subject (the 2nd factor) is a random factor, so
rnd = 2;
% The model type is 'interaction' (only the 2-way interactions), so:
mdl = 'interaction';
% I assume we should use the type 3 sum of squares (the default)
TSapplystat('ITI_CSpkRateDiffBySesByGrpANOVApVals','ITI_CSpkRateDiffByDayByGroup',...
    @GroupBySesANOVA5,mdl,NestMatrx,rnd,VarNames)
% Field PkRateDiffBySesByGrpANOVApVals at Experiment level with table of p
% values
%{


  Source                          Sum Sq.    d.f.   Mean Sq.     F     Prob>F
-----------------------------------------------------------------------------
  Session                          0.36791    17     0.02164    4.62   0     
  Subject(ITIdur,CSdur)            2.81121    44     0.06389   13.63   0     
  ITIdur                           0.60794     1     0.60794    9.52   0.0035
  CSdur                            1.24529     1     1.24529   19.49   0.0001
  Session*Subject(ITIdur,CSdur)    3.58707   765     0.00469     Inf      NaN
  Session*ITIdur                   0.29046    17     0.01709    3.64   0     
  Session*CSdur                    0.26689    17     0.0157     3.35   0     
  ITIdur*CSdur                     0.14854     1     0.14854    2.32   0.1345
  Error                           -0           0    -0                       
  Total                            9.32532   863                             
%}

%% Putting p values on the ANOVA plots
figure(Hanova)
subplot(2,2,3) % activating lower left subplot
ptxts = Experiment.CSpkRateBySesByGrpANOVApVals;
text(.01,.75,{'CS ANOVA';['   p_s_e_s' ptxts(1,9:end)];['   p_I_T_I_d_r' ptxts(3,9:end)];...
    ['   p_C_S_d_r' ptxts(4,8:end)];['   p_s_*_I_T_I_d_r' ptxts(5,17:end)];...
    ['   p_s_*_C_S_d_r' ptxts(6,15:end)];['   p_I_T_d_r_*_C_S_d_r' ptxts(7,15:end)]},'FontSize',12)

ptxts = Experiment.ITIpkRateBySesByGrpANOVApVals;
text(.55,.75,{'ITI ANOVA';['   p_s_e_s' ptxts(1,9:end)];['   p_I_T_I_d_r' ptxts(3,9:end)];...
    ['   p_C_S_d_r' ptxts(4,8:end)];['   p_s_*_I_T_I_d_r' ptxts(5,17:end)];...
    ['   p_s_*_C_S_d_r' ptxts(6,15:end)];['   p_I_T_d_r_*_C_S_d_r' ptxts(7,15:end)]},'FontSize',12)
%
ptxts = Experiment.ITI_CSpkRateDiffBySesByGrpANOVApVals;
text(.3,.25,{'ITI-CS ANOVA';['   p_s_e_s' ptxts(1,9:end)];['   p_I_T_I_d_r' ptxts(3,9:end)];...
    ['   p_C_S_d_r' ptxts(4,8:end)];['   p_s_*_I_T_I_d_r' ptxts(5,17:end)];...
    ['   p_s_*_C_S_d_r' ptxts(6,15:end)];['   p_I_T_d_r_*_C_S_d_r' ptxts(7,15:end)]},'FontSize',12)

saveas(Hanova,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 5/' ...
    get(Hanova,'Name') '.pdf']);

TSsaveexperiment
%% CSoff Informativeness
TSlimit('Subjects','all')
TSsettrialtype('ITI')
TScombineover('NumITIUSs_s','NumUSs') % to session level
TScombineover('ITITrialDurs','TrialDuration')  % to session level
TSapplystat('SessionDuration','TSData',@SesDur) % creates field at Session
% level giving session duration
TScombineover('NumITIUSs_S','NumITIUSs_s') % to subject level
TScombineover('SessionDurations','SessionDuration') % to subject level
TScombineover('ITITrialDurs_S','ITITrialDurs') % to subject level

% Computing Informativeness & Aggregating by Groups to Experiment level
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
%
% Aggregating Informativeness by Groups to Experiment level
TSlimit('Subjects',Experiment.GrpITI20_CS30)
TScombineover('GrpITI20_CS30Informativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.GrpITI20_CS60)
TScombineover('GrpITI20_CS60Informativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.GrpITI80_CS30)
TScombineover('GrpITI80_CS30Informativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.GrpITI80_CS60)
TScombineover('GrpITI80_CS60Informativeness','CSoffInformativeness')
TSsaveexperiment

%% Computing Trials to Acquisition
% We define the acquisition point to be the point at
% which the cumulative record of rate differences is down by dwn from its
% maximum value and that the final level is below that level by at least
% dwn (that is, provided the cumulative record continues to fall after
% dropping below the threshold for "acquisition"), and, finally, that it
% finished at least 2* dwn below 0
TSlimit('Subjects','all')
dwn = 5; % how far cum record has to fall from its maximum
TSapplystat('AcqPt','CS_ITIrateDiffs',@SimpleAcqPt,dwn)
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
% Aggregating acquisition points by group at Experiment level
TSlimit('Subjects',Experiment.GrpITI20_CS30)
TScombineover('GrpITI20_CS30_AcqPts','AcqPt')

TSlimit('Subjects',Experiment.GrpITI20_CS60)
TScombineover('GrpITI20_CS60_AcqPts','AcqPt')

TSlimit('Subjects',Experiment.GrpITI80_CS30)
TScombineover('GrpITI80_CS30_AcqPts','AcqPt')

TSlimit('Subjects',Experiment.GrpITI80_CS60)
TScombineover('GrpITI80_CS60_AcqPts','AcqPt')
TSsaveexperiment

%% 2-Way ANOVA on acquisition points
TSapplystat('AcqPt_2wqy_ANOVA',{'GrpITI20_CS30_AcqPts' 'GrpITI20_CS60_AcqPts' ...
   'GrpITI80_CS30_AcqPts' 'GrpITI80_CS60_AcqPts'},@tfa2)
% Creates 3-element row vector at Experiment level giving p values from a
% 2-way balanced ANOVA. The first p is for the column factor, which is the
% ITI duration factor, the second p is for the row factor, which is the CS
% duration factor, and the third is for the interaction
%{
function P2 = tfa2(V1,V2,V3,V4)
A = [[V1;V2] [V3;V4]]; % 2-col array; ITI varies between columns
P2=anova2(A,length(V1)) % the 2nd arguments specifies the n per cell;
% it subdivides the rows into two equinumerous "cells" per column; thus, it
% is the CS duration that is the row factor. Therefore, Cell(1,1) of the
% ANOVA contains the data in A(1:12,1); Cell(1,2) contains the data in
% A(1:12,2); Cell(2,1) contains the data in A(13:24,1); Cell(2,2) contains
% the data in A(13:24,2). The ITI duration varies between the columns and the
% CS duration varies between rows 1:12 and rows 13:24. Therefore in the ANOVA
% table, the Column factor is the ITI duration and the Row factor is the CS
% duration
%}
Experiment.ANOVAheadings='ITIdur CSdur Interaction'

%{
Source           SS       df      MS       F     Prob>F
-------------------------------------------------------
Columns         27265.3    1    27265.3   0.71   0.4031
Rows           177390.1    1   177390.1   4.64   0.0368
Interaction     27552.1    1    27552.1   0.72   0.4007
Error         1683131.2   44    38253                  
Total         1915338.7   47                           
%}

%% Cumulative distributions of acquisition points and of post-acqusition
% CS-ITI rate differences

TSapplystat('',{'GrpITI20_CS30_AcqPts' 'GrpITI20_CS60_AcqPts' ...
    'GrpITI80_CS30_AcqPts' 'GrpITI80_CS60_AcqPts'},@TSplotcdfs,...
    'Rows',1,'Cols',1,'Xlbl','Acquisition Trial','Xlm',[0 600],'Xlbl','Trials To Acquisition')
set(gca,'FontSize',14)
legend('ITI20-CS30','ITI20-CS60','ITI80-CS30','ITI80-CS60','location','SE')
set(gcf,'Position',[718.00 1146.00 344.00 253.00])
saveas(gcf,...
    '/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 5/E5 CDFsTrlsToAcq.pdf')
    
%% Median Acquisition Trials by Group
TSapplystat('MedianTrlsToAcq',...
    {'GrpITI20_CS30_AcqPts' 'GrpITI20_CS60_AcqPts' 'GrpITI80_CS30_AcqPts' ...
    'GrpITI80_CS60_AcqPts'},@AcqMedians)
%{
function AM = AcqMedians(D1,D2,D3,D4)
AM(:,1) = [2030;2060;8030;8060]; % exprimental groups
AM(:,2) = median([D1 D2 D3 D4])';
AM(AM(:,2)==1500,2) = nan; % median = 1500, which is impossible. This arises
% because we initialized estimated acquisition points to 1500 for graphic
% reasons (so that failures to acquire were evident in cumulative
% distributions of acquisition points). NB, the artificial limit WAS 1200;
   later changed to 1500; not sure if this rerun after this change was made
    CRG 1/27/17
%}


%% Post Acquisition CS-ITI Response Rate Diffs
TSlimit('Subjects','all')
TSapplystat('PostAcqMnRateDiff',{'CS_ITIrateDiffs' 'AcqPt'},@PostAcqMnRateDiff)
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

% Aggregating post acquisition mean CS-ITI rate differences

TSlimit('Subjects',Experiment.GrpITI20_CS30)
TScombineover('GrpITI20_CS30PstAcqRateDiffs','PostAcqMnRateDiff')

TSlimit('Subjects',Experiment.GrpITI20_CS60)
TScombineover('GrpITI20_CS60PstAcqRateDiffs','PostAcqMnRateDiff')

TSlimit('Subjects',Experiment.GrpITI80_CS30)
TScombineover('GrpITI80_CS30PstAcqRateDiffs','PostAcqMnRateDiff')

TSlimit('Subjects',Experiment.GrpITI80_CS60)
TScombineover('GrpITI80_CS60PstAcqRateDiffs','PostAcqMnRateDiff')
%
TSapplystat('',{'GrpITI20_CS30PstAcqRateDiffs' 'GrpITI20_CS60PstAcqRateDiffs' ...
    'GrpITI80_CS30PstAcqRateDiffs' 'GrpITI80_CS60PstAcqRateDiffs'},...
    @TSplotcdfs,'Rows',1,'Cols',1,'Xlbl','CS-ITI Pks/s Post Acquisition')
legend('20-30','20-60','80-30','80-60','location','NW')
set(gcf,'Position',[787.00 1568.00 313.00 236.00])
saveas(gcf,...
    '/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 5/E5 PstAcqCS-ITIpkRateDiff.pdf')

%% Post- Pre- Acquisition Mean Poke Rate Differences for CS and ITI
TSlimit('Subjects','all')
TSapplystat({'CSpreAcqPstAcqPkRateDiff' 'ITIpreAcqPstAcqPkRateDiff'},...
    {'AllCSPkRates' 'AllITIPkRates' 'AcqPt'},@PrePostDiffs)
%{
function [CSdiff,ITIdiff]=PrePostDiffs(CSrates,ITIrates,AcqPt)
CSdiff=[];ITIdiff=[];
if AcqPt<1500
    CSdiff = mean(CSrates(AcqPt:end)) - mean(CSrates(1:AcqPt-1));
    ITIdiff = mean(ITIrates(AcqPt:end)) - mean(ITIrates(1:AcqPt-1));
end    
%}
%
TSlimit('Subjects',Experiment.GrpITI20_CS30)
TScombineover('G20_30_PrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('G20_30_PrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')
%
TSlimit('Subjects',Experiment.GrpITI20_CS60)
TScombineover('G20_60_PrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('G20_60_PrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')

TSlimit('Subjects',Experiment.GrpITI80_CS30)
TScombineover('G80_30_PrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('G80_30_PrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')

TSlimit('Subjects',Experiment.GrpITI80_CS60)
TScombineover('G80_60_PrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('G80_60_PrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')


%% Distributions of the pre- and post-acq poke rate differences
CSdiffs=[Experiment.G20_30_PrePstCSpkRateDiffs;Experiment.G20_60_PrePstCSpkRateDiffs;...
    Experiment.G80_30_PrePstCSpkRateDiffs;Experiment.G80_60_PrePstCSpkRateDiffs];
ITIdiffs=[Experiment.G20_30_PrePstITIpkRateDiffs;Experiment.G20_60_PrePstITIpkRateDiffs;...
    Experiment.G80_30_PrePstITIpkRateDiffs;Experiment.G80_60_PrePstITIpkRateDiffs];
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
xlabel('mean(PostAcqRate) - mean(PreAcqRate)','FontSize',18)
ylabel('Cumulative Fraction of Subjects','FontSize',18)
legend('CS','ITI','location','SE')
title('Experiment 5 ("Number")')
set(gcf,'Position',[688.00 1348.00 372.00 324.00])
saveas(gcf,...
    '/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 5/E5 CmDstsPrePstCS&ITIrateDiffs.pdf')

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

NumBins = 10;
TSapplystat('PkRateProfileInCSpostAcq',{'CSPkTms_S' 'AllCSdurs' 'AcqPt'},...
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

% Graphing Subject-by-Subject Within-CS, Post-Acq Poke Frequency Profiles 
G = {Experiment.GrpITI20_CS30  Experiment.GrpITI20_CS60 ...
    Experiment.GrpITI80_CS30 Experiment.GrpITI80_CS60};
Names ={'20-30' '20-60' '80-30' '80-60'};
Xlbl = {{'1' '15' '30'};{'1' '30' '60'};{'1' '15' '30'};{'1' '30' '60'}};
for g = 1:length(G)
    figure
    plt = 1;
    for S = G{g}
        subplot(6,2,plt)
        if isempty(Experiment.Subject(S).PkRateProfileInCSpostAcq)
            text(.4,.5,'Never Acquired')
            plt=plt+1;
            continue
        end
        subplot(6,2,plt)
            bar(Experiment.Subject(S).PkRateProfileInCSpostAcq(1:10),1)
            xlim([.5 10.5])
            title(['S' num2str(S)])
            set(gca,'XTick',[1 5 10],'XTickLabel',Xlbl{g})
            if plt>10
                xlabel('Time Elapsed in CS (s)')
            else
                xlabel('')
            end
            if mod(plt,2)>0
                ylabel('Pks/s')
            end
        plt=plt+1;
    end
    saveas(gcf,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 5' ...
        '/E5 PstAcqWIcsPkFreqProfile' Names{g} '.pdf'])
end

%% Aggregating Post-Acq CS Decile Profiles by Group to Experiment level
TSlimit('Subjects',Experiment.GrpITI20_CS30)
    TScombineover('G2030PstAcqPksPrSecByDecile','PkRateProfileInCSpostAcq','t') % 
    TSapplystat({'G2030ProfileMean' 'G2030ProfileSE'},'G2030PstAcqPksPrSecByDecile',@ProfMean)
    %{
    function [M,SE] = ProfMean(A)
    % A is 2-col array with deciles repeated in 2nd colin
    A(A(:,1)==0,:)=[]; % deleting 11th bins (always 0)
    Ar = reshape(A(:,1),10,[]);
    M = mean(Ar,2);
    SE = std(Ar,0,2)/sqrt(size(Ar,2));
    %}
TSlimit('Subjects',Experiment.GrpITI20_CS60)
    TScombineover('G2060PstAcqPksPrSecByDecile','PkRateProfileInCSpostAcq','t')
    TSapplystat({'G2060ProfileMean' 'G2060ProfileSE'},'G2060PstAcqPksPrSecByDecile',@ProfMean)
TSlimit('Subjects',Experiment.GrpITI80_CS30)
    TScombineover('G8030PstAcqPksPrSecByDecile','PkRateProfileInCSpostAcq','t')
    TSapplystat({'G8030ProfileMean' 'G8030ProfileSE'},'G8030PstAcqPksPrSecByDecile',@ProfMean)
TSlimit('Subjects',Experiment.GrpITI80_CS60)
    TScombineover('G8060PstAcqPksPrSecByDecile','PkRateProfileInCSpostAcq','t')
    TSapplystat({'G8060ProfileMean' 'G8060ProfileSE'},'G8060PstAcqPksPrSecByDecile',@ProfMean)

%% Errorbar Graphs of Group Within-CS Post-Acq Response Freq Profiles
Nms = {'1' '15' '30'};
figure
Ax1=subplot(2,2,1);
    TSapplystat('',{'G2030ProfileMean' 'G2030ProfileSE'},...
        @EB,Ax1,Nms)
    %{
    function EB(m,se,Ax,Nms)
    figure
    errorbar(Ax,1:10,m,se,se)
    set(gca,'XTick',[1 5 10],'XTickLabel',Nms)    
    %}
        title('ITI20, CS30','FontWeight','normal') 
Ax2=subplot(2,2,2);
    Nms = {'1' '30' '60'};
    TSapplystat('',{'G2060ProfileMean' 'G2060ProfileSE'},...
        @EB,Ax2,Nms)
    title('ITI20, CS60','FontWeight','normal') 

Ax3=subplot(2,2,3);
    Nms = {'1' '15' '30'};
    TSapplystat('',{'G8030ProfileMean' 'G8030ProfileSE'},...
        @EB,Ax3,Nms);xlabel('Elapsed CS Time (s)')
   title('ITI80, CS30','FontWeight','normal')  

Ax4=subplot(2,2,4);
    Nms = {'1' '30' '60'};
    TSapplystat('',{'G8060ProfileMean' 'G8060ProfileSE'},...
        @EB,Ax4,Nms);xlabel('Elapsed CS Time (s)')
    title('ITI80, CS60','FontWeight','normal') 


%% Cummulative USs at Acquisition
TSlimit('Subjects','all')
TSapplystat('USsAtAcquisition',{'AllITIUSs' 'AcqPt'},@USsAtAcq)
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
TSlimit('Subjects',Experiment.GrpITI20_CS30)
    TScombineover('G2030USsAtAcq','USsAtAcquisition')
TSlimit('Subjects',Experiment.GrpITI20_CS60)
    TScombineover('G2060USsAtAcq','USsAtAcquisition')
TSlimit('Subjects',Experiment.GrpITI80_CS30)
    TScombineover('G8030USsAtAcq','USsAtAcquisition')
TSlimit('Subjects',Experiment.GrpITI80_CS60)
    TScombineover('G8060USsAtAcq','USsAtAcquisition')

%% Average # of USs per ITI
TSlimit('all')
TSapplystat('USperITI',{'AllITIdurs' 'AllITIUSs'},@USsPerITI)
%%
TSlimit('Subjects',Experiment.GrpITI20_CS30)
    TScombineover('GrpITI20_CS30USsPerITI','USperITI')
TSlimit('Subjects',Experiment.GrpITI20_CS60)
    TScombineover('GrpITI20_CS60USsPerITI','USperITI')    
TSlimit('Subjects',Experiment.GrpITI80_CS30)
    TScombineover('GrpITI80_CS30PerITI','USperITI')
TSlimit('Subjects',Experiment.GrpITI80_CS60)
    TScombineover('GrpITI80_CS60USsPerITI','USperITI')

%% Subject level summary stats for assembly at Experiment level and export 
% to long table
TSlimit('Subjects','all')
E = 5; % Experiment #
TSapplystat({'SummaryArray' 'GroupName'},{'AllCSdurs' 'AllITIdurs' 'AllITIUSs' 'AcqPt' ...
    'CSpreAcqPstAcqPkRateDiff' 'ITIpreAcqPstAcqPkRateDiff'},@SubSummary,E)
%{
function [Sm,Gnm] = SubSummary(CSdrs,ITIdrs,ITIUSs,AcqPt,CSprepst,ITIprepst,E)
% 24-element row vector: Sb# E, G#, Gname, Sidx, Cdr, ForV, Idr, USUS, Infrmtvn,
% N_U_S|CSoff, Product, ActTrl, RateDiff, Cd1,...,Cd10
global Experiment
Sm = nan(1,24); % initializing
Sm(1) = E; % experiment #
%% Group # and name
FN = fieldnames(Experiment); % cell array; the names of the groups begin
% w cell 14
r = 1;
G = cell(4,1);
for c = 14:17
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
% At this point I have 1st 3 elements of the row vec
%%
Sm(4) = mean(CSdrs); % CSdr column
if std(CSdrs)<.1 % fixed duration CS
    Sm(5) = 1;
else % variable duration CS
    Sm(5) = 0;
end
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
Sm(13) = CSprepst; % mean CS pk rate after acq - mean before acq
Sm(14) = ITIprepst; % ditto fo ITI
if E~=3
    Sm(15:24) = Experiment.Subject(sb).PkRateProfileInCSpostAcq(1:10);
else
    Sm(15:24) = Experiment.Subject(sb).PstAcqPksPerSecInDeciles(1:10);
end
%}
%
TScombineover('TableArray','SummaryArray') % raising summary vectors to an
% array at the Experiment level
%
TScombineover('GrpCharArray','GroupName','c')
%
TSapplystat('TableArray','TableArray',@sortrows,2) % sort array by group #

       
%% Putting explanatory text in ExpNotes field
Experiment.ExpNotes = char({'Design:'
    'These group names give expectation of exponentially distributed'
    'ITI durations and the durations of the fixed-duration CS.'
     'No matter what the expected duration of the ITI, the average'
     'interval between USs during ITIs was 20s. Thus, for groups'    
     'with longer ITIs, the average number of USs during an ITI'
     'was greater than 1.'
     ' '
     'Session ended when subject had received 32 USs and 8 CSs.' 
     ' '                      
     'Analysis Note'
     'The function that estimates the acquisition point initializes'
     'the estimate to 1500, which is not a possible value, because'
     'there were not that many trials. This is done for graphic reasons'
     '(so that failures to acquire are evident in the plots of the'
     'cumulative distributions of trials to acquisition).  When we'
     'compute median trials to acquisition for groups, we set medians'
     'of 1500 to nan'});       