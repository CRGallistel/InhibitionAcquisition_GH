function [GperU,GperT] = InfoGain(A)
% A is 3-col array from 'MergedUSandCS' field. Event times in Col 1; CSoff
% (-1) and on (+1) in 2nd col; US flags in 3rd. Code modified 2.12.17 and
% not yet run (debugged) 

GperU = []; GperT = [];
CmCS=zeros(size(A,1),1);
Ton=0;
for r=2:length(CmCS)
    if A(r,2)>0 % CS onset
        Ton = -A(r,1);
        CmCS(r) = CmCS(r-1); % carry forward previous value
    elseif Ton && ~(A(r,2)<0) % during a CS
        CmCS(r) = CmCS(r-1)+A(r,1)+Ton; % increment by time elapsed since Ton
    elseif A(r,2) <0  % end of CS
        CmCS(r) = CmCS(r-1) + A(r,1)-A(r-1,1); % add increment
        Ton = 0; % zero Ton
    else % during ITI
        CmCS(r) = CmCS(r-1); % carry forward previous value
    end
end   
Aaug = [A CmCS]; % adds 4th column that gives cumulative CS duration
Aaug = [Aaug cumsum(A(:,3))]; % adds a 5th column that gives the US count
Aaug = [Aaug cumsum(A(:,2)<0)]; % adds a 6th column that gives the trial
%
% At any given row, Tb is in the 1st column of Aaug, Tcs is in 6th col),
% Nb is in the 5th col, Ncs = 0 (# of USs during CSs), and the trial count
% is in the 6th col. Therefore:
[~,UScntIncRows] = unique(Aaug(:,5)); % rows where US count increments
[~,TrlcntRows] = unique(Aaug(:,6)); % rows where CS count incremented
strtr = find((Aaug(:,4)>0)&(Aaug(:,5)>0),1); % 1st row where lambdaC can be
% computed
UScntIncRows(UScntIncRows<strtr)=[]; % deleting early rows where lambdaC
%  cannot be computed
Aaug(:,7) = cumsum(cumsum(A(:,2))&A(:,3)); % count of USs during CSs
% cumsum(A(:,2)) is a logical vector flagging rows when CS present;A(:,2)
% flags USs; ANDing them gives an LV that flags USs during CSs; cumsumming
% that logical vector gives the count
Aaug(1,8:12)=0; % zeros in columns 8 through 12, the columns into which the
% five different cost calculations will be put
%%
for r = UScntIncRows'            
     % lambdaR = [Aaug(r,5)/Aaug(r,1) 0]; % raw rate vector
%      lambdaR = [Aaug(r,5)/Aaug(r,1) Aaug(r,7)/Aaug(r,4)]; % raw rate vector
     % Aaug(r,5) is US count; Aaug(r,1) is Tb; Aaug(r,7) is Ncs (# of USs
     % during CS); Aaug(r,4) is Tcs, time on the CS clock
     Tb = Aaug(r,1); % cumulative background time
     Tcs = Aaug(r,4); % cumulative CS time
     Nus = Aaug(r,5); % US count;
     Ncs = Aaug(r,7); % count of USs during CSs
     Aaug(r,8:12) = InfoGains_local(Tb,Tcs,Nus,Ncs);
end
%
for i = strtr:length(Aaug) % filling in repeating values for 0's in Col 7
    if Aaug(i,8)==0
        Aaug(i,8:12)=Aaug(i-1,8:12);
    end
end
GperU = Aaug(UScntIncRows,[5,8:12]); % gain as of each US
GperT = Aaug(TrlcntRows,[6,8:12]); % gain as of each CS offset

function G = InfoGains_local(Tb,Tcs,N,Ncs)
% Code for computing different measures of information gain
%%
Lb_raw = N/Tb; % raw rate estimate for background
Lcs_raw = Ncs/Tcs; % raw rate estimate for CS
T = [1 Tcs/Tb;1 1]; % temporal coefficient matrix
L_C = T^-1*[Lb_raw;Lcs_raw]; % corrected rate vector; L_C(1) = rate estimate
% attributed to background; L_C(2) = rate estimate attributed to CS
Dkl1 = log(L_C(1)/Lb_raw) + Lb_raw/L_C(1) - 1; % The divergence
% OF the raw rate for the background FROM the corrected rate.
Dkl2 = log(Lb_raw/L_C(1)) + L_C(1)/Lb_raw - 1; % The divergence OF the
% corrected rate for the background FROM the raw rate
if Ncs==0
    Dkl3 = log(Lb_raw/(1/Tcs)) + (1/Tcs)/Lb_raw -1; % The divergence OF the 
    % upper limit on the rate during the CS FROM the raw background rate
    Dkl4 = log((1/Tcs)/Lb_raw) + Lb_raw/(1/Tcs) -1; % The divergence OF the 
    % raw background rate FROM upper limit on the rate during the CS
    Dkl5 = log(L_C(1)/(1/Tcs)) + (1/Tcs)/L_C(1) -1; % The divergence OF the
    % upper limit on the CS rate FROM the corrected background rate
else
    Dkl3=nan;Dkl4=nan;Dkl5=nan;
end
    
G1 = N*Dkl1; % The cost of encoding the observed intervals using the raw
% background rate rather than the RET estimate of that rate
G2 = N*Dkl2; % The cost of encoding the observed intervals using the RET
% estimate rather than the raw rate, in other words, of erroneously
% assuming that the raw rate is a better estimate than the RET rate
G3 = Dkl3; % The cost of assuming the raw background rate obtains during
% the CS as well
G4 = N*Dkl4; % The cost of assuming that the raw background rate is the same
% as the upper limit on the rate based on CS observation
G5 = Dkl5; % The cost of assuming that the rate during the CS is the same
% as the corrected background rate

G = [G1 G2 G3 G4 G5];

