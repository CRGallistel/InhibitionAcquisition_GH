function O = MnRspRates(A,AcqPt,CSdur) 
LV1 = A(:,2)==1; % flags 1st sec in each trial
TrlCnt = cumsum(LV1); % trial count
ra = find(TrlCnt==AcqPt,1); % row at which acquisition occurred
Ab = A(1:ra-1,:); % pre acquisition array
Aa = A(ra:end,:); % post acquisition array
mxb = max(Ab(:,2)); % maximum # seconds in a pre-acquisition CS
O = nan(1,CSdur); % initializing output vector
for n = 1:CSdur % stepping through the possible #s of seconds up to the
    % mean CS duration
    LVb = Ab(:,2)==n; % flags the nth seconds in pre-acq trials
    mb = mean(Ab(LVb,1)); % mean pre-acquisition resp rate in second n 
    LVa = Aa(:,2)==n; % flags the nth seconds in post-acq trials
    ma = mean(A(LVa,1)); % mean post-acquisition resp rate n second n
    O(n) = ma/mb; % post acq rate during second n normalized by the pre-acq
    % rate during that second
end
    