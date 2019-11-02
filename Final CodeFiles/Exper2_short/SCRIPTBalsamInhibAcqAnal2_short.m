%This is the script for analyzing the fixed-CS inhibtion data

%{
Design:
CS10 and CS40 replicate two groups of Experiment 1 and show that the longer
 the cue the faster and deeper the inhibition.   CS10 shows little evidence
 of inhibition.   These two groups differ with respect to 
1) time from onset of CS- to resumption of reward
2) total exposure to CS-

Group CS10_30 gets the 10sec CS- and then an additional 30 sec of ITI
 during which no pellets are presented before the program resumes the ITI
 pellet presentations.   So the delay from CS- to possible food is the same
 in this group as it is in CS40

Group CS10X4 is the exact same procedure as CS10 but there are 4X as many
 CS- presentations in each session.   This group has the exact same
 cumulative exposure to the CS- as the CS40 group
%}
%% Creating an Experiment structure
TSinitexperiment('InhibAcq3',1002,301:332,'Rat','Balsam') % Creates an
% Experiment structure and fills in the following fields:
% Experiment.Name = InhibAcq3;
% Experiment.ID = 1003;
% Experiment.Subjects = the row vector [301 302 303 ... 332]
% Experiment.Species = Rat
% Experiment.Lab = Balsam
% The TSinitexperiment function counts the number of elements in the vector
% of subject ID numbers and then fills in another field:
% Experiment.NumSubjects = 32

% Loading into the structure information necessary to the loading of data

TSsetloadparameters('InputTimeUnit',.1,'OutputTimeUnit',1,'LoadFunction',...
'TSLoadBalsamRaw3','FilePrefix','!','FileExtension',[]) % Put into the
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
cd('C:\Users\pbalsam\Dropbox\Conditioned Inhibition\Rat CI\Short Cue Inhibition 10s\Data') % makes Data directory the current directory (Dr contains the complete path to Data directory)
for d = 1:35 % stepping through the Day subfolder
    FN = ['Day ' num2str(d)]; % constructing the name of the folder containing
    % the files we want to load
   
    TSloadsessions(FN) % calling TSloadsession to load the files in that directory
end

%% Importing event codes
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

%%
TSremovesession(325,36) % removes supernumerary session from the subject
% with ID # (NB NOT! index #) 325
TSremovesession(326,36) % ditto

%% Creating fields at the Experiment level that specify which subjects are
% in which groups (experimental conditions)

Experiment.GrpCS10 = [1 2 15 16 25 26 29 30]; % The group for which the
% inhibitory CS lasted 10s. During the CSs no pellets were delivered.
% Pellets were delivered at random during the ITIs

Experiment.GrpCS40 = [3 4 11 12 19 20 23 24]; % see above

Experiment.GrpCS10_30 = [5 6 9 10 21 22 31]; % see above
% S 32 was supposed to be in this group, but was in fact run with a fixed
% ITI duration of 10s
Experiment.GrpCS10X4 = [7 8 13 14 17 18 27 28]; % see above

% during both the CSs and the ITIs

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

%% Aggregating statistics from the CS trials into fields at the Session and
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

% To Session level
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
   
    
    TSapplystat('MeanITIpkRate','ITIPkRates',@mean)
    % Creates field MeanITIpkRate at Session level containing the mean ITI
    % poke rate for that session

% To Subject level

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
    
    TScombineover('MeanITIpkRates','MeanITIpkRate','t')
    % Creates field MeanPkRateDiffs at the Subject level containing the
    % session-by-session mean poke rate differences with a 2nd col with
    % session number

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
TSsaveexperiment

%% Aggregating Session by Session Mean CS, ITI and ITI-CS poke rates to
% groups at Experiment level

TSlimit('Subjects',Experiment.GrpCS10)
    TScombineover('GrpCS10CSPkRateMeans','CSPkRateMeans')
    TScombineover('GrpCS10ITIPkRateMeans','ITIPkRateMeans')
    TScombineover('GrpCS10RateDiffMeans','ITI_CS_PkRateDiffMeans')

TSlimit('Subjects',Experiment.GrpCS40)
    Experiment.Subject(19).CSPkRateMeans(35)=NaN; % missing session
    Experiment.Subject(19).ITIPkRateMeans(35)=NaN; % ditto
    Experiment.Subject(19).ITI_CS_PkRateDiffMeans(35)=NaN; % ditto
    Experiment.Subject(20).CSPkRateMeans(35)=NaN; % ditto
    Experiment.Subject(20).ITIPkRateMeans(35)=NaN; % ditto
    Experiment.Subject(20).ITI_CS_PkRateDiffMeans(35)=NaN; % ditto
    TScombineover('Grp40CSPkRateMeans','CSPkRateMeans')
    TScombineover('Grp40ITIPkRateMeans','ITIPkRateMeans')
    TScombineover('Grp40RateDiffMeans','ITI_CS_PkRateDiffMeans')

TSlimit('Subjects',Experiment.GrpCS10_30)
    TScombineover('Grp10_30CSPkRateMeans','CSPkRateMeans')
    TScombineover('Grp10_30ITIPkRateMeans','ITIPkRateMeans')
    TScombineover('Grp10_30RateDiffMeans','ITI_CS_PkRateDiffMeans')

TSlimit('Subjects',Experiment.GrpCS10X4)
    TScombineover('Grp10X4CSPkRateMeans','CSPkRateMeans')
    TScombineover('Grp10X4ITIPkRateMeans','ITIPkRateMeans')
    TScombineover('Grp10X4RateDiffMeans','ITI_CS_PkRateDiffMeans') 

%% Graphing Session-by-Session CS, ITI & Diff Poke Rate Means by Group
Hanova = figure;
subplot(2,2,1)
plot(mean(Experiment.GrpCS10CSPkRateMeans),'k-')
hold on
plot(mean(Experiment.Grp40CSPkRateMeans),'k--')
plot(mean(Experiment.Grp10_30CSPkRateMeans),'k-.')
plot(nanmean(Experiment.Grp10X4CSPkRateMeans),'k:')
ylim([0 .5]);xlim([0 36])
xlabel('Session')
ylabel('CS Poke Rate (s^{-1})')
legend('CS10','CS40','CS10_30','CS10X4','location','NW')

subplot(2,2,2)
plot(mean(Experiment.GrpCS10ITIPkRateMeans),'k-')
hold on
plot(mean(Experiment.Grp40ITIPkRateMeans),'k--')
plot(mean(Experiment.Grp10_30ITIPkRateMeans),'k-.')
plot(nanmean(Experiment.Grp10X4ITIPkRateMeans),'k:')
ylim([0 .5]);xlim([0 36])
xlabel('Session')
ylabel('ITI Poke Rate (s^{-1})')

subplot(2,2,4)
plot(mean(Experiment.GrpCS10RateDiffMeans),'k-')
hold on
plot(mean(Experiment.Grp40RateDiffMeans),'k--')
plot(mean(Experiment.Grp10_30RateDiffMeans),'k-.')
plot(nanmean(Experiment.Grp10X4RateDiffMeans),'k:')
ylim([-.1 .3]);xlim([0 36])
xlabel('Session')
ylabel('ITI-CS Poke Rate (s^{-1})')
subplot(2,2,3); % The p values, which are obtained from the ANOVAs,
% will be written into this panel
set(gca,'XTick',[],'YTick',[])
set(Hanova,'Name','E2 ANOVA','Position',[1105.00 1128.00 573.00 742.00]);

%% Creating ANOVA Arrays
% Creating array to be fed to CS ANOVA
NumSes = 34; % the number of sessions for subject with fewest
TSapplystat('CSpkRateByDayByGroup',{'GrpCS10CSPkRateMeans' ...
    'Grp40CSPkRateMeans' 'Grp10_30CSPkRateMeans' 'Grp10X4CSPkRateMeans' ...
     'GrpCS10' 'GrpCS40' 'GrpCS10_30' 'GrpCS10X4'},@vct2,NumSes)
% Creating the 4-column "long table" to be fed to the anovan command and
% putting it in a field at the Experiment level named CSpkRateByDayByGroup.
% Col 1 = data (mean poke rate in a session); Col 2 = Session; Col 3
% =Subject; Col 4 = Group (CS duration). This is the data format required
% by the anovan function and by the similar functions in other statistical
% packages (e.g., by the TidyVerse package in R)
    %{
    function Aout = vct2(A1,A2,A3,A4,G1,G2,G3,G4,ns)
    % Deleting supernumerary sessions
    A1(:,ns+1:end)=[];
    A2(:,ns+1:end) =[];
    A3(:,ns+1:end) =[]; 
    A4(:,ns+1:end) =[]; 

    % Building array
    Aout = [reshape(A1',[],1);reshape(A2',[],1);reshape(A3',[],1);reshape(A4',[],1)];
    % the data column
    sesnums = (1:ns)';
    Aout(:,2) = [repmat(sesnums,numel(G1),1);repmat(sesnums,numel(G2),1);...
        repmat(sesnums,numel(G3),1);repmat(sesnums,numel(G4),1)]; % column for
    % session number
    Aout(:,3) = [reshape(repmat(G1,ns,1),[],1);reshape(repmat(G2,ns,1),[],1);...
        reshape(repmat(G3,ns,1),[],1);reshape(repmat(G4,ns,1),[],1)]; % sub IDs
    Aout(:,4) = [ones(numel(G1)*ns,1);2*ones(numel(G2)*ns,1);...
        3*ones(numel(G3)*ns,1);4*ones(numel(G4)*ns,1)];
    % group IDs
    %}    
% Creating array to be fed to ITI ANOVA
TSapplystat('ITIpkRateByDayByGroup',{'GrpCS10ITIPkRateMeans' ...
    'Grp40ITIPkRateMeans' 'Grp10_30ITIPkRateMeans' 'Grp10X4ITIPkRateMeans' ...
     'GrpCS10' 'GrpCS40' 'GrpCS10_30' 'GrpCS10X4'},@vct2,NumSes)

% Creating array to be fed to ITI-CS ANOVA
TSapplystat('ITI_CSRateDiffMeansByDayByGroup',{'GrpCS10RateDiffMeans' ...
    'Grp40RateDiffMeans' 'Grp10_30RateDiffMeans' 'Grp10X4RateDiffMeans' ...
     'GrpCS10' 'GrpCS40' 'GrpCS10_30' 'GrpCS10X4'},@vct2,NumSes)
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

  Source                   Sum Sq.   d.f.   Mean Sq.     F     Prob>F
---------------------------------------------------------------------
  Session                   0.9337     33    0.02829    4.15   0     
  Subject(Group)           11.984      27    0.44385   65.16   0     
  Group                     1.2679      3    0.42264    0.95   0.4294
  Session*Subject(Group)    6.0695    891    0.00681     Inf      NaN
  Session*Group             0.9603     99    0.0097     1.42   0.006 
  Error                    -0           0   -0                       
  Total                    21.2111   1053                            
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
  Source                   Sum Sq.   d.f.   Mean Sq.     F     Prob>F
---------------------------------------------------------------------
  Session                   2.4475     33   0.07417    10.46   0     
  Subject(Group)           12.3734     27   0.45828    64.66   0     
  Group                     1.3259      3   0.44197     0.96   0.4238
  Session*Subject(Group)    6.3149    891   0.00709      Inf      NaN
  Session*Group             1.0016     99   0.01012     1.43   0.0057
  Error                     0           0   0                        
  Total                    23.4906   1053                            
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
  Session                  0.49061     33   0.01487     4.79   1.62269e-16
  Subject(Group)           1.03516     27   0.03834    12.36   2.47495e-45
  Group                    2.2404       3   0.7468     19.48   6.30865e-07
  Session*Subject(Group)   2.7643     891   0.0031       Inf           NaN
  Session*Group            0.70103     99   0.00708     2.28   3.22819e-10
  Error                    0            0   0                             
  Total                    7.25556   1053                                                                
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
saveas(Hanova,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 2/' ...
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
TSlimit('Subjects',Experiment.GrpCS10)
TScombineover('GrpCS10Informativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.GrpCS40)
TScombineover('GrpCS40Informativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.GrpCS10_30)
TScombineover('GrpCS10_30Informativeness','CSoffInformativeness')
TSlimit('Subjects',Experiment.GrpCS10X4)
TScombineover('GrpCS10X4Informativeness','CSoffInformativeness')

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
AP = 4500; % greater than total # of trials (Grp10X4 has 4352)
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
%
% Aggregating acquisition points by group at Experiment level

TSlimit('Subjects',Experiment.GrpCS10)
TScombineover('GrpCS10_AcqPts','AcqPt')
%
TSlimit('Subjects',Experiment.GrpCS40 )
TScombineover('GrpCS40_AcqPts','AcqPt')
%
TSlimit('Subjects',Experiment.GrpCS10_30)
TScombineover('GrpCS10_30_AcqPts','AcqPt')

TSlimit('Subjects',Experiment.GrpCS10X4)
TScombineover('GrpCS10X4_AcqPts','AcqPt')

% Plotting cumulative distributions of acquisition points
TSapplystat('',{'GrpCS10_AcqPts' 'GrpCS40_AcqPts' 'GrpCS10_30_AcqPts' 'GrpCS10X4_AcqPts'},...
    @TSplotcdfs,'Rows',1,'Cols',1,'Xlbl','Acquisition Trial','Xlm',[0 1550])
set(get(gca,'Children'),'LineWidth',2)
set(gca,'FontSize',14)
xlabel('Acquisition Trial','FontSize',14)
ylabel('Cumulative Fraction of Subjects','FontSize',14)
% Adding vertical dashed lines at intervals that decrease by octaves and
% that fall close to the medians of the distributions, to show that a model
% in which trials-to-acquisition is a scalar function of C/T applies to
% inhibition acquisition just as much as to excitation acquisition:

legend('CS10','CS40','CS10+30','CS10X40','Location','SE')
title('Experiment 2: CDFs of Trials to Acquisition')
saveas(gcf,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 2/' ...
    'E2 CDFsTrialsToAcquisition.pdf']);

%% Adding field at Experiment level with median acquisition trial
% 
TSapplystat('MedianTrlsToAcq',...
    {'GrpCS10_AcqPts' 'GrpCS40_AcqPts' 'GrpCS10_30_AcqPts' ...
     'GrpCS10X4_AcqPts'},@AcqMedians)
%{
function AM = AcqMedians(D1,D2,D3,D4)
AM(:,1) = [1;2;3;4]; % Group ID #s
AM(1,2) = median(D1(D1<4500));
AM(2,2) = median(D2)';
AM(3,2) = NaN;
AM(4,2) = median(D4(D4<4500));
% median = 4500 is impossible. This arises
% because we initialized estimated acquisition points to 4500 for graphic
% reasons (so that failures to acquire were evident in cumulative
% distributions of acquisition points)
%{
Group IDs
1 =CS10
2 = CS40
 These replicate two groups of Experiment 1 and show that the longer
 the cue the faster and deeper the inhibition.   CS10 shows little evidence
 of inhibition.   These two groups differ with respect to 
   i) time from onset of CS- to resumption of reward
   ii) total exposure to CS-

3 = Group CS10_30, which gets the 10sec CS- and then an additional 30 sec of ITI
 during which no pellets are presented before the program resumes the ITI
 pellet presentations.   So the delay from CS- to possible food is the same
 in this group as it is in CS40

4 = Group CS10X4 is the exact same procedure as CS10 but there are 4X as 
 many CS- presentations in each session.   This group has the exact same
 cumulative exposure to the CS- as the CS40 group. This group has 4350
 total trials
%}
%}

%% Mean rate difference post acquisition
TSlimit('Subjects','all')
TSapplystat('MnPostAcqRateDiff',{'CS_ITIrateDiffs' 'AcqPt'},@PostAcqMnRateDiff)
% field at Subject level

% Experiment level aggregation of post acquisition mean rate diffs
TSlimit('Subjects',Experiment.GrpCS10)
TScombineover('GrpCS10MnPostAcqRateDiff','MnPostAcqRateDiff')

TSlimit('Subjects',Experiment.GrpCS40)
TScombineover('GrpCS40MnPostAcqRateDiff','MnPostAcqRateDiff')

TSlimit('Subjects',Experiment.GrpCS10_30)
TScombineover('GrpCS10_30MnPostAcqRateDiff','MnPostAcqRateDiff')

TSlimit('Subjects',Experiment.GrpCS10X4)
TScombineover('GrpCS10X4MnPostAcqRateDiff','MnPostAcqRateDiff')

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
TSlimit('Subjects',Experiment.GrpCS10)
TScombineover('GrpCS10PrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('GrpCS10PrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')
%
TSlimit('Subjects',Experiment.GrpCS40)
TScombineover('GrpCS40PrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('GrpCS40PrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')

TSlimit('Subjects',Experiment.GrpCS10X4)
TScombineover('GrpCS10X4PrePstCSpkRateDiffs','CSpreAcqPstAcqPkRateDiff')
TScombineover('GrpCS10X4PrePstITIpkRateDiffs','ITIpreAcqPstAcqPkRateDiff')

TSsaveexperiment

%% CDFs of Differences btw pre-acquisition poke rate and post-acquisition
% poke rate in both CS & ITI
CSdiffs=[Experiment.GrpCS10PrePstCSpkRateDiffs;Experiment.GrpCS40PrePstCSpkRateDiffs;...
    Experiment.GrpCS10X4PrePstCSpkRateDiffs];
ITIdiffs=[Experiment.GrpCS10PrePstITIpkRateDiffs;Experiment.GrpCS40PrePstITIpkRateDiffs;...
    Experiment.GrpCS10X4PrePstITIpkRateDiffs];

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
title('Experiment 2 ("shortCue")')
saveas(gcf,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 2/' ...
    'E2 CDFsOfPre-PostAcqRateDiffs.pdf']);

%% FOR CODE TO PRODUCE GRAPHS SHOWING CUMULATIVE RECORDS AND ALGORITHM-
% ESTIMATED ACQUISITION POINTS, SEE OLDER CODE 
% Dropbox>InhibitoryExperiments_All>Older Scripts & Helper Functions>Exper2_shortCue>BalsamInhibAcqAnal2_short

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
TSlimit('Subjects',[Experiment.GrpCS10 Experiment.GrpCS10X4])
    TScombineover('Grps10USsAtAcq','USsAtAcquisition')
TSlimit('Subjects',Experiment.GrpCS40)
    TScombineover('GrpCS40USsAtAcq','USsAtAcquisition')
    
%% Was there an increase in responding during the 30s "trace" interval at
% start of each ITI, the interval that terminated with the onset of the
% reinforcement generating process? Answer: No

TSlimit('Subjects',Experiment.GrpCS10_30)
TSsettrialtype('ITI')
SI = 1; % intervals into which CS is to be partitioned (in seconds)
TSapplystat('PkRatePerITIsubInterval',{'PkTms' 'TrialDuration'},@PksPerSbInt2,SI)
% Trial level field pkw 2 cols; 2nd col gives ordinal position of pks
TScombineover('PkRatePerITIsubInt','PkRatePerITIsubInterval','t') % session level
% adds a 3rd column with trial #
TScombineover('PkRatePerITISubIntBySes','PkRatePerITIsubInt','t') %  subject level; 
% each row is a trial; adds a 4th col w Session #

X=5;
TSapplystat('MnPkRatePerITISubInt10_30','PkRatePerITISubIntBySes',@LstXses,X) 
TScombineover('G10_30PkRatePerITIsubInt','MnPkRatePerITISubInt10_30')
figure;plot(1:31,mean(Experiment.G10_30PkRatePerITIsubInt))

%% Distribution of Post-Acquisition Within-CS Poking
TSsettrialtype('CS') 
TSlimit('Subjects',[Experiment.GrpCS10 Experiment.GrpCS10X4 Experiment.GrpCS40]) 

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

% 
TSlimit('Subjects',[Experiment.GrpCS10 Experiment.GrpCS10X4 Experiment.GrpCS40])
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
%%
% Aggregating Profiles to Experiment Level by Group
TSlimit('Subjects',[Experiment.GrpCS10 Experiment.GrpCS10X4])
    TScombineover('GrpsCS10PstAcqProfile','PkRateProfileInCSpostAcq')
    %%
    colnum = 11;
    TSapplystat('GrpsCS10PstAcqProfile','GrpsCS10PstAcqProfile',@rs,colnum)
    %{
    function O = rs(cv,cols)  
    O = reshape(cv,cols,[]); % converts column vector to 11-col array
    O(end,:)= []; % deleting terminal 0 (11th row)
    O=O'; % columns to rows
    %}
    TSapplystat('GrpsCS10ProfileMean','GrpsCS10PstAcqProfile',@mean)
    TSapplystat('GrpsCS10ProfileSE','GrpsCS10PstAcqProfile',@stder)
    %{
    function se = stder(v)
    se = std(v)/sqrt(numel(v));
    %}
%%    
TSlimit('Subjects',Experiment.GrpCS40)
    TScombineover('Grp40PstAcqProfile','PkRateProfileInCSpostAcq')
    TSapplystat('Grp40PstAcqProfile','Grp40PstAcqProfile',@rs,colnum)
    TSapplystat('Grp40ProfileMean','Grp40PstAcqProfile',@mean)
    TSapplystat('Grp40ProfileSE','Grp40PstAcqProfile',@stder)

   
%% Graphing Subject-by-Subject Within-CS, Post-Acq Poke Frequency Profiles 
G = {Experiment.GrpCS10 Experiment.GrpCS10X4 Experiment.GrpCS40};
Gnms = {'CS10' 'CS10X4' 'CS40'};
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
            set(gca,'XTick',[1 5 10])
            if g>2
                set(gca,'XTickLabel',{'4' '20' '40'})
            end
            if plt>6
                xlabel('Time Elapsed in CS (s)')
            end
            if mod(plt,2)>0
                ylabel('Pks/s')
            end
        plt=plt+1;
    end
    saveas(gcf,['/Users/galliste/Dropbox/InhibitoryExperiments_All/Ms Draft/Figures/Experiment 2' ...
        '/PstAcqWIcsPkFreqProfileCS' Gnms{g} '.pdf'])
end

%% Errorbar Graphs of Group Within-CS Post-Acq Response Freq Profiles
Nms = {'1' '5' '10'};
figure
Ax1=subplot(2,1,1);
    TSapplystat('',{'GrpsCS10ProfileMean' 'GrpsCS10ProfileSE'},...
        @EB,Ax1,Nms)
    %{
    function EB(m,se,Ax,Nms)
    figure
    errorbar(Ax,1:10,m,se,se)
    set(gca,'XTick',[1 5 10],'XTickLabel',Nms)    
    %}
    ylabel('Pokes/s')
Ax2=subplot(2,1,2);
    Nms = {'1' '20' '40'};
    TSapplystat('',{'Grp40ProfileMean' 'Grp40ProfileSE'},...
        @EB,Ax2,Nms)
xlabel('Time Elapsed in CS (s)');ylabel('Pokes/s')

%% Average # of USs per ITI
TSlimit('all')
TSapplystat('USperITI',{'AllITIdurs' 'AllITIUSs'},@USsPerITI)

TSlimit('Subjects',Experiment.GrpCS10)
    TScombineover('GrpCS10USsPerITI','USperITI')
TSlimit('Subjects',Experiment.GrpCS40)
    TScombineover('GrpCS40USsPerITI','USperITI')
TSlimit('Subjects',Experiment.GrpCS10X4)
    TScombineover('GrpCS10X4USsPerITI','USperITI')

    %% Subject level summary stats for assembly at Experiment level and export 
% to long table
TSlimit('Subjects',1:31)
E = 2; % Experiment #
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
    
%% Text put in ExpNotes
str =char({'Design';'Groups CS10, CS40 & CS10_30 had 32 CSs and 32 USs.';...
    'The ITI was 20s exponentially distributed. USs occurred only';...
    'during ITIs. The CS10_30 had 10s CSs followed by fixed dead';...
    'period of 30s during which USs could not occur, followed by the';...
    'exponentially distributed ITI w expectation of 20s. Group CS10x4';...
    'same as CS but sessions lasted 4 times longer--4 times as many trials.';...
    ' ';'The function that estimates the acquisition point';...                
    'initializes the estimate to 4500, which is not a possible value,';... 
    'because there were not that many trials. This is done for graphic';...
    'reasons (so that failures to acquire are evident in the plots of';... 
    'the cumulative distributions of trials to acquisition). When we';...  
    'compute median trials to acquisition for the 5 groups, we set';...    
    'medians of 4500 to nan''s'});
Experiment.ExpNotes=str;