function AP = SimpleAcqPt(Diffs,dwn)
% dwn is the threshold fall in the record
AP = 4500; % greater than total # of trials (Grp10X4 has 4352)
CmSm = cumsum(Diffs); % cumulative record of differences
[Mx,Imx] = max(CmSm); % maximum of cumulative record
APtent = find(CmSm(Imx:end) < Mx-dwn,1)+Imx; % trial at which record has
% dropped by dwn from its maximum
if (CmSm(end)< -2*dwn) && (CmSm(end) < CmSm(APtent)-dwn) % record continued
    % fall after crossing the threshold for "acquisition" and ended at
    % least 2*dwn below 0
    AP = APtent;
end