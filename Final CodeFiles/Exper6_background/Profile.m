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