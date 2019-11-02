Six experiments with Sprague-Dawley (Charles River)rats on the effects of varying time and number in inhibitory protocol parameters on trials to acquisition and post-acquisition response profiles during the CS. Food reinforcements occurred during the inter-trial intervals but not during the CSs. Data were analyzed with the TSlib toolbox, a copy of which is in the TSlib repository on GitHub. The Final CodeFiles folder contains a subfolder for each experiment. In that subfolder is the Matlab script for that experiment and the helper functions. The script file is titled SCRIPT_<ExperimentName>. The SimpleAcqPt helper function found the acquisition points. The Profile helper function computes the post acquisition within CS response rate profiles and puts the results in the  'PkRateProfileInCSpostAcq' field at the Subject level.

Experiment 1 Design                                                   
32 trials per session                                                 
32 reinforcers per session                                            
ITI: exponential with mean of 20s                                     
Reinforcement only during ITIs, exponential w mean 20s                
CS durs 10, 20, 40 & 80s';'All 4 CSdurs occurred randomly in rnd group
Reinforcement during both ITI and CS in random group,                 
exponential with mean of 50s to match to overall rate in other groups 
Experiment ran for 35 sessions

Experiment 2 Design
Groups CS10, CS40 & CS10_30 had 32 CSs and 32 USs.
The ITI was 20s exponentially distributed. USs occurred only
during ITIs. The CS10_30 had 10s CSs followed by fixed dead
period of 30s during which USs could not occur, followed by the
exponentially distributed ITI w expectation of 20s. Group CS10x4
same as CS but sessions lasted 4 times longer--4 times as many trials.

Experiment 3 Design
32 trials per session, 32 reinforcers per session.               
At least 42 sessions for each subject.                           
ITI = mean of 20s with exponential distribution.                                                                                 
Mean CS duration was either 30 or 50s.                           
For one group at each mean CS duration,the duration              
was fixed; for another it varied exponentially.                                                                                   
Reinforcer delivery = exponential distributed w mean = 20s,
only in ITIs

Experiment 4 Design                                                     
32 trials per session, 32 reinforcers per session.                                                                                    
ITI = mean exponential distribution with mean = 20.                                                                                   
CS duration fixed at 20 40 or 80.                                                                                                     
Reinforcer delivery = exponential distributed w mean = 20s or 40,  
as indicated by group names; pellets delivered only in the ITI.                                 
Sessions 1:44 were inhibitory conditioning, with no USs during CSs;
Sessions 45:end were "resistance to extinction" sessions, with USs during the CSs

Experiment 5 Design
These group names give expectation of exponentially distributed
ITI durations and the durations of the fixed-duration CS.
No matter what the expected duration of the ITI, the average
interval between USs during ITIs was 20s. Thus, for groups
with longer ITIs, the average number of USs during an ITI
was greater than 1. Session ended when subject had received 32 USs and 8 CSs.

Experiment 6 Design
{This needs to be filled in~}  