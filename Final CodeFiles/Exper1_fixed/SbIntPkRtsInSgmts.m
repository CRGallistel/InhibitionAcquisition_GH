function A = SbIntPkRtsInSgmts(CSrts,ITIrts,AcqPt,NmSgmts)
% Divides the postacquisition trials into NmSgmts successive segments and
% computes the mean poke rates per CS sub-interval for each segment and
% ouputs and array with NmSgmts rows and number-of-subintervals columns.
% The within-CS poke rates on each trial are normalized by the
% corresponding ITI poke rate. CSrts is an array with as many rows as there
% were trials and as many columns as there are CS sub-intervals
A = nan(NmSgmts,size(CSrts,2));

if AcqPt < 1500 % subject acquired
    CSrts(1:AcqPt-1,:) = []; % discarding pre-acq data
    ITIrts(1:AcqPt-1) = []; % discarding pre-acq data
    Da = CSrts./repmat(ITIrts,1,size(CSrts,2)); % CS poke rates normalized by
    % corresponding ITI poke rates
    Da(isinf(Da)) = nan; % 0s in the ITIrts cause either nans or infinities
    % in the normalized subsegment rates. Setting the infinities to nans
    % enables use of nanmean to ignore these rows
    SegLength = floor(size(Da,1)/NmSgmts); % # trials in a post-acq segment
    for r = 1:NmSgmts
        A(r,:) = nanmean(Da((r-1)*SegLength+1:r*SegLength,:));
    end
else % subject did not acquire
    A = [];
end
    