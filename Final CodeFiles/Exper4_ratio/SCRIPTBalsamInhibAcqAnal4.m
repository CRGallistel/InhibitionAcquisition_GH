%This is the script for analyzing the InhibExper4_ratio data
%{
Design:


Sessions 1:44 were inhibitory conditioning, with no USs during CSs;
Sessions 45:end were "resistance to extinction" sessions, with USs during
the CSs
%}
%% Creating an Experiment structure
ExpName='/Users/galliste/Dropbox/InhibitoryExperiments_All/ExperimentStructures/InhibExper4_ratio';
% By putting complete path in the name of the Experiment structure, the
% structure is automatically saved in the correct location whenever one
% calls TSsaveexperiment
TSinitexperiment(ExpName,1001,401:440,'Rat','Balsam') % Creates an
% Experiment structure and fills in the following fields:
% Experiment.Name = /Users/galliste/Dropbox/InhibitoryExperiments_All/ExperimentStructures/InhibExper4_ratio;
% Experiment.ID = 1001;
% Experiment.Subjects = the row vector [401 402 403 ... 440]
% Experiment.Species = Rat
% Experiment.Lab = Balsam
% The TSinitexperiment function counts the number of elements in the vector
% of subject ID numbers and then fills in another field:
% Experiment.NumSubjects = 40

% Loading into the structure information necessary to the loading of data

TSsetloadparameters('InputTimeUnit',.1,'OutputTimeUnit',1,'LoadFunction',...
'TSloadBalsamRaw4','FilePrefix','R','FileExtension','.txt') % Put into the
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
% cd('C:\Users\pbalsam\Dropbox\Conditioned Inhibition\Rat CI\Ratio Inhibition\Data')
cd('/Users/galliste/Dropbox/balsam rat ci/Ratio Inhibition/Data')
% makes Data directory the current directory (Dr contains the complete path
% to Data directory)
for d = 1:44 % stepping through the Day subfolder
    FN = ['Day ' num2str(d)]; % constructing the name of the folder containing
    % the files we want to load
   
    TSloadsessions(FN) % calling TSloadsession to load the files in that directory
end

for d = 45:62 % stepping through the Day subfolder
    FN = ['Ph 2 Day ' num2str(d)]; % constructing the name of the folder containing
    % the files we want to load
   
    TSloadsessions(FN) % calling TSloadsession to load the files in that directory
end
% loaded data and saved structure Thursday 1/26/17 CRG
       
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

TSsaveexperiment

%% Creating fields at the Experiment level that specify which subjects are
% in which groups (experimental conditions)

Experiment.GrpUS20_CS20 = [1 2 17 18 29 30 35 36]; % The group for which 
% the inhibitory CS lasted 20s. 

Experiment.GrpUS20_CS40 = [3 4 19 20 21 22 37 38]; % see above

Experiment.GrpUS40_CS20 = [5 6 11 12 23 24 39]; % see above; S 40 was
% supposed to be in this group but it did not get rewarded during ITI until
% AFTER Session 44 (when other Ss went into extinction)

Experiment.GrpUS40_CS40 = [7 8 13 14 25 26 31 32]; % see above

Experiment.GrpUS40_CS80 = [9 10 15 16 27 28 33 34]; % 

%% Setting Phase fields
% The phase (condition) information was not in the session files, and it
% changed after 44 sessions, so we have to enter the phase info here. In
% the 2nd phase, there were USs during the CS
CmbGrps = [Experiment.GrpUS20_CS20';Experiment.GrpUS20_CS40';...
    Experiment.GrpUS40_CS20';Experiment.GrpUS40_CS40';Experiment.GrpUS40_CS80'];
for S=1:40 % stepping through subjects
    [~,LOCB]=ismember(S,CmbGrps(:)'); 
    G = mod(LOCB,5); % group membership: 1:4 = 1:4; 0 =5
%     keyboard
   
    switch G
        case 1
            for s = 1:44
                Experiment.Subject(S).Session(s).Phase = 11;
            end
            
            for s = 45:Experiment.Subject(S).NumSessions
                Experiment.Subject(S).Session(s).Phase = 12;
            end
            
        case 2
            for s = 1:44
                Experiment.Subject(S).Session(s).Phase = 21;
            end
            
            for s = 45:Experiment.Subject(S).NumSessions
                Experiment.Subject(S).Session(s).Phase = 22;
            end
            
        case 3
            for s = 1:44
                Experiment.Subject(S).Session(s).Phase = 31;
            end
            
            for s = 45:Experiment.Subject(S).NumSessions
                Experiment.Subject(S).Session(s).Phase = 32;
            end
            
        case 4
            for s = 1:44
                Experiment.Subject(S).Session(s).Phase = 41;
            end
            
            for s = 45:Experiment.Subject(S).NumSessions
                Experiment.Subject(S).Session(s).Phase = 42;
            end
            
        otherwise
            for s = 1:44
                Experiment.Subject(S).Session(s).Phase = 51;
            end
            
            for s = 45:Experiment.Subject(S).NumSessions
                Experiment.Subject(S).Session(s).Phase = 52;
            end   
    end % of switch
end % subject loop
                 
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
%
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

%% Aggregating ststistics from the CS trials into fields at the Session and
% Subject levels
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
%
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

TSlimit('Sessions',1:44) %These were the acquisition sessions, during which
% there were no USs during the CSs
TScombineover('AcqCSPkRates','CSPkRates') % Aggregates the vector of CS poke
% rates in the CSPkRates fields at the Session level into a field at the
% Subject level, to which it assigns the name AcqCSPkRates

TScombineover('AcqCSdurs','CSdurs') % Aggregates the vector of CS durations
% in the CSdurs fields at the Session level into a field at the Subject
% level, to which it assigns the name AcqCSdurs

TScombineover('AcqCSUSs','NumCSUSs') % Aggregates the vector of pellet
% deliveries during the CSs in the NumCSUSs field at the Session level into
% a field at the Subject level, to which it assigns the name AcqCSUSs

TSapplystat('MeanCSpkRate','CSPkRates',@mean)
% Creates field MeanCSpkRate at Session level containing the mean CS
% poke rate for that session
%
TScombineover('MeanCSpkRates','MeanCSpkRate','t')
% Creates field MeanPkRateDiffs at the Subject level containing the
% session-by-session mean poke rate differences with a 2nd col with
% session number

%% Defining ITI trial type and computing basic statistics

TSdefinetrialtype('ITI',{[Sessionstart Toneon] [Toneoff Toneon]}) % the ITI
% trial type. When we define a new trial type, it becomes the active trial
% type. Thus, the commands that follow will use that trial type rather than
% the CS trial type used by the preceding suite of commands. This trial
% type is the interval before each CS. Notice that two different event
% vectors are needed to define that interval. The first vector,
% [Sessionstart ToneOn] picks out the interval before the first CS; the 2nd
% vector, [ToneOff ToneOn], picks out the intervals between subsequent CSs

TSlimit('Sessions','all')
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

%% Aggregating statistics from the ITI trials into fields at the Session and
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
% fields at the Trial level under the ITI trial type into a field at the
% Session level, to which it assigns the name NumITIUSs
%
TScombineover('CumUStmsDrgITIs','UStms','m') % Creates a field named
% IRIsDuringITIs at the Session level that contains the cumulative reward
% times on a clock that only runs during ITIs. Differencing will these
% cumulative times will give the intervals between USs

TSapplystat('IRIsDuringITIs','CumUStmsDrgITIs',@diff) % field at the
% Session level
%
TSlimit('Sessions',1:44) % These were the acquisition sessions, during which
% there were no USs during the CSs

TScombineover('AcqITIPkRates','ITIPkRates') % Aggregates the vector of ITI poke
% rates in the ITIPkRates fields at the Session level into a field at the
% Subject level, to which it assigns the name AcqITIPkRates

TScombineover('AcqITIdurs','ITIdurs') % Aggregates the vector of ITI durations
% in the ITIdurs fields at the Session level into a field at the Subject
% level, to which it assigns the name AcqITIdurs

TScombineover('AcqITIUSs','NumITIUSs') % Aggregates the vector of pellet
% deliveries during the ITIs in the NumITIUSs field at the Session level into
% a field at the Subject level, to which it assigns the name AcqITIUSs

TScombineover('AcqIRIsDuringITIs','IRIsDuringITIs') % field at the Subject
% level

TSapplystat('MeanITIpkRate','ITIPkRates',@mean)
% Creates field MeanITIpkRate at Session level containing the mean ITI
% poke rate for that session
%
TScombineover('MeanITIpkRates','MeanITIpkRate','t')
% Creates field MeanPkRateDiffs at the Subject level containing the
% session-by-session mean poke rate differences with a 2nd col with
% session number
%
TSsaveexperiment

%% Computing trial-by-trial CS-ITI poke rate differences (CS poke rate on
% each trial minus the poke rate during the preceding ITI)

TSapplystat('CS_ITIrateDiffs',{'AcqCSPkRates' 'AcqITIPkRates'},@minus)
% Computes the trial-by-trial differences in the rate of poking during the
% CS and during the ITI that precedes the CS and puts the resulting vector
% of rate differences in a field at the Subject level, to which it assigns
% the name CS_ITIrateDiffs. The poke rates during the CS trials are in the
% AcqCSPkRates field; the poke rates during the preceding ITIs are in the
% AcqITIPkRates field. The helper function is Matlab's minus functions,
% which subtracts each element in one vector from the corresponding element
% in the other vector, provided, of course, that the two vectors have the
% same number of elements
%
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


%% Trial-by-trial CS-ITI poke rate differences and session level ITI-CS
% mean poke rate differences
TSlimit('Subjects','all')
TSapplystat('CS_ITI_PkRateDiffs',{'CSPkRates' 'ITIPkRates'},@minus)
% Creates field CS_ITI_PkRateDiffs at the Session level containing the
% trial-by-trial differences between the poke rate during the CS and the
% poke rate during the ITI
TSapplystat('MeanPkRateDiff','CS_ITI_PkRateDiffs',@mean)
% Creates field MeanPkRateDiff at Session level containing the mean
% difference in the poke rates for that session
%
TScombineover('MeanPkRateDiffs','MeanPkRateDiff','t')
% Creates field MeanPkRateDiffs at the Subject level containing the
% session-by-session mean poke rate differences with a 2nd col with
% session number

% Grouping Mean Rate Differences at Experiment level
TSlimit('Subjects',Experiment.GrpUS20_CS20)
TScombineover('Grp20_20SesBySesMnPkRateDiffs','MeanPkRateDiffs','t')
% Collating subjects' data by group and adding 3rd column that identifies
% subject

TSlimit('Subjects',Experiment.GrpUS20_CS40)
TScombineover('Grp20_40SesBySesMnPkRateDiffs','MeanPkRateDiffs','t')

TSlimit('Subjects',Experiment.GrpUS40_CS20)
TScombineover('Grp40_20SesBySesMnPkRateDiffs','MeanPkRateDiffs','t')
%
TSlimit('Subjects',Experiment.GrpUS40_CS40)
TScombineover('Grp40_40SesBySesMnPkRateDiffs','MeanPkRateDiffs','t')

TSlimit('Subjects',Experiment.GrpUS40_CS80)
TScombineover('Grp40_80SesBySesMnPkRateDiffs','MeanPkRateDiffs','t')

TSsaveexperiment
%% Aggregating Session by Session Mean CS, ITI and ITI-CS poke rates to
% groups at Experiment level

TSlimit('Subjects',Experiment.GrpUS20_CS20)
    TScombineover('G20_20CSPkRateMeans','CSPkRateMeans')
    TScombineover('G20_20ITIPkRateMeans','ITIPkRateMeans')
    TScombineover('G20_20RateDiffMeans','ITI_CS_PkRateDiffMeans')
%

TSlimit('Subjects',Experiment.GrpUS20_CS40)
    TScombineover('G20_40CSPkRateMeans','CSPkRateMeans')
    TScombineover('G20_40ITIPkRateMeans','ITIPkRateMeans')
    TScombineover('G20_40RateDiffMeans','ITI_CS_PkRateDiffMeans')


TSlimit('Subjects',Experiment.GrpUS40_CS20)
    TScombineover('G40_20CSPkRateMeans','CSPkRateMeans')
    TScombineover('G40_20ITIPkRateMeans','ITIPkRateMeans')
    TScombineover('G40_20RateDiffMeans','ITI_CS_PkRateDiffMeans')

TSlimit('Subjects',Experiment.GrpUS40_CS40)
    TScombineover('G40_40CSPkRateMeans','CSPkRateMeans')
    TScombineover('G40_40ITIPkRateMeans','ITIPkRateMeans')
    TScombineover('G40_40RateDiffMeans','ITI_CS_PkRateDiffMeans')

TSlimit('Subjects',Experiment.GrpUS40_CS80)
    TScombineover('G40_80CSPkRateMeans','CSPkRateMeans')
    TScombineover('G40_80ITIPkRateMeans','ITIPkRateMeans')
    TScombineover('G40_80RateDiffMeans','ITI_CS_PkRateDiffMeans')
TSsaveexperiment

%% Graphing Session-by-Session CS, ITI & Diff Poke Rate Means by Group
Hanova = figure;
subplot(2,2,1)
plot(mean(Experiment.G20_20CSPkRateMeans),'k-')
hold on
plot(mean(Experiment.G20_40CSPkRateMeans),'r-')
plot(mean(Experiment.G40_20CSPkRateMeans),'g-')
plot(mean(Experiment.G40_40CSPkRateMeans),'b-')
plot(mean(Experiment.G40_80CSPkRateMeans),'k--')
ylim([0 .4]);xlim([0 45])
xlabel('Session')
ylabel('CS Pokes/s')
legend('20-20','20-40','40-20','40-40','40-80','location','NW')

subplot(2,2,2)
plot(mean(Experiment.G20_20ITIPkRateMeans),'k-')
hold on
plot(mean(Experiment.G20_40ITIPkRateMeans),'r-')
plot(mean(Experiment.G40_20ITIPkRateMeans),'g-')
plot(mean(Experiment.G40_40ITIPkRateMeans),'b-')
plot(mean(Experiment.G40_80ITIPkRateMeans),'k--')
ylim([0 .4]);xlim([0 45])
xlabel('Session')
ylabel('ITI Pokes/s')

subplot(2,2,4)
plot(mean(Experiment.G20_20RateDiffMeans),'k-')
hold on
plot(mean(Experiment.G20_40RateDiffMeans),'r-')
plot(mean(Experiment.G40_20RateDiffMeans),'g-')
plot(mean(Experiment.G40_40RateDiffMeans),'b-')
plot(mean(Experiment.G40_80RateDiffMeans),'k--')
ylim([-.05 .43]);xlim([0 45])
xlabel('Session')
ylabel('ITI-CS Rate (s{^-1})')
subplot(2,2,3); % The p values, which are obtained from the ANOVAs,
% will be written into this panel farther down in the script (Line 806)
set(gca,'XTick',[],'YTick',[])
set(Hanova,'Name','E4 ANOVA','Position',[1105.00 1128.00 573.00 742.00]);

%% Building Arrays for ANOVAs

% For CS ANOVA
TSlimit('Subjects',Experiment.GrpUS20_CS20)
TScombineover('Grp20_20SesBySesMeanCSpkRates','MeanCSpkRates','t')
% Collating subjects' data by group and adding 3rd column that identifies
% subject; creates field at Experiment level

TSlimit('Subjects',Experiment.GrpUS20_CS40)
TScombineover('Grp20_40SesBySesMeanCSpkRates','MeanCSpkRates','t')

TSlimit('Subjects',Experiment.GrpUS40_CS20)
TScombineover('Grp40_20SesBySesMeanCSpkRates','MeanCSpkRates','t')
%
TSlimit('Subjects',Experiment.GrpUS40_CS40)
TScombineover('Grp40_40SesBySesMeanCSpkRates','MeanCSpkRates','t')

TSlimit('Subjects',Experiment.GrpUS40_CS80)
TScombineover('Grp40_80SesBySesMeanCSpkRates','MeanCSpkRates','t')

% Adding columns for Anova
TSapplystat('Grp20_20SesBySesMeanCSpkRates','Grp20_20SesBySesMeanCSpkRates',...
    @AddGroupNum,1) % adds column with group identification number
    %{
    function Aout = AddGroupNum(Ain,ID)
    Aout = [Ain repmat(ID,length(Ain),1)];
    %}
TSapplystat('Grp20_40SesBySesMeanCSpkRates','Grp20_40SesBySesMeanCSpkRates',...
    @AddGroupNum,2) % adds column with group identification number
TSapplystat('Grp40_20SesBySesMeanCSpkRates','Grp40_20SesBySesMeanCSpkRates',...
    @AddGroupNum,3) % adds column with group identification number
TSapplystat('Grp40_40SesBySesMeanCSpkRates','Grp40_40SesBySesMeanCSpkRates',...
    @AddGroupNum,4) % adds column with group identification number
TSapplystat('Grp40_80SesBySesMeanCSpkRates','Grp40_80SesBySesMeanCSpkRates',...
    @AddGroupNum,5) % adds column with group identification number


% For ITI ANOVA

TSlimit('Subjects','all')

% Grouping Mean Rate Differences at Experiment level
TSlimit('Subjects',Experiment.GrpUS20_CS20)
TScombineover('Grp20_20SesBySesMeanITIpkRates','MeanITIpkRates','t')
% Collating subjects' data by group and adding 3rd column that identifies
% subject; creates field at Experiment level

TSlimit('Subjects',Experiment.GrpUS20_CS40)
TScombineover('Grp20_40SesBySesMeanITIpkRates','MeanITIpkRates','t')

TSlimit('Subjects',Experiment.GrpUS40_CS20)
TScombineover('Grp40_20SesBySesMeanITIpkRates','MeanITIpkRates','t')
%
TSlimit('Subjects',Experiment.GrpUS40_CS40)
TScombineover('Grp40_40SesBySesMeanITIpkRates','MeanITIpkRates','t')

TSlimit('Subjects',Experiment.GrpUS40_CS80)
TScombineover('Grp40_80SesBySesMeanITIpkRates','MeanITIpkRates','t')

% Adding columns for Anova
TSapplystat('Grp20_20SesBySesMeanITIpkRates','Grp20_20SesBySesMeanITIpkRates',...
    @AddGroupNum,1) % adds column with group identification number
    %{
    function Aout = AddGroupNum(Ain,ID)
    Aout = [Ain repmat(ID,length(Ain),1)];
    %}
TSapplystat('Grp20_40SesBySesMeanITIpkRates','Grp20_40SesBySesMeanITIpkRates',...
    @AddGroupNum,2) % adds column with group identification number
TSapplystat('Grp40_20SesBySesMeanITIpkRates','Grp40_20SesBySesMeanITIpkRates',...
    @AddGroupNum,3) % adds column with group identification number
TSapplystat('Grp40_40SesBySesMeanITIpkRates','Grp40_40SesBySesMeanITIpkRates',...
    @AddGroupNum,4) % adds column with group identification number
TSapplystat('Grp40_80SesBySesMeanITIpkRates','Grp40_80SesBySesMeanITIpkRates',...
    @AddGroupNum,5) % adds column with group identification number

% For ITI-CS Rate Difference ANOVA

% Adding columns for Anova
TSapplystat('Grp20_20SesBySesMnPkRateDiffs','Grp20_20SesBySesMnPkRateDiffs',...
    @AddGroupNum,1) % adds column with group identification number

    %{
    function Aout = AddGroupNum(Ain,ID)
    Aout = [Ain repmat(ID,length(Ain),1)];
    %}
TSapplystat('Grp20_40SesBySesMnPkRateDiffs','Grp20_40SesBySesMnPkRateDiffs',...
    @AddGroupNum,2) % adds column with group identification number

TSapplystat('Grp40_20SesBySesMnPkRateDiffs','Grp40_20SesBySesMnPkRateDiffs',...
    @AddGroupNum,3) % adds column with group identification number
%
TSapplystat('Grp40_40SesBySesMnPkRateDiffs','Grp40_40SesBySesMnPkRateDiffs',...
    @AddGroupNum,4) % adds column with group identification number

TSapplystat('Grp40_80SesBySesMnPkRateDiffs','Grp40_80SesBySesMnPkRateDiffs',...
    @AddGroupNum,5) % adds column with group identification number

%% CS ANOVA
% Creating array to be fed to ANOVA 
TSapplystat('CSpkRateByDayByGroup',{'Grp20_20SesBySesMeanCSpkRates' ...
    'Grp20_40SesBySesMeanCSpkRates' 'Grp40_20SesBySesMeanCSpkRates' ...
    'Grp40_40SesBySesMeanCSpkRates' 'Grp40_80SesBySesMeanCSpkRates'},@vertcat)

% Col 1 is the data; remaining columns are the factors:
VarNames = {'Session', 'Subject','Group'};
% Subject is nested within group, so:
NestMatrx = [0 0 0;0 0 1;0 0 0];
% Subject (the 2nd factor) is a random factor, so
rnd = 2;
% The model type is 'interaction' (only the 2-way interactions), so:
mdl = 'interaction';
% I assume we should use the type 3 sum of squares (the default)
TSapplystat('CSpkRateBySesByGrpANOVApVals','CSpkRateByDayByGroup',...
    @GroupBySesANOVA,mdl,NestMatrx,rnd,VarNames)
% Field PkRateDiffBySesByGrpANOVApVals at Experiment level with table of p
% values
%{
function ptbl = GroupBySesANOVA(A,mdl,nst,rnd,vars)
[p,tbl,stats] = anovan(A(:,1),{(A(:,2)) (A(:,3)) (A(:,4))},'model',mdl,...
    'nested',nst,'random',rnd,'varnames',vars) 
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
    Pca{3} = 'Group p<.001';
else
    Pca{3} = ['Group p=' num2str(p(3),3)];
end
if p(5)<.001
    Pca{4} = 'SessionxGroup p<.001';
else
    Pca{4} = ['SessionxGroup p=' num2str(p(1),3)];
end
ptbl = char(Pca)
    
  Source                   Sum Sq.   d.f.   Mean Sq.     F     Prob>F
---------------------------------------------------------------------
  Session                   1.4222     43    0.03307    8.41   0     
  Subject(Group)            8.1464     34    0.2396    60.92   0     
  Group                     3.3546      4    0.83864    3.5    0.0169
  Session*Subject(Group)    5.7504   1462    0.00393     Inf      NaN
  Session*Group             0.7424    172    0.00432    1.1    0.1963
  Error                    -0           0   -0                       
  Total                    19.3963   1715                            
%}

%% ITI ANOVA 
TSapplystat('ITIpkRateByDayByGroup',{'Grp20_20SesBySesMeanITIpkRates' ...
    'Grp20_40SesBySesMeanITIpkRates' 'Grp40_20SesBySesMeanITIpkRates' ...
    'Grp40_40SesBySesMeanITIpkRates' 'Grp40_80SesBySesMeanITIpkRates'},@vertcat)

% Col 1 is the data; remaining columns are the factors:
VarNames = {'Session', 'Subject','Group'};
% Subject is nested within group, so:
NestMatrx = [0 0 0;0 0 1;0 0 0];
% Subject (the 2nd factor) is a random factor, so
rnd = 2;
% The model type is 'interaction' (only the 2-way interactions), so:
mdl = 'interaction';
% I assume we should use the type 3 sum of squares (the default)
TSapplystat('ITIpkRateBySesByGrpANOVApVals','ITIpkRateByDayByGroup',...
    @GroupBySesANOVA,mdl,NestMatrx,rnd,VarNames)
% Field PkRateDiffBySesByGrpANOVApVals at Experiment level with table of p
% values
%{
  Source                   Sum Sq.   d.f.   Mean Sq.     F     Prob>F
---------------------------------------------------------------------
  Session                   6.6871     43   0.15551    17.1    0     
  Subject(Group)           17.6623     34   0.51948    57.13   0     
  Group                     1.5575      4   0.38938     0.75   0.5652
  Session*Subject(Group)   13.2944   1462   0.00909      Inf      NaN
  Session*Group             1.0736    172   0.00624     0.69   0.9991
  Error                     0           0   0                        
  Total                    40.3605   1715                                                          
%}

%% ITI-CS Rate Difference ANOVA 
TSapplystat('PkRateDiffByDayByGroup',{'Grp20_20SesBySesMnPkRateDiffs' ...
    'Grp20_40SesBySesMnPkRateDiffs' 'Grp40_20SesBySesMnPkRateDiffs' ...
    'Grp40_40SesBySesMnPkRateDiffs' 'Grp40_80SesBySesMnPkRateDiffs'},@vertcat)
% Col 1 is the data; remaining columns are the factors:
VarNames = {'Session', 'Subject','Group'};
% Subject is nested within group, so:
NestMatrx = [0 0 0;0 0 1;0 0 0];
% Subject (the 2nd factor) is a random factor, so
rnd = 2;
% The model type is 'interaction' (only the 2-way interactions), so:
mdl = 'interaction';
% I assume we should use the type 3 sum of squares (the default)
TSapplystat('PkRateDiffBySesByGrpANOVApVals','PkRateDiffByDayByGroup',...
    @GroupBySesANOVA,mdl,NestMatrx,rnd,VarNames)
% Field PkRateDiffBySesByGrpANOVApVals at Experiment level with table of p
% values
%{
  Source                   Sum Sq.   d.f.   Mean Sq.     F     Prob>F
---------------------------------------------------------------------
  Session                   5.8393     43   0.1358     32.55   0     
  Subject(Group)            5.5184     34   0.16231    38.9    0     
  Group                     3.8618      4   0.96545     5.95   0.001 
  Session*Subject(Group)    6.0995   1462   0.00417      Inf      NaN
  Session*Group             1.0628    172   0.00618     1.48   0.0001
  Error                     0           0   0                        
  Total                    22.5588   1715                            %}
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
ptxts = Experiment.PkRateDiffBySesByGrpANOVApVals;
text(.05,.15,{'ITI-CS ANOVA';['   p_S' ptxts(1,10:end)];['   p_G ' ptxts(3,8:end)];...
    ['   p_S_x_G' ptxts(4,16:end)]})
saveas(Hanova,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 4/' ...
    get(Hanova,'Name') '.pdf'])

%% Computing CSoff Informativeness
TSlimit('Subjects','all')
TSlimit('Sessions','all')
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

% Aggregating numbers of ITI USs and Trial Durations and Session Durations
% to Subject level
TSlimit('Sessions',1:44)
TScombineover('NumITIUSs_S','NumITIUSs_s') % to subject level
TScombineover('SessionDurations','SessionDuration')
TScombineover('ITITrialDurs_S','ITITrialDurs')
    
% Computing ITI rates and Context rates of Reinforcement
TSapplystat('lambdaR_ITI',{'NumITIUSs_S' 'ITITrialDurs_S'},@Rate)
TSapplystat('lambdaR_C',{'NumITIUSs_S' 'SessionDurations'},@Rate)

% Computing Informativeness
TSapplystat('CSoffInformativeness',{'lambdaR_ITI' 'lambdaR_C'},@rdivide)

% Aggregating by Groups to Experiment level
TSlimit('Subjects',Experiment.GrpUS20_CS20)
TScombineover('US20_CS20Informativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.GrpUS20_CS40)
TScombineover('US20_CS40Informativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.GrpUS40_CS20)
TScombineover('US40_CS20Informativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.GrpUS40_CS40)
TScombineover('US40_CS40Informativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.GrpUS40_CS80)
TScombineover('US40_CS80Informativeness','CSoffInformativeness')
TSsaveexperiment

%% Computing Trials to Acquisition
TSlimit('Subjects','all')
% We define the acquisition point to be the point at
% which the cumulative record of rate differences is down by dwn from its
% maximum value and that the final level is below that level by at least
% dwn (that is, provided the cumulative record continues to fall after
% dropping below the threshold for "acquisition"), and, finally, that it
% finished at least 2* dwn below 0

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
TSlimit('Subjects',Experiment.GrpUS20_CS20)
TScombineover('GrpUS20_CS20AcqPts','AcqPt')

TSlimit('Subjects',Experiment.GrpUS20_CS40)
TScombineover('GrpUS20_CS40AcqPts','AcqPt')
%
TSlimit('Subjects',Experiment.GrpUS40_CS20)
TScombineover('GrpUS40_CS20AcqPts','AcqPt')
%
TSlimit('Subjects',Experiment.GrpUS40_CS40)
TScombineover('GrpUS40_CS40AcqPts','AcqPt')

TSlimit('Subjects',Experiment.GrpUS40_CS80)
TScombineover('GrpUS40_CS80AcqPts','AcqPt')
TSsaveexperiment

%% CDFs of Trials to Acquisition by Groups
TSapplystat('',{'GrpUS20_CS20AcqPts' 'GrpUS20_CS40AcqPts' ...
    'GrpUS40_CS20AcqPts' 'GrpUS40_CS40AcqPts' 'GrpUS40_CS80AcqPts'},...
    @TSplotcdfs,'Rows',1,'Cols',1,'Xlbl','Trials to Acquisition','Ylbl',...
    'Cumulative Fraction of Subjects','Xlm',[0 1100],'Handle','Hcdf')
legend('20-20','20-40','40-20','40-40','40-80','location','SE')
saveas(gcf,...
'/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 4/E4 CDFsTrialsToAcquisition.pdf')

%% Median Acquisition Trials by Group
TSapplystat('MedianTrlsToAcq',...
    {'GrpUS20_CS20AcqPts' 'GrpUS20_CS40AcqPts' 'GrpUS40_CS20AcqPts' ...
    'GrpUS40_CS40AcqPts' 'GrpUS40_CS80AcqPts'},@AcqMediansExper4)
%{
function AM = AcqMediansExper4(D1,D2,D3,D4,D5)
AM(:,1) = [1;2;3;4;5]; % Group ID #s
AM(:,2) = nanmedian([D1 D2 [D3;NaN] D4 D5])';
%}
TSsaveexperiment
    
%% Post acquisition response rate diffs
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

% Aggregating post acquisition mean rate diffs by group at Experiment level
TSlimit('Subjects',Experiment.GrpUS20_CS20)
TScombineover('GrpUS20_CS20MnPostAcqRateDiffs','PostAcqMnRateDiff')

TSlimit('Subjects',Experiment.GrpUS20_CS40)
TScombineover('GrpUS20_CS40MnPostAcqRateDiffs','PostAcqMnRateDiff')

TSlimit('Subjects',Experiment.GrpUS40_CS20)
TScombineover('GrpUS40_CS20MnPostAcqRateDiffs','PostAcqMnRateDiff')

TSlimit('Subjects',Experiment.GrpUS40_CS40)
TScombineover('GrpUS40_CS40MnPostAcqRateDiffs','PostAcqMnRateDiff')

TSlimit('Subjects',Experiment.GrpUS40_CS80)
TScombineover('GrpUS40_CS80MnPostAcqRateDiffs','PostAcqMnRateDiff')

figure
D = Experiment.GrpUS20_CS20MnPostAcqRateDiffs;
plot(ones(size(D)),D,'k*')
hold on
D = Experiment.GrpUS20_CS40MnPostAcqRateDiffs;
plot(2*ones(size(D)),D,'k*')
D = Experiment.GrpUS40_CS20MnPostAcqRateDiffs;
plot(3*ones(size(D)),D,'k*')
D = Experiment.GrpUS40_CS40MnPostAcqRateDiffs;
plot(4*ones(size(D)),D,'k*')
D = Experiment.GrpUS40_CS80MnPostAcqRateDiffs;
plot(5*ones(size(D)),D,'k*')
xlim([.5 5.5])
set(gca,'XTickLabel',{'20-20' '20-40' '40-20' '40-40' '40-80'})
xlabel('Group')
ylabel('CS-ITI Pks/s Post Acquisition')
saveas(gcf,'/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 4/E4 PstAcqCS-ITIrateDiffs.pdf')

%% Pre- & Post-Acquisition differences in mean poke rate during CSs and ITIs

TSlimit('Subjects','all')
TSapplystat({'CSpreAcqPstAcqPkRateDiff' 'ITIpreAcqPstAcqPkRateDiff'},...
    {'AcqCSPkRates' 'AcqITIPkRates' 'AcqPt'},@PrePostDiffs)
%{
function [CSdiff,ITIdiff]=PrePostDiffs(CSrates,ITIrates,AcqPt)
CSdiff=[];ITIdiff=[];
if AcqPt<1500
    CSdiff = mean(CSrates(AcqPt:end)) - mean(CSrates(1:AcqPt-1));
    ITIdiff = mean(ITIrates(AcqPt:end)) - mean(ITIrates(1:AcqPt-1));
end    
%}

TSlimit('Subjects',Experiment.GrpUS20_CS20)
TScombineover('G20_20_PrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('G20_20_PrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')
%
TSlimit('Subjects',Experiment.GrpUS20_CS40)
TScombineover('G20_40_PrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('G20_40_PrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')

TSlimit('Subjects',Experiment.GrpUS40_CS20)
TScombineover('G40_20_PrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('G40_20_PrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')

TSlimit('Subjects',Experiment.GrpUS40_CS40)
TScombineover('G40_40_PrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('G40_40_PrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')

TSlimit('Subjects',Experiment.GrpUS40_CS80)
TScombineover('G40_80_PrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('G40_80_PrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')

%% CDFs of Differences between poke rates pre and post-acquisition for CSs and ITIs
CSdiffs=[Experiment.G20_20_PrePstCSpkRateDiffs;Experiment.G20_40_PrePstCSpkRateDiffs;...
    Experiment.G40_20_PrePstCSpkRateDiffs;Experiment.G40_40_PrePstCSpkRateDiffs;...
    Experiment.G40_80_PrePstCSpkRateDiffs];
ITIdiffs=[Experiment.G20_20_PrePstITIpkRateDiffs;Experiment.G20_40_PrePstITIpkRateDiffs;...
    Experiment.G40_20_PrePstITIpkRateDiffs;Experiment.G40_40_PrePstITIpkRateDiffs;...
    Experiment.G40_80_PrePstITIpkRateDiffs];
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
title('Experiment 4 ("Ratio")')
saveas(gcf,...
'/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 4/E4 CDFs of Pre-PstCS&ITIRateDiffs.pdf')

%% Cummulative USs at Acquisition
TSlimit('Subjects','all')
TSapplystat('USsAtAcquisition',{'AcqITIUSs' 'AcqPt'},@USsAtAcq)
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
TSlimit('Subjects',Experiment.GrpUS20_CS20)
    TScombineover('G2020USsAtAcq','USsAtAcquisition')
TSlimit('Subjects',Experiment.GrpUS20_CS40)
    TScombineover('G2040USsAtAcq','USsAtAcquisition')
TSlimit('Subjects',Experiment.GrpUS40_CS20)
    TScombineover('G4020USsAtAcq','USsAtAcquisition')
TSlimit('Subjects',Experiment.GrpUS40_CS40)
    TScombineover('G4040USsAtAcq','USsAtAcquisition')
TSlimit('Subjects',Experiment.GrpUS40_CS80)
    TScombineover('G4080USsAtAcq','USsAtAcquisition')
%% Subject-by-Subject Within-CS, Post-Acq Poke Rate Profiles
TSlimit('Subjects','all')
NumBins = 10;
TSapplystat('PkRateProfileInCSpostAcq',{'CSPkTms_S' 'AcqCSdurs' 'AcqPt'},@Profile,NumBins)
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
G = {Experiment.GrpUS20_CS20  Experiment.GrpUS20_CS40 Experiment.GrpUS40_CS20 ...
    Experiment.GrpUS40_CS40 Experiment.GrpUS40_CS80};
Names ={'20-20' '20-40' '40-20' '40-40' '40-80'};
Xlbl = {{'1' '10' '20'};{'1' '20' '40'};{'1' '10' '20'};{'1' '20' '40'};{'1' '40' '80'}};
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
            set(gca,'XTick',[1 5 10],'XTickLabel',Xlbl{g})
            if plt>6
                xlabel('Time Elapsed in CS (s)')
            end
            if mod(plt,2)>0
                ylabel('Pks/s')
            end
        plt=plt+1;
    end
    saveas(gcf,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 4' ...
        '/E4 PstAcqWIcsPkFreqProfile' Names{g} '.pdf'])
end

%% Aggregating Post-Acq CS Decile Profiles by Group to Experiment level
TSlimit('Subjects',Experiment.GrpUS20_CS20)
    TScombineover('G2020PstAcqPksPrSecByDecile','PkRateProfileInCSpostAcq','t') % 
    TSapplystat({'G2020ProfileMean' 'G2020ProfileSE'},'G2020PstAcqPksPrSecByDecile',@ProfMean)
    %{
    function [M,SE] = ProfMean(A)
    % A is 2-col array with deciles repeated in 2nd colin
    A(A(:,1)==0,:)=[]; % deleting 11th bins (always 0)
    Ar = reshape(A(:,1),10,[]);
    M = mean(Ar,2);
    SE = std(Ar,0,2)/sqrt(size(Ar,2));
    %}
TSlimit('Subjects',Experiment.GrpUS20_CS40)
    TScombineover('G2040PstAcqPksPrSecByDecile','PkRateProfileInCSpostAcq','t')
    TSapplystat({'G2040ProfileMean' 'G2040ProfileSE'},'G2040PstAcqPksPrSecByDecile',@ProfMean)
TSlimit('Subjects',Experiment.GrpUS40_CS20)
    TScombineover('G4020PstAcqPksPrSecByDecile','PkRateProfileInCSpostAcq','t')
    TSapplystat({'G4020ProfileMean' 'G4020ProfileSE'},'G4020PstAcqPksPrSecByDecile',@ProfMean)
TSlimit('Subjects',Experiment.GrpUS40_CS40)
    TScombineover('G4040PstAcqPksPrSecByDecile','PkRateProfileInCSpostAcq','t')
    TSapplystat({'G4040ProfileMean' 'G4040ProfileSE'},'G4040PstAcqPksPrSecByDecile',@ProfMean)
TSlimit('Subjects',Experiment.GrpUS40_CS80)
    TScombineover('G4080PstAcqPksPrSecByDecile','PkRateProfileInCSpostAcq','t')
    TSapplystat({'G4080ProfileMean' 'G4080ProfileSE'},'G4080PstAcqPksPrSecByDecile',@ProfMean)

%% Errorbar Graphs of Group Within-CS Post-Acq Response Freq Profiles
Nms = {'1' '10' '20'};
figure
Ax1=subplot(3,2,1);
    TSapplystat('',{'G2020ProfileMean' 'G2020ProfileSE'},...
        @EB,Ax1,Nms)
    %{
    function EB(m,se,Ax,Nms)
    figure
    errorbar(Ax,1:10,m,se,se)
    set(gca,'XTick',[1 5 10],'XTickLabel',Nms)    
    %}
        title('US-US20, CS20','FontWeight','normal') 
Ax2=subplot(3,2,2);
    Nms = {'1' '20' '40'};
    TSapplystat('',{'G2040ProfileMean' 'G2040ProfileSE'},...
        @EB,Ax2,Nms)
    title('US-US20, CS40','FontWeight','normal') 

Ax3=subplot(3,2,3);
    Nms = {'1' '10' '20'};
    TSapplystat('',{'G4020ProfileMean' 'G4020ProfileSE'},...
        @EB,Ax3,Nms)
   title('US-US40, CS20','FontWeight','normal')  

Ax4=subplot(3,2,4);
    Nms = {'1' '20' '40'};
    TSapplystat('',{'G4040ProfileMean' 'G4040ProfileSE'},...
        @EB,Ax4,Nms);xlabel('Elapsed CS Time (s)')
    title('US-US40, CS40','FontWeight','normal') 

Ax5=subplot(3,2,5);
    Nms = {'1' '40' '80'};
    TSapplystat('',{'G4080ProfileMean' 'G4080ProfileSE'},...
        @EB,Ax5,Nms);xlabel('Elapsed CS Time (s)')
    title('US-US40, CS80','FontWeight','normal') 
    
%% Average # of USs per ITI
TSlimit('all')
TSapplystat('USperITI',{'AcqITIdurs' 'AcqITIUSs'},@USsPerITI)

TSlimit('Subjects',Experiment.GrpUS20_CS20)
    TScombineover('GrpUS20_CS20USsPerITI','USperITI')
TSlimit('Subjects',Experiment.GrpUS20_CS40)
    TScombineover('GrpUS20_CS40USsPerITI','USperITI')
TSlimit('Subjects',Experiment.GrpUS40_CS20)
    TScombineover('GrpUS40_CS20USsPerITI','USperITI')
TSlimit('Subjects',Experiment.GrpUS40_CS40)
    TScombineover('GrpUS40_CS40USsPerITI','USperITI')
TSlimit('Subjects',Experiment.GrpUS40_CS80)
    TScombineover('GrpUS40_CS80USsPerITI','USperITI')
    
%% Subject level summary stats for assembly at Experiment level and export 
% to long table

TSlimit('Subjects','all')
E = 4; % Experiment #
TSapplystat({'SummaryArray' 'GroupName'},{'AcqCSdurs' 'AcqITIdurs' 'AcqITIUSs' 'AcqPt' ...
    'CSpreAcqPstAcqPkRateDiff' 'ITIpreAcqPstAcqPkRateDiff'},@SubSummary,E)
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
    ''
    'ITI = mean exponential distribution with mean = 20.'
    ''
    'CS duration fixed at 20 40 or 80.'
    ''
    'Reinforcer delivery = exponential distributed w mean = 20s or 40,'
    'as indicated by group names.'
    ''
    'Pellets delivered only in the ITI.'
    ''
    'Sessions 1:44 were inhibitory conditioning, with no USs during CSs;'
    'Sessions 45:end were "resistance to extinction" sessions,'
    'with USs duringthe CSs'
    ''
    'Analysis Notes:'
    'The function that estimates the acquisition point'
    'initializes the estimate to 1500, which is not a possible value,'
    'because there were not that many trials. This is done for graphic'
    'reasons (so that failures to acquire are evident in the plots of'
    'the cumulative distributions of trials to acquisition).'});


