%This is the script for analyzing the variable-CS inhibtion data
%{
Design:
32 trials per session, 32 reinforcers per session.
 
ITI = mean of 20s with exponential distribution.
CS duration either 30 or 60.
Reinforcer delivery = exponential distributed w mean = 20s.
 
Pellets delivered only in the ITI for experimental groups,
%}
%% Creating an Experiment structure
TSinitexperiment('InhibAcq',1001,401:440,'Rat','Balsam') % Creates an
% Experiment structure and fills in the following fields:
% Experiment.Name = InhibAcq;
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

% TSloadsessions
% This calls up a browser, which allows you to browse for one of the
% data-containing folder. When you have found that folder, select it and
% click the Open button. The data files in that folder will be loaded.
% There are, however, 35 such folders. It is tedious to call TSloadsessions
% 35 times, browsing on each occassion. We can automate this process with
% the following code after using Matlab's file browser to make the folder
% that contains the Day 1, Day 2, etc folders Matlab's Current Folder

%%
cd('/Users/galliste/Dropbox/MyToolbox/TSlib/InstructionsManualTutorials/Manual/Examples/BalsamInhibAcq/Data2') % makes Data directory the current directory (Dr contains the complete path to Data directory)
for d = 1:35 % stepping through the Day subfolder
    FN = ['Day ' num2str(d)]; % constructing the name of the folder containing
    % the files we want to load
   
    TSloadsessions(FN) % calling TSloadsession to load the files in that directory
end

%% Creating fields at the Experiment level that specify which subjects are
% in which groups (experimental conditions)

Experiment.Grp30fix = [1.00 2.00 15.00 16.00 21.00 22.00 27.00 28.00]; % 

Experiment.Grp30var = [3.00 4.00 9.00 10.00 23.00 24.00 29.00 30.00]; % 

Experiment.Grp50fix = [5.00 6.00 11.00 12.00 17.00 18.00 31.00 32.00]; % 

Experiment.Grp50var = [7.00 8.00 13.00 14.00 19.00 20.00 25.00 26.00]; 
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
% Experiment.EventCodes.Toneon=61; % Creates a field named Toneon in the
% Experiment.EventCodes structure and enters the value 61. The field's name
% is the name of the variable that will appear in the workspace (but only
% when we declare event codes) and 61 will be the value of that variable

% Experiment.EventCodes.Toneoff=51; % Creates a field named Toneoff and enters
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
%
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

TScombineover('CSpkTms','Pktms','t') % to Session level

TScombineover('CSPkTms_S','CSpkTms','t') % to Subject level
%
TrlsPerSes = 32;
TSapplystat('CSPkTms_S','CSPkTms_S',@addCumTrlsCol,TrlsPerSes)
%{
function AugA = addCumTrlsCol(A,TrlsPerSes)
% adds column giving cumulative trials
A(:,end+1) = (A(:,3)-1)*TrlsPerSes+A(:,2);
AugA=A;
end
%}

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

% Aggregating statistics from the ITI trials into fields at the Session and
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

%% Computing trial-by-trial CS-ITI poke rate differences (CS poke rate on
% each trial minus the poke rate during the preceding ITI)

TSapplystat('CS_ITIrateDiffs',{'AllCSPkRates' 'AllITIPkRates'},@minus)
% Computes the trial-by-trial differences in the rate of poking during the
% CS and during the ITI that precedes the CS and puts the resulting vector
% of rate differences in a field at the Subject level, to which it assigns
% the name CS_ITIrateDiffs. The poke rates during the CS trials are in the
% AllCSPkRates field; the poke rates during the preceding ITIs are in the
% AllITIPkRates field. The helper function is Matlab's minus functions,
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

%% Aggregating Session by Session Mean CS, ITI and ITI-CS poke rates to
% groups at Experiment level
TSlimit('Subjects',Experiment.Grp30fix)
    Experiment.Subject(1).CSPkRateMeans(45)=NaN; % missing session
    Experiment.Subject(1).ITIPkRateMeans(45)=NaN; % ditto
    Experiment.Subject(1).ITI_CS_PkRateDiffMeans(45)=NaN; % ditto
    Experiment.Subject(2).CSPkRateMeans(45)=NaN; % ditto
    Experiment.Subject(2).ITIPkRateMeans(45)=NaN; % ditto
    Experiment.Subject(2).ITI_CS_PkRateDiffMeans(45)=NaN; % ditto
    TScombineover('Grp30fixCSPkRateMeans','CSPkRateMeans')
    TScombineover('Grp30fixITIPkRateMeans','ITIPkRateMeans')
    TScombineover('Grp30fixRateDiffMeans','ITI_CS_PkRateDiffMeans')
%
TSlimit('Subjects',Experiment.Grp30var)
    Experiment.Subject(3).CSPkRateMeans(45)=NaN; % missing session
    Experiment.Subject(3).ITIPkRateMeans(45)=NaN; % ditto
    Experiment.Subject(3).ITI_CS_PkRateDiffMeans(45)=NaN; % ditto
    TScombineover('Grp30varCSPkRateMeans','CSPkRateMeans')
    TScombineover('Grp30varITIPkRateMeans','ITIPkRateMeans')
    TScombineover('Grp30varRateDiffMeans','ITI_CS_PkRateDiffMeans')
%
TSlimit('Subjects',Experiment.Grp50fix)
    TScombineover('Grp50fixCSPkRateMeans','CSPkRateMeans')
    TScombineover('Grp50fixITIPkRateMeans','ITIPkRateMeans')
    TScombineover('Grp50fixRateDiffMeans','ITI_CS_PkRateDiffMeans')

TSlimit('Subjects',Experiment.Grp50var)
    Experiment.Subject(26).CSPkRateMeans(43:45)=nan(1,3); % missing session
    Experiment.Subject(26).ITIPkRateMeans(43:45)=nan(1,3); % ditto
    Experiment.Subject(26).ITI_CS_PkRateDiffMeans(43:45)=nan(1,3); % ditto
    TScombineover('Grp50varCSPkRateMeans','CSPkRateMeans')
    TScombineover('Grp50varITIPkRateMeans','ITIPkRateMeans')
    TScombineover('Grp50varRateDiffMeans','ITI_CS_PkRateDiffMeans') 
TSsaveexperiment
%% Graphing Session-by-Session CS, ITI & Diff Poke Rate Means by Group
Hanova = figure;
subplot(2,2,1)
plot(nanmean(Experiment.Grp30fixCSPkRateMeans),'k-')
hold on
plot(nanmean(Experiment.Grp30varCSPkRateMeans),'k--')
plot(nanmean(Experiment.Grp50fixCSPkRateMeans),'k-.')
plot(nanmean(Experiment.Grp50varCSPkRateMeans),'k:')
ylim([0 .8]);xlim([0 46])
xlabel('Session')
ylabel('CS Pokes/s')
legend('CS30fix','CS30var','CS50fix','CS50var','location','NW')

subplot(2,2,2)
plot(nanmean(Experiment.Grp30fixITIPkRateMeans),'k-')
hold on
plot(nanmean(Experiment.Grp30varITIPkRateMeans),'k--')
plot(nanmean(Experiment.Grp50fixITIPkRateMeans),'k-.')
plot(nanmean(Experiment.Grp50varITIPkRateMeans),'k:')
ylim([0 .8]);xlim([0 46])
xlabel('Session')
ylabel('ITI Pokes/s)')

subplot(2,2,4)
plot(mean(Experiment.Grp30fixRateDiffMeans),'k-')
hold on
plot(mean(Experiment.Grp30varRateDiffMeans),'k--')
plot(mean(Experiment.Grp50fixRateDiffMeans),'k-.')
plot(nanmean(Experiment.Grp50varRateDiffMeans),'k:')
ylim([-.1 .35]);xlim([0 46])
xlabel('Session')
ylabel('ITI-CS Pokes/s')

subplot(2,2,3); % The p values, which are obtained from the ANOVAs,
% will be written into this panel
set(gca,'XTick',[],'YTick',[])
set(Hanova,'Name','E3 ANOVA','Position',[1105.00 1128.00 573.00 742.00]);

%% Creating Arrays for ANOVAs

% Creating array to be fed to CS ANOVA
MinNumSes = 42; % the number of sessions for subject with fewest
TSapplystat('CSpkRateByDayByGroup',{'Grp30fixCSPkRateMeans' ...
    'Grp30varCSPkRateMeans' 'Grp50fixCSPkRateMeans' ...
    'Grp50varCSPkRateMeans'},@vct3,MinNumSes)
% Creating the 5-column "long table" to be fed to the anovan command and
% putting it in a field at the Experiment level named CSpkRateByDayByGroup.
% Col 1 = data (mean poke rate in a session); Col 2 = Session; Col 3 = Subs
% Col 4 = CS duration; Col 5 = Fixed vs Variable CS duration). This is the
% data format required by the anovan function and by  the similar functions
% in other statistical packages (e.g., by the TidyVerse package in R)
    %{
    function Aout = vct3(A1,A2,A3,A4,ns)
    % vertically concatenates the arrays for the 4 groups and eliminates the
    % "supernumerary" sessions, so that all groups have the same number of
    % sessions; ns = # of sessions to be entered into the ANOVA

    % Deleting supernumerary sessions
    A1(:,ns+1:end)=[];
    A2(:,ns+1:end) =[];
    A3(:,ns+1:end) =[]; 
    A4(:,ns+1:end) =[]; 

    % Building array
    Aout = [reshape(A1',[],1);reshape(A2',[],1);reshape(A3',[],1);reshape(A4',[],1)];
    % the data column

    N = 4*8; % number of subjects
    sesnums = (1:ns)'; % sequence of ns sessions for one subject
    Aout(:,2) = repmat(sesnums,N,1); % column for session numbers
    subnums = 1:32; % different # for each subject

    Aout(:,3) = reshape(repmat(subnums,ns,1),[],1); % column for subjects
    Aout(:,4) = [ones(16*ns,1);2*ones(16*ns,1)];% CS dur (Col 4)
    Aout(:,5) = repmat([ones(8*ns,1);2*ones(8*ns,1)],2,1); % Fixed vs Variable
    % CS duration (Col 5)
    %}

% Creating array to be fed to ITI ANOVA
TSapplystat('ITIpkRateByDayByGroup',{'Grp30fixITIPkRateMeans' ...
    'Grp30varITIPkRateMeans' 'Grp50fixITIPkRateMeans' ...
    'Grp50varITIPkRateMeans'},@vct3,MinNumSes)

% Creating array to be fed to ITI-CS ANOVA
TSapplystat('ITI_CSRateDiffByDayByGroup',{'Grp30fixRateDiffMeans' ...%Grp30fixRateDiffMeans
    'Grp30varRateDiffMeans' 'Grp50fixRateDiffMeans' ...
    'Grp50varRateDiffMeans'},@vct3,MinNumSes)
TSsaveexperiment

%% CS ANOVA
% Col 1 is the data; remaining columns are the factors:
VarNames = {'Session', 'Subject','CSdur','FixVar'};
% Subject is nested within group, so:
NestMatrx = [0 0 0 0;0 0 1 1;0 0 0 0;0 0 0 0]; % subject is nested within
% CSdur and within FixVar
% Subject (the 2nd factor) is a random factor, so
rnd = 2;
% The model type is 'interaction' (only the 2-way interactions), so:
mdl = 'interaction';
% I assume we should use the type 3 sum of squares (the default)
TSapplystat('CSpkRateBySesByGrpANOVApVals','CSpkRateByDayByGroup',...
    @GroupBySesANOVA3,mdl,NestMatrx,rnd,VarNames)
% Field CSpkRateBySesByGrpANOVApVals at Experiment level with table of p
% values
%{
function ptbl = GroupBySesANOVA3(A,mdl,nst,rnd,vars)
p = anovan(A(:,1),{(A(:,2)) (A(:,3)) (A(:,4)) (A(:,5))},'model',...
    mdl,'nested',nst,'random',rnd,'varnames',vars); 
if p(1)<.001
    Pca{1} = 'Session p<.001';
else
    Pca{1} = ['Session p=' num2str(p(1),3)];
end
if p(2)<.001
    Pca{2} = 'Subject(30or50,FixVar) p<.001';
else
    Pca{2} = ['Subject(Group) p=' num2str(p(2),3)];
end
if p(3)<.001
    Pca{3} = '30or50 p<.001';
else
    Pca{3} = ['30or50 p=' num2str(p(3),3)];
end
if p(4)<.001
    Pca{4} = 'FixVar p<.001';
else
    Pca{4} = ['FixVar p=' num2str(p(4),3)];
end
if p(6)<.001
    Pca{5} = 'Session*30or50 p<.001';
else
    Pca{5} = ['Session*30or50 p=' num2str(p(6),3)];
end
if p(7)<.001
    Pca{6} = 'Session*FixVar p<.001';
else
    Pca{6} = ['Session*30or50 p=' num2str(p(7),3)];
end
if p(8)<.001
    Pca{7} = '30or50*FixVar p<.001';
else
    Pca{7} = ['30or50*FixVar p=' num2str(p(8),3)];
end
ptbl = char(Pca) 

   Source                          Sum Sq.   d.f.   Mean Sq.     F     Prob>F
----------------------------------------------------------------------------
  Session                          2.3005     41    0.05611    4.19   0     
  Subject(CSdur,FixVar)           23.3504     28    0.83394   62.3    0     
  CSdur                            0.2027      1    0.20273    0.24   0.6258
  FixVar                           0.0375      1    0.03745    0.04   0.8337
  Session*Subject(CSdur,FixVar)   15.9158   1189    0.01339     Inf      NaN
  Session*CSdur                    0.5282     41    0.01288    0.96   0.5394
  Session*FixVar                   0.7929     41    0.01934    1.44   0.0356
  CSdur*FixVar                     0.3309      1    0.33089    0.4    0.5339
  Error                           -0           0   -0                       
  Total                           43.4589   1343                                                        
 
%}
%% ITI ANOVA
TSapplystat('ITIpkRateBySesByGrpANOVApVals','ITIpkRateByDayByGroup',...
    @GroupBySesANOVA3,mdl,NestMatrx,rnd,VarNames)
% Field CSpkRateBySesByGrpANOVApVals at Experiment level with table of p
% values
%{
  Source                          Sum Sq.   d.f.   Mean Sq.     F     Prob>F
----------------------------------------------------------------------------
  Session                          9.9049     41    0.24158   14.04   0     
  Subject(CSdur,FixVar)           32.6559     28    1.16628   67.77   0     
  CSdur                            1.7571      1    1.75714    1.51   0.2299
  FixVar                           0.9335      1    0.93353    0.8    0.3786
  Session*Subject(CSdur,FixVar)   20.4625   1189    0.01721     Inf      NaN
  Session*CSdur                    0.8493     41    0.02072    1.2    0.1792
  Session*FixVar                   1.015      41    0.02476    1.44   0.0374
  CSdur*FixVar                     1.0585      1    1.05849    0.91   0.3489
  Error                           -0           0   -0                       
  Total                           68.6368   1343                                                                                   
%}
%% ITI-CS ANOVA
TSapplystat('ITI_CSRateDiffANOVApVals','ITI_CSRateDiffByDayByGroup',...
    @GroupBySesANOVA3,mdl,NestMatrx,rnd,VarNames)
% Field CSpkRateBySesByGrpANOVApVals at Experiment level with table of p
% values
%{
    Source                          Sum Sq.   d.f.   Mean Sq.     F     Prob>F
----------------------------------------------------------------------------
  Session                          5.4237     41   0.13229    16.73   0     
  Subject(CSdur,FixVar)            8.7695     28   0.3132     39.61   0     
  CSdur                            3.1536      1   3.15357    10.07   0.0036
  FixVar                           0.597       1   0.597       1.91   0.1783
  Session*Subject(CSdur,FixVar)    9.4019   1189   0.00791      Inf      NaN
  Session*CSdur                    0.8139     41   0.01985     2.51   0     
  Session*FixVar                   0.2646     41   0.00645     0.82   0.7898
  CSdur*FixVar                     0.2058      1   0.20575     0.66   0.4245
  Error                            0           0   0                        
  Total                           28.6299   1343                                                        
%}

TSsaveexperiment

%% Putting p values on the ANOVA plots
figure(Hanova)
subplot(2,2,3) % activating lower left subplot
ptxts = Experiment.CSpkRateBySesByGrpANOVApVals;
text(.05,.75,{'CS ANOVA';['   p_s_e_s' ptxts(1,9:end)];['   p_d_u_r' ptxts(3,9:end)];...
    ['   p_f_v' ptxts(4,9:end)];['   p_s_*_d_u_r' ptxts(5,17:end)];...
    ['p_s_*_f_v' ptxts(6,18:end)];['p_d_*_f_v' ptxts(7,15:end)]},'FontSize',12)

ptxts = Experiment.ITIpkRateBySesByGrpANOVApVals;
text(.6,.75,{'ITI ANOVA';['   p_s_e_s' ptxts(1,9:end)];['   p_d_u_r' ptxts(3,9:end)];...
    ['   p_f_v' ptxts(4,9:end)];['   p_s_*_d_u_r' ptxts(5,17:end)];...
    ['p_s_*_f_v' ptxts(6,18:end)];['p_d_*_f_v' ptxts(7,15:end)]},'FontSize',12)

ptxts = Experiment.ITI_CSRateDiffANOVApVals;
text(.3,.25,{'ITI-CS ANOVA';['   p_s_e_s' ptxts(1,9:end)];['   p_d_u_r' ptxts(3,9:end)];...
    ['   p_f_v' ptxts(4,9:end)];['   p_s_*_d_u_r' ptxts(5,17:end)];...
    ['p_s_*_f_v' ptxts(6,18:end)];['p_d_*_f_v' ptxts(7,15:end)]},'FontSize',12)
%
saveas(Hanova,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 3/' ...
    get(Hanova,'Name') '.pdf']);

TSsaveexperiment

%% Plotting just the fixed and just the variable groups & just the 30 & just
% the 50s groups
D = Experiment.CSpkRateGrpBySessionMs;
figure
subplot(2,2,1)
    plot(1:length(D),D(:,1),'k--',1:length(D),D(:,3),'k-')
    xlim([0 45]);ylim([.1 .55])
    legend('Fixed30','Fixed50','location','S')
    ylabel('Mean Pokes/s in CS')
    title('Contrasting CS Durations')
subplot(2,2,3)
    plot(1:length(D),D(:,2),'k--',1:length(D),D(:,4),'k-')
    xlim([0 45]);ylim([.1 .55])
    legend('Var30','Var50','location','S')
    xlabel('Session');ylabel('Mean Pokes/s in CS')
subplot(2,2,2)
    plot(1:length(D),D(:,1),'k--',1:length(D),D(:,2),'k-')
    xlim([0 45]);ylim([.1 .55])
    legend('Fixed30','Var30','location','S')
    title('Contrasting Fixed vs Variable')
subplot(2,2,4)
    plot(1:length(D),D(:,3),'k--',1:length(D),D(:,4),'k-')
    xlim([0 45]);ylim([.1 .55])
    legend('Fixed50','Var50','location','S')
    xlabel('Session')
    
%% Computing CSoff Informativeness
TSlimit('Subjects','all')
TSsettrialtype('ITI')
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
TSlimit('Subjects',Experiment.Grp30fix)
TScombineover('Grp30fixInformativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.Grp30var)
TScombineover('Grp30varInformativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.Grp50fix)
TScombineover('Grp50fixInformativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.Grp50var)
TScombineover('Grp50varInformativeness','CSoffInformativeness')
TSsaveexperiment
%% Computing Acquisition Points. We define the acquisition point to be the point at
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
TSlimit('Subjects',Experiment.Grp30fix)
TScombineover('Grp30fixAcqPts','AcqPt')
%
TSlimit('Subjects',Experiment.Grp30var)
TScombineover('Grp30varAcqPts','AcqPt')

TSlimit('Subjects',Experiment.Grp50fix)
TScombineover('Grp50fixAcqPts','AcqPt')

TSlimit('Subjects',Experiment.Grp50var)
TScombineover('Grp50varAcqPts','AcqPt')

% Plotting cumulative distributions of acquisition points
TSapplystat('',{'Grp30fixAcqPts' 'Grp30varAcqPts' 'Grp50fixAcqPts' 'Grp50varAcqPts'},...
    @TSplotcdfs,'Rows',1,'Cols',1,'DataCols',{(1) (1) (1) (1)},'Xlbl',...
    'Acquisition Trial','Ylbl','Cumulative Fraction of Subjects','Xlm',[0 1100])
set(get(gca,'Children'),'LineWidth',2)
set(gca,'FontSize',18)
legend('Grp30fix','Grp30var','Grp50fix','Grp50var','Location','SE')
saveas(gcf,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 3/' ...
    'E3 CDFsOfAcqPts.pdf']);
TSsaveexperiment
%% Median Trials to Acquisition 
% 
TSapplystat('MedianTrlsToAcq',...
    {'Grp30fixAcqPts' 'Grp30varAcqPts' 'Grp50fixAcqPts' 'Grp50varAcqPts'},...
    @AcqMedians)
%{
function AM = AcqMedians(D1,D2,D3,D4)
AM(:,1) = [1;2;3;4]; % Group ID #s
AM(:,2) = median([D1 D2 D3 D4])';
AM(AM(:,2)==1500,2) = nan; % median = 1500 is impossible. This arises
% because we initialized estimated acquisition points to 1500 for graphic
% reasons (so that failures to acquire were evident in cumulative
% distributions of acquisition points)
%{
Group IDs
1 = CS30fix
2 = CS30var
3 = CS50fix
4 = CS50var
%}
%}

%% Mean CS-ITI rate difference post acquisition
TSlimit('Subjects','all')
TSapplystat('MnPostAcqRateDiff',{'CS_ITIrateDiffs' 'AcqPt'},@PostAcqMnRateDiff)
% field at Subject level

% Experiment level aggregation of post acquisition mean rate diffs
TSlimit('Subjects',Experiment.Grp30fix)
TScombineover('Grp30fixMnPostAcqRateDiff','MnPostAcqRateDiff')

TSlimit('Subjects',Experiment.Grp30var)
TScombineover('Grp30varMnPostAcqRateDiff','MnPostAcqRateDiff')

TSlimit('Subjects',Experiment.Grp50fix)
TScombineover('Grp50fix30MnPostAcqRateDiff','MnPostAcqRateDiff')

TSlimit('Subjects',Experiment.Grp50var)
TScombineover('Grp50varMnPostAcqRateDiff','MnPostAcqRateDiff')

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
TSlimit('Subjects',Experiment.Grp30fix)
TScombineover('Grp30fixPrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('Grp30fixPrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')
%
TSlimit('Subjects',Experiment.Grp30var)
TScombineover('Grp30varPrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('Grp30varPrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')
%
TSlimit('Subjects',Experiment.Grp50fix)
TScombineover('Grp50fixPrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('Grp50fixPrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')

TSlimit('Subjects',Experiment.Grp50var)
TScombineover('Grp50varPrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('Grp50varPrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')

TSsaveexperiment

%% Distributions of the pre- and post-acq poke rate differences
CSdiffs=[Experiment.Grp30fixPrePstCSpkRateDiffs;Experiment.Grp30varPrePstCSpkRateDiffs;...
    Experiment.Grp50fixPrePstCSpkRateDiffs;Experiment.Grp50varPrePstCSpkRateDiffs];
ITIdiffs=[Experiment.Grp30fixPrePstITIpkRateDiffs;Experiment.Grp30varPrePstITIpkRateDiffs;...
    Experiment.Grp50fixPrePstITIpkRateDiffs;Experiment.Grp50varPrePstITIpkRateDiffs];
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
title('Experiment 3 ("varCS")')
saveas(gcf,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 3/' ...
    'E3 CDFsPrePstCS&ITIRateDiffs.pdf'])   

%% Post Acquisition Pks/s in Decile Bin Widths Up to Mean CS Dur for Variable CSs
TSlimit('Subjects',[Experiment.Grp30var Experiment.Grp50var])
TSapplystat('PksPerSecInDecilesOfMeanCSdur',{'AllCSdurs' 'CSPkTms_S' 'AcqPt'},...
    @PkRatesInCSdeciles)
% CSPkTms_S is 4-col field; Col 1 = pktmes; Col 2 = trl #; Col 3 = ses #;
% Col 4 = cum trial #
%{
function O = PkRatesInCSdeciles(drs,A,ap)
% A is 4-col field; Col 1 = pktmes; Col 2 = trl #; Col 3 = ses #;
% Col 4 = cum trial #
O = nan(10,1);
if ap>length(drs) % didn't acquire
    O=[];
    return
end
dr = round(mean(drs)); % mean duration of CS interval
drs = [drs (1:length(drs))']; % adding col w trial #s
drs(1:ap,:) = []; % discarding trials before acquisition
LVp = A(:,4)<=ap; % flags trials before acqusition
A(LVp,:) =[]; % discarding pre-acquisition trials
Edges = 0:.1*dr:dr; % bin edges
bw = Edges(2) - Edges(1); % bin width in seconds
% to be counted in a bin, a poke time has to come from a trial that lasted
% as long or longer than the upper end of the bin and the poke time has to
% be > than the lower edge of the bin and not longer (<=) the upper edge
for i = 1:10 % stepping through the bins making the counts
    LVa = drs(:,1)>=Edges(i+1); % flags trials contributing counts to the bin
    Tnms = drs(LVa,2); % the trial numbers for trials longer than upper edge of bin
    LVtnms = ismember(A(:,4),Tnms); % flags all the rows in A that come
    % trials lasting at least as long as upper edge)
    LV = (A(:,1)>Edges(i))&(A(:,1)<=Edges(i+1)); % flags pk times falling
    % between the bin edges
    O(i) = sum(LVtnms&LV)/(sum(LVa)*bw); % pokes/s in i^th bin; 
end
%}

%% Plotting decile post-acquisition profiles for variable CSs

plt=1;
figure
for S = Experiment.Grp30var
    subplot(4,2,plt)
    C30 = 1.5:3:28.5;
    bar(C30,Experiment.Subject(S).PksPerSecInDecilesOfMeanCSdur',1)
    xlim([0 30])
    title(['S' num2str(S)])
    if plt>6
        xlabel('Time Elapsed in CS (s)')
    end
    if mod(plt,2)>0
        ylabel('Pokes/s')
    end
    plt=plt+1;
end
saveas(gcf,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 3/' ...
    'E3 CS30varDecileProfiles.pdf'])
plt=1;
figure
for S = Experiment.Grp50var
    subplot(4,2,plt)
    C50 = 2.5:5:47.5;
    bar(C50,Experiment.Subject(S).PksPerSecInDecilesOfMeanCSdur',1)
    xlim([0 50])
    title(['S' num2str(S)])
    if plt>6
        xlabel('Time Elapsed in CS (s)')
    end
    if mod(plt,2)>0
        ylabel('Pokes/s')
    end
    plt=plt+1;
end
saveas(gcf,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 3/' ...
    'E3 CS50varDecileProfiles.pdf'])
%% Post-Acquisition Pks/s in Decile Bins for Fixed CSs
TSlimit('Subjects',[Experiment.Grp30fix Experiment.Grp50fix])
nb = 10; % number of bins
TSapplystat('PstAcqPksPerSecInDeciles',{'CSPkTms_S' 'AllCSdurs' 'AcqPt'},...
    @Profile,nb)
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
N(end) =[]; % deleting terminal 0
PstAcqTrls = TtlTrls - AcqTrl; % # of post-acq trials
O = N/(PstAcqTrls*SecsPerBin); % pokes/s in each bin
end  
%}
%    
% Plotting profiles  of post-acq responding w/i decile bins fixed dur CS  
plt=1;
figure
for S = Experiment.Grp30fix
    subplot(4,2,plt)
    if isempty(Experiment.Subject(S).PstAcqPksPerSecInDeciles)
        text(.3,.5,'Never Acquired')
        plt=plt+1;
        continue
    end
    C30 = 1.5:3:28.5;
    bar(C30,Experiment.Subject(S).PstAcqPksPerSecInDeciles(1:10),1)
    xlim([0 30])
    title(['S' num2str(S)])
    if plt>6
        xlabel('Time Elapsed in CS (s)')
    end
    if mod(plt,2)>0
        ylabel('Pokes/s')
    end
    plt=plt+1;
end
saveas(gcf,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 3/' ...
    'E3 CS30fixDecileProfiles.pdf'])
plt=1;
figure
for S = Experiment.Grp50fix
    subplot(4,2,plt)
    C50 = 2.5:5:47.5;
    bar(C50,Experiment.Subject(S).PstAcqPksPerSecInDeciles(1:10),1)
    xlim([0 50])
    title(['S' num2str(S)])
    if plt>6
        xlabel('Time Elapsed in CS (s)')
    end
    if mod(plt,2)>0
        ylabel('Pokes/s')
    end
    plt=plt+1;
end 
saveas(gcf,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 3/' ...
    'E3 CS50fixDecileProfiles.pdf'])
%% Aggregating Post-Acq CS Decile Profiles by Group to Experiment level
TSlimit('Subjects',Experiment.Grp30var)
    TScombineover('G30varPstAcqPksPrSecByDecile','PksPerSecInDecilesOfMeanCSdur','t') % 60x2 array
    TSapplystat({'G30varProfileMean' 'G30varProfileSE'},'G30varPstAcqPksPrSecByDecile',@ProfMean)
    %{
    function [M,SE] = ProfMean(A)
    % A is 2-col array with deciles repeated in 2nd col
    Ar = reshape(A(:,1),10,[]);
    M = mean(Ar,2);
    SE = std(Ar,0,2)/sqrt(size(Ar,2));
    %}
TSlimit('Subjects',Experiment.Grp50var)
    TScombineover('G50varPstAcqPksPrSecByDecile','PksPerSecInDecilesOfMeanCSdur','t')
    TSapplystat({'G50varProfileMean' 'G50varProfileSE'},'G50varPstAcqPksPrSecByDecile',@ProfMean)
TSlimit('Subjects',Experiment.Grp30fix)
    TScombineover('G30fixPstAcqPksPrSecByDecile','PstAcqPksPerSecInDeciles','t')
    TSapplystat({'G30fixProfileMean' 'G30fixProfileSE'},'G30fixPstAcqPksPrSecByDecile',@ProfMean)
TSlimit('Subjects',Experiment.Grp50fix)
    TScombineover('G50fixPstAcqPksPrSecByDecile','PstAcqPksPerSecInDeciles','t')
    TSapplystat({'G50fixProfileMean' 'G50fixProfileSE'},'G50fixPstAcqPksPrSecByDecile',@ProfMean)

%% Errorbar Graphs of Group Within-CS Post-Acq Response Freq Profiles
Nms = {'1' '15' '30'};
figure
Ax1=subplot(2,2,1);
    TSapplystat('',{'G30fixProfileMean' 'G30fixProfileSE'},...
        @EB,Ax1,Nms)
    %{
    function EB(m,se,Ax,Nms)
    figure
    errorbar(Ax,1:10,m,se,se)
    set(gca,'XTick',[1 5 10],'XTickLabel',Nms)    
    %}
        title('CS dur Fixed')
Ax2=subplot(2,2,2);
    Nms = {'1' '15' '30'};
    TSapplystat('',{'G30varProfileMean' 'G30varProfileSE'},...
        @EB,Ax2,Nms)
    title('CS dur Exponential')

Ax3=subplot(2,2,3);
    Nms = {'1' '25' '50'};
    TSapplystat('',{'G50fixProfileMean' 'G50fixProfileSE'},...
        @EB,Ax3,Nms);xlabel('Elapsed CS Time (s)')
    

Ax4=subplot(2,2,4);
    Nms = {'1' '25' '50'};
    TSapplystat('',{'G50varProfileMean' 'G50varProfileSE'},...
        @EB,Ax4,Nms);xlabel('Elapsed CS Time (s)')

        
%% ANOVAs for effect of fixed vs variable CS on Decile Profile
TSapplystat('G30FixVarANOVAarray',{'G30fixPstAcqPksPrSecByDecile' ...
    'G30varPstAcqPksPrSecByDecile'},@FVarray)
%{
function A = FVarray(Af,Av)
%Creates long-table array to be fed to ANOVA
Af(:,3) = repmat((1:10)',numel(unique(Af(:,2))),1); % deciles column
Af(:,4) = ones(length(Af),1); % fix-variable column

Av(:,3) = repmat((1:10)',numel(unique(Av(:,2))),1); % deciles column
Av(:,4) = 2*ones(length(Av),1); % fix-variable column

A = [Af;Av];
end
%}
%%
VarNames = {'Subject', 'Decile','FixVar'};
% Subject is nested within group, so:
NestMatrx = [0 0 1;0 0 0;0 0 0]; % subject is nested within fixed-variable
% Subject (the 1st factor) is a random factor, so
rnd = 1;
% The model type is 'interaction' (only the 2-way interactions), so:
mdl = 'interaction';

TSapplystat('PstAcqFixVarCS30sANOVApVals','G30FixVarANOVAarray',...
    @FVANOVA,mdl,NestMatrx,rnd,VarNames)
    %{
    function ptbl = FVANOVA(A,mdl,nst,rnd,vars)
    p = anovan(A(:,1),{(A(:,2)) (A(:,3)) (A(:,4))},'model',...
        mdl,'nested',nst,'random',rnd,'varnames',vars); 
    if p(1)<.001
        Pca{1} = 'Subject p<.001';
    else
        Pca{1} = ['Subject p=' num2str(p(1),3)];
    end
    if p(2)<.001
        Pca{2} = 'Decile) p<.001';
    else
        Pca{2} = ['Decile p=' num2str(p(2),3)];
    end
    if p(3)<.001
        Pca{3} = 'FixVar p<.001';
    else
        Pca{3} = ['FixVar p=' num2str(p(3),3)];
    end
    if p(5)<.001
        Pca{4} = 'Decile*FixVar p<.001';
    else
        Pca{4} = ['Decile*FixVar p=' num2str(p(5),3)];
    end

    ptbl = char(Pca) 
      Source                   Sum Sq.    d.f.   Mean Sq.     F      Prob>F
-----------------------------------------------------------------------
      Subject(FixVar)           2.20225    12     0.18352   181.85   0     
      Decile                    0.13505     9     0.01501    14.87   0     
      FixVar                    0.06252     1     0.06252     0.34   0.5703
      Subject(FixVar)*Decile    0.10899   108     0.00101      Inf   NaN
      Decile*FixVar             0.03014     9     0.00335     3.32   0.0013
      Error                    -0           0    -0                        
      Total                     2.55055   139                              
    %}
    
%%
TSapplystat('G50FixVarANOVAarray',{'G50fixPstAcqPksPrSecByDecile' ...
    'G50varPstAcqPksPrSecByDecile'},@FVarray)
TSapplystat('PstAcqFixVarCS50sANOVApVals','G50FixVarANOVAarray',...
    @FVANOVA,mdl,NestMatrx,rnd,VarNames)
    %{
      Source                   Sum Sq.   d.f.   Mean Sq.     F     Prob>F
---------------------------------------------------------------------
      Subject(FixVar)          3.0545     14    0.21818    98.36   0     
      Decile                   0.43665     9    0.04852    21.87   0     
      FixVar                   0.19365     1    0.19365     0.89   0.3621
      Subject(FixVar)*Decile   0.27949   126    0.00222      Inf   NaN
      Decile*FixVar            0.14971     9    0.01663     7.5    0     
      Error                    0           0    0                        
      Total                    4.114     159                             
    %}
TSsaveexperiment

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
TSlimit('Subjects',Experiment.Grp30fix)
    TScombineover('Grp30fUSsAtAcq','USsAtAcquisition')
TSlimit('Subjects',Experiment.Grp30var)
    TScombineover('Grp30vUSsAtAcq','USsAtAcquisition')
TSlimit('Subjects',Experiment.Grp50fix)
    TScombineover('Grp50fUSsAtAcq','USsAtAcquisition')
TSlimit('Subjects',Experiment.Grp50var)
    TScombineover('Grp50vUSsAtAcq','USsAtAcquisition')
    
%% Average # of USs per ITI
TSlimit('all')
TSapplystat('USperITI',{'AllITIdurs' 'AllITIUSs'},@USsPerITI)

TSlimit('Subjects',Experiment.Grp30fix)
    TScombineover('Grp30fixUSsPerITI','USperITI')
TSlimit('Subjects',Experiment.Grp30var)
    TScombineover('Grp30varUSsPerITI','USperITI')
TSlimit('Subjects',Experiment.Grp50fix)
    TScombineover('Grp50fixUSsPerITI','USperITI')
TSlimit('Subjects',Experiment.Grp50var)
    TScombineover('Grp50varUSsPerITI','USperITI')
    
%% Subject level summary stats for assembly at Experiment level and export 
% to long table
TSlimit('Subjects','all')
E = 3; % Experiment #
TSapplystat({'SummaryArray' 'GroupName'},{'AllCSdurs' 'AllITIdurs' 'AllITIUSs' 'AcqPt' ...
    'CSpreAcqPstAcqPkRateDiff' 'ITIpreAcqPstAcqPkRateDiff'},@SubSummary3,E)
%{
function [Sm,Gnm] = SubSummary3(CSdrs,ITIdrs,ITIUSs,AcqPt,CSprepst,ITIprepst,E)
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
if isempty(Gnm) % this subject was not in any group
    Sm = double.empty(0,24);
    return
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
if ~isempty(CSprepst)
    Sm(13) = CSprepst; % mean CS pk rate after acq - mean before acq
    Sm(14) = ITIprepst; % ditto fo ITI
    if E~=3
        Sm(15:24) = Experiment.Subject(sb).PkRateProfileInCSpostAcq(1:10);
    elseif strfind(Gnm,'var')
        Sm(15:24) = Experiment.Subject(sb).PksPerSecInDecilesOfMeanCSdur;
    else
        Sm(15:24) = Experiment.Subject(sb).PstAcqPksPerSecInDeciles(1:10);
    end
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
    '32 trials per session, 32 reinforcers per session.'
    'At least 42 sessions for each subject.'
    'ITI = mean of 20s with exponential distribution.'
    ''
    'Mean CS duration was either 30 or 50s.'
    'For one group at each mean CS duration,the duration'
    'was fixed; for another it varied exponentially.'
    ''
    'Reinforcer delivery = exponential distributed w mean = 20s.'
    ''
    'Pellets delivered only in the ITIs.'
    ' '
    'Analysis Notes:'
    'The function that estimates the acquisition point'
    'initializes the estimate to 1500, which is not a possible value,'
    'because there were not that many trials. This is done for graphic'
    'reasons (so that failures to acquire are evident in the plots of'
    'the cumulative distributions of trials to acquisition). When we'
    'compute median trials to acquisition for the 5 groups, we set'
    'medians of 1500 to nan'});

