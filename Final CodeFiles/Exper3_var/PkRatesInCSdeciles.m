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