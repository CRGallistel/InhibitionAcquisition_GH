function [Phst = normhist(D,AcqPt)
% D is a 3 col vector with poke times w/i CS in 1st col, trial in 2nd col,
% and session in 3rd column. AcqPt is trials to acquisition
NumSes = 35;
TrlsPerSes =32;
TotalTrls = NumSes*TrlsPerSes;
Mx = max(D(:,1)); % maximum poke time w/i CS, from which I can infer
    % CS duration
if Mx <=10
    CSdur = 10;
elseif Mx <=20
    CSdur = 20;
elseif Mx <+ 40
    CSdur = 40;
else
    CSdur = 80;
end % of inferring CS duration

Edges=2.5:2.5:CSdur; % edges for histc command

if AcqPt<1500 % if there really was an acquisition point
    APses = AcqPt/TrlsPerSes; % Session + frac session at acquisition
    ses = floor(APses); % session in which acquisition occurred
    FracSes = APses-ses;
    Trl = round(FracSes*TrlsPerSes); % trial w/i the acq session 
    
    r = find(D(:,2)==ses); % rows for acquisition session
    t = find(D(r,3)>Trl); % 1st post-acq row w/i that set of rows
    rr = r(1)+t; % row at which post-acq data begin
    
    Npre = histc(D(1:rr-1,1),Edges); % pre histogram
    
    PreAcqPkRatePer2pt5s = 
    
    Npost =  histc(D(rr:end,1),Edges); % post histogram
    
    
    
    
    
    N = histc(D(rr:end),Edges); % Numbers of pokes falling within each 2.5s
    % subdivision of the CS
    
    PostAcqPkRatePer2pt5s = N/(TotalTrls-AcqPt); % rate of post-acq pokes
    % within each successive 2.5s subdivision of the CS interval
    
    hst = PostAcqPkRatePer2pt5s/PreAcqPkRatePer2pt5s; % normalized by the
    % pokes per 2.5s unit of CS time prior to acquisition.
    
else % there was no acquisition point
    
    hst = hist(D); % same as above but for all the data (to show how pre-
    % acquisition pokes are distributed within the CS
    
    hst = hst/sum(hst); % normalizing (converting counts to a set of
    % probabilities that sum to 1, i.e., a discrete probability distribution)
end