function A = CSandUSarray(tsd)
A=[];
Toneon=61;Toneoff=51;Pelletdelivered=21; % event codes
D = tsd((tsd(:,2)==Toneon)|(tsd(:,2)==Toneoff)|(tsd(:,2)==Pelletdelivered),:);
LVon = D(:,2)==Toneon;
LVoff = D(:,2)==Toneoff;
LVus = D(:,2)==Pelletdelivered;
A = [[0 0 0];[D(:,1) LVon-LVoff  LVus]];
% Prior to 1/25/17, the above line of code was
% A = [[0 -1 0];[D(:,1) LVon-LVoff  LVus]]; because I thought I would later
% want to use cum sum to get -1's during ITIs and 0s during CSs. However,
% it turned out that the way I used the array, the initial -1s at session
% onset made computing cumulative CS duration harder, so I went back and
% changed the code to eliminate these initial -1s. This should not affect
% any of what I have already run (Experiments 1, 2 & 6) because they all
% had fixed CS durations and I used that fact to compute cumulative time in
% the CS. HOWEVER, the new code is more general, that is, it applies
% whether CS duration is fixed or not, so to be safe, I SHOULD go back and
% recompute those CS and US arrays and the information available per trial
% and per US--just to be sure. IN OTHER WORDS, RERUN THE CELL THAT
% COMPUTES 'USandCStimes' AND ALL THE CELLS THAT DEPEND ON THIS FIELD!!!