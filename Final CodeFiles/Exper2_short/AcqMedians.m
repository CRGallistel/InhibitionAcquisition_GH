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