function O = PksPerSbIntVar(PkTms,TD,subInterval)
% Output is the poking rate within each successive subInterval of the CS.
% TD is the trial duration; PkTms is the vector of times within the CS at
% which pokes occurred. The 2nd col of the output gives the successive
% second counts
Edges=0:subInterval:TD+.001; % edges for histc command
o = histc(PkTms',Edges)/subInterval;% poke rates in successive sub-interval
o(end)=[]; % deleting final value, which is always 0
c2 = (1:length(o))'; % count sequence
O = [o' c2];