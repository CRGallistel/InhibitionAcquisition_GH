%This is the script for analyzing the fixed-CS inhibtion data. This is the
% one created April 2019 after giving up on the analyses of accumulated
% rate-diff information as a basis for acquisition
%{
Design:
32 trials per session, 32 reinforcers per session.
 within
ITI = mean of 20s with exponential distribution.

CS duration either 10s,20s,40s,or 80s or Rnd.
In Rnd conditions, all 4 CS durs randomly intermixed,
with USs randomly programmed w/o regard to whether CS present or not.

Reinforcer delivery = exponential distributed w mean = 20s.
 
Pellets delivered only in the ITI for experimental groups,
and in ITI and CS for random control.
%}
%% Creating an Experiment structure
ExpName='/Users/galliste/Dropbox/InhibitoryExperiments_All/ExperimentStructures/InhibExper6_background';
TSinitexperiment(ExpName,1001,401:440,'Rat','Balsam') % Creates an
% Experiment structure and fills in the following fields:
% Experiment.Name = '/Users/galliste/Dropbox/InhibitoryExperiments_All/ExperimentStructures/InhibExper6_background'
% Experiment.ID = 1001;
% Experiment.Subjects = the row vector [401 402 403 ... 440]
% Experiment.Species = Rat
% Experiment.Lab = Balsam
% The TSinitexperiment function counts the number of elements in the vector
% of subject ID numbers and then fills in another field:
% Experiment.NumSubjects = 40

% Loading into the structure information necessary to the loading of data

TSsetloadparameters('InputTimeUnit',1,'OutputTimeUnit',1,'LoadFunction',...
'TSload2ColWithHeader','FilePrefix','R','FileExtension','.txt') % Put into the
% Experiment structure the information it needs to load raw data files,
% using Variable-Value pairs. The first variable-value pair specifies the
% time unit in seconds in the 1st column of the raw data, that is, the
% original time stamps. In these raw data, that unit is 1 because the raw
% time stamps are in seconds. If the raw time stamps were in 50ths of a
% second, that is, if the number 305 in the first column denoted a session
% time of 6.1 seconds, then we would assign the value .02 to this variable.
% The second variable-value pair specifies the time unit to be used within
% the Experiment structure. If one wants the time unit in time-stamped data
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
% files to be loaded begin with 'R' and have '.txt' as their extension

%% Loading data
% The data to be loaded are in 2-col text files with the first 12 rows
% giving header information (Date, Subject ID, Phase, Box #, etc) and the
% remaining rows giving time-stamped numerically encoded events, with the
% time stamps in seconds in the first column and the numerical event codes
% in the second. The files are in folders named Day1, Day2, Day3, etc. The
% simplest way to load the data is to type at the command prompt:

TSloadsessions
% This calls up a browser, which allows you to browse for one of the
% data-containing folder. When you have found that folder, select it and
% click the Open button. The data files in that folder will be loaded.
% There are, however, 35 such folders. It is tedious to call TSloadsessions
% 35 times, browsing on each occassion. We can automate this process with
% the following code after using Matlab's file browser to make the folder
% that contains the Day 1, Day 2, etc folders Matlab's Current Folder

%%
for d = 1:35 % stepping through the Day subfolder
    FN = ['Day ' num2str(d)]; % constructing the name of the folder containing
    % the files we want to load
   
    TSloadsessions(FN) % calling TSloadsession to load the files in that directory
end

%% Importing (or creating) event codes into the Experiment structure and
% then "declaring" them

% Because Matlab will not mix numbers and text within an (ordinary) array,
% the codes for events in the raw data must be integers. However, writing
% code using integers to refer to events puts an impossible burden on (most
% people's) memory when there are many different events whose
% numbers must be remembered. And the use of numbers of refer to events
% makes the code almost unintelligble to someone who does not know which
% numbers refer to which events or even what the set of possible events is.
% For that reason, the TSsystem includes a "dictionary" that allows the
% code write to refer to events by text names, like 'Toneon', 'Toneoff',
% 'Pelletdelivered', which are immediately intelligible to the uninitiated
% and easy for the code writer to remember. The "dictionary" is created by
% making the names for the different events the names of variables in
% Matlab's workspace to which are assigned the numbers that code for the
% events thus named. Then when you write code that uses the name, Matlab
% treats that name as a variable and uses the value of that variable in
% doing what it is told to do. The dictionary is stored in the Experiment
% structure at the Experiment level in a field named (you guessed it)
% EventCodes. Before we can write intelligible code, we need to put into
% the EventCodes field the names of the events we will refer to and the
% corresponding numerical codes for those events. If there are only a very
% few events that we will wish to refer to, we can create the dictionary
% directly as follows:
Experiment.EventCodes.Toneon=61; % Creates a field named Toneon in the
% Experiment.EventCodes structure and enters the value 61. The field's name
% is the name of the variable that will appear in the workspace (but only
% when we declare event codes) and 61 will be the value of that variable

Experiment.EventCodes.Toneoff=51; % Creates a field named Toneoff and enters
% the value 51
%%
% However, if there are a goodly number of events, this is tedious. It is
% easier to prepare a text file with, on each row the name chosen for one
% event with its corresponding number, separated by '=', for example:
%{
Toneon=61
Toneoff=51
etc
%}
% Then, one can import the event codes using (you guessed it)
% TSimporteventcodes:
TSimporteventcodes
% This command opens a browsing window for you to find the text file that
% contains the event codes and their corresponding numbers. When you find
% the file, select it and click the Open button to import those events and
% their values into the EventCodes field of the Experiment structure,
% checking to make sure that none of the names contains any characters that
% are illegal in a Matlab variable name (e.g., '&','*','-',etc)

%% Creating fields at the Experiment level that specify which subjects are
% in which groups (experimental conditions)
cd('/Users/galliste/Dropbox/InhibitoryExperiments_All/Final CodeFiles/Exper1_fixed')
% This is here to be sure that one is in the right directory when running
% the cells that follow after stripping the Experiment structure down to
% the raw data
Experiment.Grp10s = [1 2 13 14 25 26 37 38]; % The group for which the
% inhibitory CS lasted 10s. During the CSs no pellets were delivered.
% Pellets were delivered at random during the ITIs

Experiment.Grp20s = [3 4 15 16 27 28 39 40]; % see above

Experiment.Grp40s = [5 6 17 18 29 30 31 32]; % see above

Experiment.Grp80s = [7 8 19 20 21 22 33 34]; % see above

Experiment.GrpRnd = [9:12 23 24 35 36]; % pellets were delivered at random
% during both the CSs and the ITIs

%% Defining CS trial type and computing basic statistics

TSdefinetrialtype('CS',[Toneon Toneoff]) % defines stretches of data between
% tone ons and tone offs as CS type trials, enabling us to compute
% statistics for these stretches of data. This trial definition is stored
% in a field at the Experiment level
%
TSlimit('Subjects','all')
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
SI = 1; % intervals into which CS is to be partitioned (in seconds)

TSapplystat('PkRatePerCSsubInterval',{'Pktms' 'TrialDuration'},@PksPerSbInt,SI)
% Creates field at the Trial level that gives the poke rate within
% successive 1s intervals of the CS. PksPerSbInt is a custom helper
% function. TSapplystat passes to it the data in the Pktms and
% TrialDuration fields at the trial level and also the SI, which is the
% width of the intervals into which the trial is to be partitioned. It is
% good practice to copy the code for a custom helper function and paste it
% into the comment that immediately follows the first call to that
% function--see immediately below.
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

%% Aggregating statistics from the CS trials into fields at the Session

TScombineover('CSPkRates','PkRate') % Aggregates the data in the PkRate fields
% at the Trial level under the CS trial type into a single field at the
% Session level, to which it assigns the name CSPkRates

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
% The 'CSPkTms_S' field at the Subject level will be used to compute the
% cumulative distribution of pooled poke times during CSs post acquisition

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
%
TSlimit('Subjects',[Experiment.Grp10s Experiment.Grp20s Experiment.Grp40s ...
    Experiment.Grp80s]) % This limits the application of the following two
    % commands to those subjects that had a fixed CS duration
TScombineover('PkRatePerCSsubInt','PkRatePerCSsubInterval') % session level

TScombineover('PkRatePerCSsbInt','PkRatePerCSsubInt') %  subject level; 
% each row is a trial

%% Defining ITI trial type and computing basic statistics
TSlimit('all') % removing the limits imposed above

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
%
TStrialstat('PkTms',@TSparse,'result=time(1)-starttime;',Pokestart)
% Computes the times within each ITI trial (measured from beginning of 
% trial) at which poke was initiated and stores them in a field named 
% PkTtms at the Trial level under the ITI trial type.

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

TSapplystat('PksLst1sec',{'PkTms' 'TrialDuration'},@Lst1s) % This will be
% used later to normalize second-by-second poke rates during the CS after
% acquisition

%% Aggregating statistics from the ITI trials into fields at the Session and
% Subject levels

% Aggregating to Session level
    TScombineover('ITIPkRates','PkRate') % Aggregates the data in the PkRate fields
    % at the Trial level under the ITI trial type into a single field at the
    % Session level, to which it assigns the name CSPkRates

    TScombineover('ITIdurs','TrialDuration') % Aggregates the data from the
    % TrialDuration fields at the Trial level under the ITI trial type into a 
    % field at the Session level, to which it assigns the name ITIdurs. The 
    % TrialDuration fields at the Trial level were created automatically when
    % we computed the first ITI trial statistic. During this computation, the
    % system found all the ITI trials and recorded some basic statistics,
    % including their duration

    TScombineover('NumITIUSs','NumUSs') % Aggregates the data from the NumUSs
    % fields at the Trial level under the ITI trial type into a field at the
    % Session level, to which it assigns the name NumITIUSs
    
    TScombineover('PksLst1secOfITI','PksLst1sec') % Aggreates the data from the
    % PksLst1sec field at the Trial level for the ITI trial type into a field
    % at the Session level named PksLst1secOfITI

    TScombineover('CumUStmsDrgITIs','UStms','m') % Creates a field named
    % CumUStmsDrgITIs at the Session level that contains the cumulative reward
    % times on a clock that only runs during ITIs. Differencing will these
    % cumulative times will give the intervals between USs
    
% Aggregating to Subject level
    TScombineover('AllITIPkRates','ITIPkRates') % Aggregates the vector of ITI poke
    % rates in the ITIPkRates fields at the Session level into a field at the
    % Subject level, to which it assigns the name AllITIPkRates

    TScombineover('AllITIdurs','ITIdurs') % Aggregates the vector of ITI durations
    % in the ITIdurs fields at the Session level into a field at the Subject
    % level, to which it assigns the name AllITIdurs,

    TScombineover('AllITIUSs','NumITIUSs') % Aggregates the vector of pellet
    % deliveries during the ITIs in the NumITIUSs field at the Session level into
    % a field at the Subject level, to which it assigns the name AllITIUSs

    TScombineover('PksLst1secOfITI_S','PksLst1secOfITI') % Aggregates the
    % vectors of poke rates in the last 1s of each ITI in the PksLst1secOfITI
    % fields at the Session level to a field at the Subject level

TSsaveexperiment
%% Computing trial-by-trial CS-ITI poke rate differences and session level
% ITI-CS mean poke rate differences
TSapplystat('CS_ITIrateDiffs',{'AllCSPkRates' 'AllITIPkRates'},@minus)
% Computes the trial-by-trial differences in the rate of poking during the
% CS and during the ITI that precedes the CS and puts the resulting vector
% of rate differences in a field at the Subject level, to which it assigns
% the name CS_ITIrateDiffs. The poke rates during the CS trials are in the
% AllCSPkRates field; the poke rates during the preceding ITIs are in the
% AllITIPkRates field. The helper function is Matlab's minus function,
% which subtracts each element in one vector from the corresponding element
% in the other vector, provided, of course, that the two vectors have the
% same number of elements

TSapplystat('CSpkRateMean','CSPkRates',@mean) % session level scalar
TSapplystat('ITIpkRateMean','ITIPkRates',@mean) % session level scalar
TSapplystat('ITI_CSpkRateDiffs',{'ITIPkRates' 'CSPkRates'},@minus)
% session level vector
TSapplystat('ITI_CSpkRateDiffsMean','ITI_CSpkRateDiffs',@mean)
% session level scalar = mean ITI-CS pk rate diff in a session

TScombineover('CSPkRateMeans','CSpkRateMean') % Subject level col vec
TSapplystat('CSPkRateMeans','CSPkRateMeans',@transpose) % convert to row vec

TScombineover('ITIPkRateMeans','ITIpkRateMean') % Subject level col vec
TSapplystat('ITIPkRateMeans','ITIPkRateMeans',@transpose) % convert to row vec

TScombineover('ITI_CS_PkRateDiffMeans','ITI_CSpkRateDiffsMean')
% Subject level col vec
TSapplystat('ITI_CS_PkRateDiffMeans','ITI_CS_PkRateDiffMeans',@transpose)
% convert to row vec

%% Missing data (S 7, in 80s group, only got 33 sessions
Experiment.Subject(7).CSPkRateMeans(34:35)=nan(1,2);
Experiment.Subject(7).ITIPkRateMeans(34:35)=nan(1,2);
Experiment.Subject(7).ITI_CS_PkRateDiffMeans(34:35)=nan(1,2);

%% Aggregating Session by Session Mean CS, ITI and ITI-CS poke rates to
% groups at Experiment level
Experiment.Subject(37).CSPkRateMeans(35)=NaN; % missing session
Experiment.Subject(37).ITIPkRateMeans(35)=NaN; % missing session
Experiment.Subject(37).ITI_CS_PkRateDiffMeans(35)=NaN; % missing session
TSlimit('Subjects',Experiment.Grp10s)
TScombineover('Grp10sCSPkRateMeans','CSPkRateMeans')
TScombineover('Grp10sITIPkRateMeans','ITIPkRateMeans')
TScombineover('Grp10sRateDiffMeans','ITI_CS_PkRateDiffMeans')
%
Experiment.Subject(27).CSPkRateMeans(35)=NaN; % missing session
Experiment.Subject(27).ITIPkRateMeans(35)=NaN; % missing session
Experiment.Subject(27).ITI_CS_PkRateDiffMeans(35)=NaN; % missing session
TSlimit('Subjects',Experiment.Grp20s)
TScombineover('Grp20sCSPkRateMeans','CSPkRateMeans')
TScombineover('Grp20sITIPkRateMeans','ITIPkRateMeans')
TScombineover('Grp20sRateDiffMeans','ITI_CS_PkRateDiffMeans')

Experiment.Subject(17).CSPkRateMeans(35)=NaN; % missing session
Experiment.Subject(17).ITIPkRateMeans(35)=NaN; % missing session
Experiment.Subject(17).ITI_CS_PkRateDiffMeans(35)=NaN; % missing session
TSlimit('Subjects',Experiment.Grp40s)
TScombineover('Grp40sCSPkRateMeans','CSPkRateMeans')
TScombineover('Grp40sITIPkRateMeans','ITIPkRateMeans')
TScombineover('Grp40sRateDiffMeans','ITI_CS_PkRateDiffMeans')

TSlimit('Subjects',Experiment.Grp80s)
TScombineover('Grp80sCSPkRateMeans','CSPkRateMeans')
TScombineover('Grp80sITIPkRateMeans','ITIPkRateMeans')
TScombineover('Grp80sRateDiffMeans','ITI_CS_PkRateDiffMeans')
TSsaveexperiment

%% Graphing Session-by-Session CS, ITI & Diff Poke Rate Means by Group
Hanova = figure;
subplot(2,2,1)
plot(mean(Experiment.Grp10sCSPkRateMeans),'k-')
hold on
plot(mean(Experiment.Grp20sCSPkRateMeans),'k--')
plot(mean(Experiment.Grp40sCSPkRateMeans),'k-.')
plot(nanmean(Experiment.Grp80sCSPkRateMeans),'k:')
ylim([0 .7]);xlim([0 36])
xlabel('Session')
ylabel('CS Poke Rate (s{^-1})')
legend('CS10s','CS20s','CS40s','CS80s','location','NW')

subplot(2,2,2)
plot(mean(Experiment.Grp10sITIPkRateMeans),'k-')
hold on
plot(mean(Experiment.Grp20sITIPkRateMeans),'k--')
plot(mean(Experiment.Grp40sITIPkRateMeans),'k-.')
plot(nanmean(Experiment.Grp80sITIPkRateMeans),'k:')
ylim([0 .7]);xlim([0 36])
xlabel('Session')
ylabel('ITI Poke Rate (s{^-1})')

subplot(2,2,4)
plot(mean(Experiment.Grp10sRateDiffMeans),'k-')
hold on
plot(mean(Experiment.Grp20sRateDiffMeans),'k--')
plot(mean(Experiment.Grp40sRateDiffMeans),'k-.')
plot(nanmean(Experiment.Grp80sRateDiffMeans),'k:')
ylim([-.1 .5]);xlim([0 36])
xlabel('Session')
ylabel('ITI-CS Poke Rate (s{^-1})')
subplot(2,2,3); % The p values, which are obtained from the ANOVAs,
% will be written into this panel
set(gca,'XTick',[],'YTick',[])
set(Hanova,'Name','E1 ANOVA','Position',[1105.00 1128.00 573.00 742.00]);

%% Creating ANOVA Arrays
% Creating array to be fed to CS ANOVA
NumSes = 33; % the number of sessions for subject with fewest
TSapplystat('CSpkRateByDayByGroup',{'Grp10sCSPkRateMeans' ...
    'Grp20sCSPkRateMeans' 'Grp40sCSPkRateMeans' 'Grp80sCSPkRateMeans' ...
     'Grp10s' 'Grp20s' 'Grp40s' 'Grp80s'},@vct1,NumSes)
% Creating the 4-column "long table" to be fed to the anovan command and
% putting it in a field at the Experiment level named CSpkRateByDayByGroup.
% Col 1 = data (mean poke rate in a session); Col 2 = Session; Col 3
% =Subject; Col 4 = Group (CS duration). This is the data format required
% by the anovan function and by the similar functions in other statistical
% packages (e.g., by the TidyVerse package in R)
    %{
    function Aout = vct1(A1,A2,A3,A4,G1,G2,G3,G4,ns)
    % Deleting supernumerary sessions
    A1(:,ns+1:end)=[];
    A2(:,ns+1:end) =[];
    A3(:,ns+1:end) =[]; 
    A4(:,ns+1:end) =[]; 

    % Building array
    Aout = [reshape(A1',[],1);reshape(A2',[],1);reshape(A3',[],1);reshape(A4',[],1)];
    % the data column
    Aout(:,2) = repmat((1:ns)',32,1); % column for session # (32 = # subjects)
    Aout(:,3) = [reshape(repmat(G1,ns,1),[],1);reshape(repmat(G2,ns,1),[],1);...
        reshape(repmat(G3,ns,1),[],1);reshape(repmat(G4,ns,1),[],1)]; % sub IDs
    Aout(:,4) = [ones(8*ns,1);2*ones(8*ns,1);3*ones(8*ns,1);4*ones(8*ns,1)];
    % group IDs
    %}    
% Creating array to be fed to ITI ANOVA
TSapplystat('ITIpkRateByDayByGroup',{'Grp10sITIPkRateMeans' ...
    'Grp20sITIPkRateMeans' 'Grp40sITIPkRateMeans' 'Grp80sITIPkRateMeans' ...
     'Grp10s' 'Grp20s' 'Grp40s' 'Grp80s'},@vct1,NumSes)

% Creating array to be fed to ITI-CS ANOVA
TSapplystat('ITI_CSRateDiffMeansByDayByGroup',{'Grp10sRateDiffMeans' ...
    'Grp20sRateDiffMeans' 'Grp40sRateDiffMeans' 'Grp80sRateDiffMeans' ...
     'Grp10s' 'Grp20s' 'Grp40s' 'Grp80s'},@vct1,NumSes)
TSsaveexperiment

%% CS ANOVA
% Col 1 is the data; remaining columns are the factors:
VarNames = {'Session', 'Subject','Group'};
NestMatrx = [0 0 0;0 0 1;0 0 0]; % Subject is nested within group
rnd = 2;
mdl = 'interaction'; % only the 2-way interactions)
% I assume we should use the type 3 sum of squares (the default)
TSapplystat('CSpkRateBySesByGrpANOVApVals','CSpkRateByDayByGroup',...
    @GroupBySesANOVA,mdl,NestMatrx,rnd,VarNames)
% Creates field CSpkRateBySesByGrpANOVApVals at Experiment level with 
%  character array of p values
%{
function ptbl = GroupBySesANOVA(A,mdl,nst,rnd,vars)
p = anovan(A(:,1),{(A(:,2)) (A(:,3)) (A(:,4))},'model',mdl,...
    'nested',nst,'random',rnd,'varnames',vars)
% Extracting p values to put into structurte
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
    Pca{3} = 'Group p<.001';
else
    Pca{3} = ['Group p=' num2str(p(3),3)];
end
if p(5)<.001
    Pca{4} = 'SessionxGroup p<.001';
else
    Pca{4} = ['SessionxGroup p=' num2str(p(5),3)];
end

% The call to anovan returns the ANOVA table to the workspace, so I can
% paste it in:
    
    Source                   Sum Sq.   d.f.   Mean Sq.     F     Prob>F
---------------------------------------------------------------------
  Session                   0.9767     32   0.03052     3.62   0     
  Subject(Group)           16.8488     28   0.60174    71.34   0     
  Group                     4.9458      3   1.64861     2.74   0.0621
  Session*Subject(Group)    7.5575    896   0.00843      Inf      NaN
  Session*Group             1.4438     96   0.01504     1.78   0     
  Error                     0           0   0                        
  Total                    31.7726   1055                                                      
%}

%% ITI ANOVA
% Col 1 is the data; remaining columns are the factors:
VarNames = {'Session', 'Subject','Group'};
NestMatrx = [0 0 0;0 0 1;0 0 0]; % Subject is nested within group
rnd = 2;
mdl = 'interaction'; % only the 2-way interactions)
% I assume we should use the type 3 sum of squares (the default)
TSapplystat('ITIpkRateBySesByGrpANOVApVals','ITIpkRateByDayByGroup',...
    @GroupBySesANOVA,mdl,NestMatrx,rnd,VarNames)
% Creates field ITIpkRateBySesByGrpANOVApVals at Experiment level with 
%  character array of p values

% The call to anovan returns the ANOVA table to the workspace, so I can
%{
paste it in:
    
      Source                   Sum Sq.   d.f.   Mean Sq.     F     Prob>F
---------------------------------------------------------------------
  Session                   5.1651     32    0.16141   12.36   0     
  Subject(Group)           23.4502     28    0.83751   64.11   0     
  Group                     1.7656      3    0.58852    0.7    0.5584
  Session*Subject(Group)   11.7042    896    0.01306     Inf      NaN
  Session*Group             1.2964     96    0.0135     1.03   0.3973
  Error                    -0           0   -0                       
  Total                    43.3815   1055                                                                                                           
%}
%% ITI-CS ANOVA
% Col 1 is the data; remaining columns are the factors:
VarNames = {'Session', 'Subject','Group'};
NestMatrx = [0 0 0;0 0 1;0 0 0]; % Subject is nested within group
rnd = 2;
mdl = 'interaction'; % only the 2-way interactions)
% I assume we should use the type 3 sum of squares (the default)
TSapplystat('ITI_CSRateDiffMeansANOVApVals','ITI_CSRateDiffMeansByDayByGroup',...
    @GroupBySesANOVA,mdl,NestMatrx,rnd,VarNames)
% Creates field ITIpkRateBySesByGrpANOVApVals at Experiment level with 
%  character array of p values

% The call to anovan returns the ANOVA table to the workspace, so I can
%{
  Source                   Sum Sq.   d.f.   Mean Sq.     F       Prob>F   
--------------------------------------------------------------------------
  Session                   2.9597     32    0.09249   14.08   2.56594e-59
  Subject(Group)            3.4281     28    0.12243   18.64   6.98558e-71
  Group                    10.1984      3    3.39946   27.77   1.54203e-08
  Session*Subject(Group)    5.8861    896    0.00657     Inf           NaN
  Session*Group             2.1517     96    0.02241    3.41   7.56867e-22
  Error                    -0           0   -0                            
  Total                    24.624    1055                                 
%}

%% Putting p values on the ANOVA plots
figure(Hanova)
subplot(2,2,3) % activating lower left subplot
ptxts = Experiment.CSpkRateBySesByGrpANOVApVals;
text(.05,.85,{'CS ANOVA';['   p_S' ptxts(1,10:end)];['   p_G ' ptxts(3,8:end)];...
    ['   p_S_x_G' ptxts(4,16:end)]})
ptxts = Experiment.ITIpkRateBySesByGrpANOVApVals;
text(.05,.5,{'ITI ANOVA';['   p_S' ptxts(1,10:end)];['   p_G ' ptxts(3,8:end)];...
    ['   p_S_x_G' ptxts(4,16:end)]})
ptxts = Experiment.ITI_CSRateDiffMeansANOVApVals;
text(.05,.15,{'ITI-CS ANOVA';['   p_S' ptxts(1,10:end)];['   p_G ' ptxts(3,8:end)];...
    ['   p_S_x_G' ptxts(4,16:end)]})
saveas(Hanova,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 1/' ...
    get(Hanova,'Name') '.pdf']);

TSsaveexperiment

%% Computing CSoff Informativeness
TSlimit('Subjects','all')
TScombineover('NumITIUSs_s','NumUSs') % to session level
TScombineover('ITITrialDurs','TrialDuration')  %to session level
TSapplystat('SessionDuration','TSData',@SesDur) % field for duration of
% session in seconds
%{
function sd = SesDur(tsd)
sd = tsd(end,1);
end
%}
TSapplystat('ITIusRate',{'NumITIUSs_s' 'ITITrialDurs'},@Rate)
%{
function R = Rate(N,T)
R = sum(N)/sum(T);
end
%}

% Aggregating numbers of ITI USs and Trial Durations and Session Durations
% to Subject level
TScombineover('NumITIUSs_S','NumITIUSs_s') % to subject level
TScombineover('SessionDurations','SessionDuration')
TScombineover('ITITrialDurs_S','ITITrialDurs')

% Computing Informativeness & Aggregating by Groups to Experiment level
TSapplystat('lambdaR_ITI',{'NumITIUSs_S' 'ITITrialDurs_S'},@Rate) %Subject level
TSapplystat('lambdaR_C',{'NumITIUSs_S' 'SessionDurations'},@Rate) % Subject level
% 
TSapplystat('CSoffInformativeness',{'lambdaR_ITI' 'lambdaR_C'},@rdivide) % Subject level

% Aggregating Informativeness by Groups to Experiment level
TSlimit('Subjects',Experiment.Grp10s)
TScombineover('Grp10sInformativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.Grp20s)
TScombineover('Grp20sInformativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.Grp40s)
TScombineover('Grp40sInformativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.Grp80s)
TScombineover('Grp80sInformativeness','CSoffInformativeness')

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

% Aggregating Trials to Acquisition by Group to Experiment level
TSlimit('Subjects',Experiment.Grp10s)
TScombineover('Grp10sAcqPts','AcqPt') % Experiment level field

TSlimit('Subjects',Experiment.Grp20s)
TScombineover('Grp20sAcqPts','AcqPt') % Experiment level field

TSlimit('Subjects',Experiment.Grp40s)
TScombineover('Grp40sAcqPts','AcqPt') % Experiment level field

TSlimit('Subjects',Experiment.Grp80s)
TScombineover('Grp80sAcqPts','AcqPt') % Experiment level field

TSlimit('Subjects',Experiment.GrpRnd)
TScombineover('GrpRndAcqPts','AcqPt') % Experiment level field

%% CDFs of Trials to Acquisition By Group
TSapplystat('',{'Grp10sAcqPts' 'Grp20sAcqPts' 'Grp40sAcqPts' 'Grp80sAcqPts'},...
    @TSplotcdfs,'Rows',1','Cols',1,'Xlm',[0 400],'Xlbl','Acquisition Trial',...
    'Ylbl','Cumulative Fraction of Subjects')
legend('Grp10s','Grp20s','Grp40s','Grp80s','location','NW')
ylabel('Cumulative Fraction of Subjects')
saveas(gcf,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 1/' ...
    'E1 CDFsOfTrialsToAcquisitionByGroup.pdf']);

%% Median Acquisition Trials by Group
TSapplystat('MedianTrlsToAcq',...
    {'Grp10sAcqPts' 'Grp20sAcqPts' 'Grp40sAcqPts' 'Grp80sAcqPts' 'GrpRndAcqPts'},...
    @AcqMedians)
%{
function AM = AcqMedians(D1,D2,D3,D4,D5)
AM(:,1) = [10;20;40;80;nan]; % CS durations; the 5th groups had random CS
% durations
AM(:,2) = median([D1 D2 D3 D4 D5])';
AM(AM(:,2)==1500,2) = nan; % median = 1200, which is impossible. This arises
% because we initialized estimated acquisition points to 1200 for graphic
% reasons (so that failures to acquire were evident in cumulative
% distributions of acquisition points)   
%}
%% Mean rate difference post acquisition
TSlimit('Subjects','all')
TSapplystat('MnPostAcqRateDiff',{'CS_ITIrateDiffs' 'AcqPt'},@PostAcqMnRateDiff)
% field at Subject level
% Experiment level aggregation of post acquisition mean rate diffs
TSlimit('Subjects',Experiment.Grp10s)
TScombineover('Grp10sMnPostAcqRateDiff','MnPostAcqRateDiff')

TSlimit('Subjects',Experiment.Grp20s)
TScombineover('Grp20sMnPostAcqRateDiff','MnPostAcqRateDiff')

TSlimit('Subjects',Experiment.Grp40s)
TScombineover('Grp40sMnPostAcqRateDiff','MnPostAcqRateDiff')

TSlimit('Subjects',Experiment.Grp80s)
TScombineover('Grp80sMnPostAcqRateDiff','MnPostAcqRateDiff')

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
TSlimit('Subjects',Experiment.Grp10s)
    TScombineover('Grp10sUSsAtAcq','USsAtAcquisition')
TSlimit('Subjects',Experiment.Grp20s)
    TScombineover('Grp20sUSsAtAcq','USsAtAcquisition')
TSlimit('Subjects',Experiment.Grp40s)
    TScombineover('Grp40sUSsAtAcq','USsAtAcquisition')
TSlimit('Subjects',Experiment.Grp80s)
    TScombineover('Grp80sUSsAtAcq','USsAtAcquisition')

%% Pre- & Post-Acquisition differences in mean poke rate during CSs and ITIs
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
TSlimit('Subjects',Experiment.Grp10s)
TScombineover('Grp10sPrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('Grp10sPrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')
%
TSlimit('Subjects',Experiment.Grp20s)
TScombineover('Grp20sPrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('Grp20sPrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')

TSlimit('Subjects',Experiment.Grp40s)
TScombineover('Grp40sPrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('Grp40sPrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')

TSlimit('Subjects',Experiment.Grp80s)
TScombineover('Grp80sPrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('Grp80sPrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')
TSsaveexperiment
%% Graphing Differences between poke rates pre and post acquisition for CSs
% and ITIs
figure
Hcs = plot(log2(10)*ones(4,1),Experiment.Grp10sPrePstCSpkRateDiffs,'k*',...
   log2(10)*ones(4,1),Experiment.Grp10sPrePstITIpkRateDiffs,'ko',...
log2(20)*ones(7,1),Experiment.Grp20sPrePstCSpkRateDiffs,'k*',...
   log2(20)*ones(7,1),Experiment.Grp20sPrePstITIpkRateDiffs,'ko',...
log2(40)*ones(8,1),Experiment.Grp40sPrePstCSpkRateDiffs,'k*',...
   log2(40)*ones(8,1),Experiment.Grp40sPrePstITIpkRateDiffs,'ko',...
log2(80)*ones(8,1),Experiment.Grp80sPrePstCSpkRateDiffs,'k*',...
   log2(80)*ones(8,1),Experiment.Grp80sPrePstITIpkRateDiffs,'ko');
hold on
Hmcs = plot(log2([10 20 40 80]),[mean(Experiment.Grp10sPrePstCSpkRateDiffs) ...
  mean(Experiment.Grp20sPrePstCSpkRateDiffs) ...
  mean(Experiment.Grp40sPrePstCSpkRateDiffs) ...
  mean(Experiment.Grp80sPrePstCSpkRateDiffs)],'k--');
Hmiti = plot(log2([10 20 40 80]),[mean(Experiment.Grp10sPrePstITIpkRateDiffs) ...
  mean(Experiment.Grp20sPrePstITIpkRateDiffs) ...
  mean(Experiment.Grp40sPrePstITIpkRateDiffs) ...
  mean(Experiment.Grp80sPrePstITIpkRateDiffs)],'k:');
plot(xlim,[0 0],'k-')
set(gca,'XTick',log2([10 20 40 80]),'XTickLabel',{'1.58' '2' '3' '5'})
xlabel('\lambda_I_T_I/\lambda_C')
ylabel('(Post-Acq Rate) ? (Pre-Acq Rate) (s^{-1})')
legend([Hcs(1) Hcs(2) Hmcs Hmiti],'CS','ITI','CSmean','ITImean','location','NW')

saveas(gcf,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 1/' ...
    'E1 PrePstRateDiffsForCS&ITIvsInform.pdf']);

%% Peak Poke Rate Session vs CS Duration
TSlimit('Subjects','all') % removes limit on subjects
TSapplystat('MeanCSpkRate','CSPkRates',@mean)
% Creates field MeanCSpkRate at Session level containing the mean CS
% poke rate for that session
TScombineover('MeanCSpkRates','MeanCSpkRate','t')
% Creates field MeanPkRateDiffs at the Subject level containing the
% session-by-session mean poke rate differences with a 2nd col with
% session number
TSapplystat('PeakkCSpkrateSes','MeanCSpkRates',@PkCSPkRateSes)
% field at Subject level giving session number at which CS rate peaks
%{
function PkSes = PkCSPkRateSes(A)
[~,PkSes] = max(A(:,1)); % location of max rate
end
%}
TSlimit('Subjects',Experiment.Grp10s)
TScombineover('Grp10sCSpokeRatePeakSes','PeakkCSpkrateSes')
% Collating subjects' data by group and adding 3rd column that identifies
% subject; creates field at Experiment level
TSlimit('Subjects',Experiment.Grp20s)
TScombineover('Grp20sCSpokeRatePeakSes','PeakkCSpkrateSes')
TSlimit('Subjects',Experiment.Grp40s)
TScombineover('Grp40sCSpokeRatePeakSes','PeakkCSpkrateSes')
TSlimit('Subjects',Experiment.Grp80s)
TScombineover('Grp80sCSpokeRatePeakSes','PeakkCSpkrateSes')
TSlimit('Subjects',Experiment.GrpRnd)
TScombineover('GrpRndCSpokeRatePeakSes','PeakkCSpkrateSes')

% Graphing Peak CS Poke Rate Session vs CSdur
figure
plot(log2(10*ones(8,1)),Experiment.Grp10sCSpokeRatePeakSes,'k*')
hold on
plot(log2(20*ones(8,1)),Experiment.Grp20sCSpokeRatePeakSes,'k*')
plot(log2(40*ones(8,1)),Experiment.Grp40sCSpokeRatePeakSes,'k*')
plot(log2(80*ones(8,1)),Experiment.Grp80sCSpokeRatePeakSes,'k*')
set(gca,'XTick',log2([10 20 40 80]),'XTickLabel',{'10' '20' '40' '80'})
xlabel('CS Duration (s, log scale)')
ylabel('Session at Which Poke Rate Peaked')

PkSesMdl = fitlm([log2(20*ones(8,1));log2(20*ones(8,1));log2(40*ones(8,1));...
    log2(80*ones(8,1))],[Experiment.Grp10sCSpokeRatePeakSes;...
    Experiment.Grp20sCSpokeRatePeakSes;Experiment.Grp40sCSpokeRatePeakSes;...
    Experiment.Grp80sCSpokeRatePeakSes])
%{
Linear regression model:
    y ~ 1 + x1

Estimated Coefficients:
                   Estimate     SE     tStat    pValue
                   ________    ____    _____    ______

    (Intercept)    40.33       9.36     4.31    0.00  
    x1             -4.93       1.82    -2.71    0.01  


Number of observations: 32, Error degrees of freedom: 30
Root Mean Squared Error: 8.54
R-squared: 0.197,  Adjusted R-Squared 0.17
F-statistic vs. constant model: 7.34, p-value = 0.011    
%}
hold on
plot([log2(10) log2(80)],-4.93*[log2(10) log2(80)]+40.33,'k--')
text(log2(15),32,'slope -4.93+/-1.82,p .01')

saveas(gcf,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 1/' ...
    'E1 PeakCSPkRateSesVsCSdur.pdf']);

%% Computing IRIs during ITIs and aggregating to Subject level
TSapplystat('IRIsDuringITIs','CumUStmsDrgITIs',@diff) % creates Session
% level field

TScombineover('AllIRIsDuringITIs','IRIsDuringITIs') % Aggregated to Subject
% level

%% Post-Acquisition Within CS Poke Rate Profiles
TSlimit('Subjects',[Experiment.Grp10s Experiment.Grp20s Experiment.Grp40s ...
    Experiment.Grp80s])
NumBins = 10;
TSapplystat('PkRateProfileInCSpostAcq',{'CSPkTms_S' 'AllCSdurs' 'AcqPt'},@Profile,NumBins)
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

% Graphing Subject-by-Subject Within-CS, Post-Acq Poke Frequency Profiles 
G = {Experiment.Grp10s  Experiment.Grp20s Experiment.Grp40s Experiment.Grp80s};
for g = 1:length(G)
    figure
    plt = 1;
    for S = G{g}
        if isempty(Experiment.Subject(S).PkRateProfileInCSpostAcq)
            continue
        end
        subplot(4,2,plt)
            bar(Experiment.Subject(S).PkRateProfileInCSpostAcq(1:10),1)
            xlim([.5 10.5])
            title(['S' num2str(S)])
            set(gca,'XTick',[1 5 10],'XTickLabel',{num2str(1*2^(g-1)) ...
                num2str(5*2^(g-1)) num2str(10*2^(g-1))})
            if plt>6
                xlabel('Time Elapsed in CS (s)')
            end
            if mod(plt,2)>0
                ylabel('Pks/s')
            end
        plt=plt+1;
    end
    saveas(gcf,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 1' ...
        '/PstAcqWIcsPkFreqProfileCS' num2str(10*2^(g-1)) '.pdf'])
end

% Aggregating Profiles to Experiment Level by Group
TSlimit('Subjects',Experiment.Grp10s)
    TScombineover('Grp10sPstAcqProfile','PkRateProfileInCSpostAcq')
    colnum = 11;
    TSapplystat('Grp10sPstAcqProfile','Grp10sPstAcqProfile',@rs,colnum)
    %{
    function O = rs(cv,cols)  
    O = reshape(cv,cols,[]); % converts column vector to 11-col array
    O(end,:)= []; % deleting terminal 0 (11th row)
    O=O'; % columns to rows
    %}
    TSapplystat('Grp10sProfileMean','Grp10sPstAcqProfile',@mean)
    TSapplystat('Grp10sProfileSE','Grp10sPstAcqProfile',@stder)
    %{
    function se = stder(v)
    se = std(v)/sqrt(numel(v));
    %}
%
TSlimit('Subjects',Experiment.Grp20s)
    TScombineover('Grp20sPstAcqProfile','PkRateProfileInCSpostAcq')
    TSapplystat('Grp20sPstAcqProfile','Grp20sPstAcqProfile',@rs,colnum)
    TSapplystat('Grp20sProfileMean','Grp20sPstAcqProfile',@mean)
    TSapplystat('Grp20sProfileSE','Grp20sPstAcqProfile',@stder)
TSlimit('Subjects',Experiment.Grp40s)
    TScombineover('Grp40sPstAcqProfile','PkRateProfileInCSpostAcq')
    TSapplystat('Grp40sPstAcqProfile','Grp40sPstAcqProfile',@rs,colnum)
    TSapplystat('Grp40sProfileMean','Grp40sPstAcqProfile',@mean)
    TSapplystat('Grp40sProfileSE','Grp40sPstAcqProfile',@stder)
TSlimit('Subjects',Experiment.Grp80s)
    TScombineover('Grp80sPstAcqProfile','PkRateProfileInCSpostAcq')
    TSapplystat('Grp80sPstAcqProfile','Grp80sPstAcqProfile',@rs,colnum)
    TSapplystat('Grp80sProfileMean','Grp80sPstAcqProfile',@mean)
    TSapplystat('Grp80sProfileSE','Grp80sPstAcqProfile',@stder)
    
%% Errorbar Graphs of Group Within-CS Post-Acq Response Freq Profiles
Nms = {'1' '5' '10'};
figure
Ax1=subplot(2,2,1);
    TSapplystat('',{'Grp10sProfileMean' 'Grp10sProfileSE'},...
        @EB,Ax1,Nms)
    %{
    function EB(m,se,Ax,Nms)
    figure
    errorbar(Ax,1:10,m,se,se)
        
    set(gca,'XTick',[1 5 10],'XTickLabel',Nms)    
    %}
Ax2=subplot(2,2,2);
    Nms = {'1' '10' '20'};
    TSapplystat('',{'Grp20sProfileMean' 'Grp20sProfileSE'},...
        @EB,Ax2,Nms)

Ax3=subplot(2,2,3);
    Nms = {'1' '20' '40'};
    TSapplystat('',{'Grp40sProfileMean' 'Grp40sProfileSE'},...
        @EB,Ax3,Nms);xlabel('Elapsed CS Time (s)')
    

Ax4=subplot(2,2,4);
    Nms = {'1' '40' '80'};
    TSapplystat('',{'Grp80sProfileMean' 'Grp80sProfileSE'},...
        @EB,Ax4,Nms);xlabel('Elapsed CS Time (s)')
%% Average # of USs per ITI
TSlimit('all')
TSapplystat('USperITI',{'AllITIdurs' 'AllITIUSs'},@USsPerITI)
%{
function O = USsPerITI(drs,USs)
USsPerSec = sum(USs)/sum(drs);
O = mean(drs)*USsPerSec;
%}
TSlimit('Subjects',Experiment.Grp10s)
    TScombineover('Grp10sUSsPerITI','USperITI')
TSlimit('Subjects',Experiment.Grp20s)
    TScombineover('Grp20sUSsPerITI','USperITI')
TSlimit('Subjects',Experiment.Grp40s)
    TScombineover('Grp40sUSsPerITI','USperITI')
TSlimit('Subjects',Experiment.Grp80s)
    TScombineover('Grp80sUSsPerITI','USperITI')
    
%% Subject level summary stats for assembly at Experiment level and export 
% to long table
TSlimit('Subjects','all')
E = 1; % Experiment #
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
%%
TScombineover('TableArray','SummaryArray') % raising summary vectors to an
% array at the Experiment level
%
TScombineover('GrpCharArray','GroupName','c')

%%
str = char({'Experimental Design';'32 trials per session';...
    '32 reinforcers per session';'ITI: exponential with mean of 20s';...
    'Reinforcement only during ITIs, exponential w mean 20s';...
    'CS durs 10, 20, 40 & 80s';'All 4 CSdurs occurred randomly in rnd group';...
    'Reinforcement during both ITI and CS in random group,';...
    'exponential with mean of 50s to match to overall rate in other groups';...
    'Experiment ran for 35 sessions';' ';...
    'The function that estimates the acquisition point';...                
    'initializes the estimate to 1500, which is not a possible value,';... 
    'because there were not that many trials. This is done for graphic';...
    'reasons (so that failures to acquire are evident in the plots of';... 
    'the cumulative distributions of trials to acquisition). When we';...  
    'compute median trials to acquisition for the 5 groups, we set';...    
    'medians of 1500 to nan''s'});

Experiment.ExpNotes=str;