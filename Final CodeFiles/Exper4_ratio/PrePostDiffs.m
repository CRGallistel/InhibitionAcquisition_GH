function [CSdiff,ITIdiff]=PrePostDiffs(CSrates,ITIrates,AcqPt)
CSdiff=[];ITIdiff=[];
if AcqPt<1500
    CSdiff = mean(CSrates(AcqPt:end)) - mean(CSrates(1:AcqPt-1));
    ITIdiff = mean(ITIrates(AcqPt:end)) - mean(ITIrates(1:AcqPt-1));
end