function O =PksPerSbInt(PkTms,TD,subInterval)
% Output is the poking rate within each successive subInterval of the CS.
% TD is the trial duration; PkTms is the vector of times within the CS at
% which pokes occurred
Edges=0:subInterval:TD+.001; % edges for histc command
O = zeros(1,length(Edges)-1);
O = histc(PkTms',Edges)/subInterval;% poke rates in successive sub-interval
O(end)=[]; % deleting final value, which is always 0