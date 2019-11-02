function Info = InfoAtAcq(CmGain,AcqPt)
% Modified 06/07/2017 when I changed the computation of the info gain
if isempty(AcqPt) || isnan(AcqPt) || (AcqPt==1500)
    Info(1,1:size(CmGain,2)-1) = 100000; % out of range figure to signal that 
    % subject did not acquire (put in rather than nan so that it will be 
    % manifest in cumulative distributions of info at acquisition)
else
    LV = CmGain(:,1)==AcqPt; % flags acquisition row
    Info = CmGain(LV,:);
    Info(:,1)=[]; % dropping the column that contains the acquisition trial
    % number; in this way, the output has however many different
    % computations of the infogain per trial there are in the CmGain input
    % field
end