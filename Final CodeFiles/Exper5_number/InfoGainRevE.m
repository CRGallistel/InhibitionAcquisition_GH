function [GperU,GperT] = InfoGainRevE(A,alpha)
% A is 3-col array from 'MergedUSandCS' field. Event times in Col 1; CSoff
% (-1) and on (+1) in 2nd col; US flags in 3rd. Code modified 2.12.17 and
% not yet run (debugged). This version of InfoGain computes does the
% calculation the way it notionally should be done. That is, it uses the
% complete Dkl formula and a prior (the alpha constant = .5) so that no
% rate is every 0 and it computes G = Niti*DklITI + Ncs*DklCS, where Niti
% is the number of USs during ITIs and DklITI is the divergence OF
% lambdaRaw FROM lambdaITI, Ncs is the number during the CSs, and DklCS is
% the divergence OF lambdaRaw from lambdaCS. The 'E' in 'InfoGainRevE' is
% for Exact 

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
[~,TrlcntRows] = unique(Aaug(:,6)); % rows where CS count increments
strtr = find((Aaug(:,4)>0)&(Aaug(:,5)>0),1); % 1st row where lambdaC can be
% computed
UScntIncRows(UScntIncRows<strtr)=[]; % deleting early rows where lambdaC
%  cannot be computed
Aaug(:,7) = cumsum(cumsum(A(:,2))&A(:,3)); % count of USs during CSs
% cumsum(A(:,2)) is a logical vector flagging rows when CS present;A(:,2)
% flags USs; ANDing them gives an LV that flags USs during CSs; cumsumming
% that logical vector gives the count
Aaug(1,8)=0; % zeros in columns 8 through 12, the columns into which the
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
     Aaug(r,8) = InfoGains_local(Tb,Tcs,Nus,Ncs,alpha);
end
%
for i = strtr:length(Aaug) % filling in repeating values for 0's in Col 7
    if Aaug(i,8)==0
        Aaug(i,8)=Aaug(i-1,8);
    end
end
GperU = Aaug(UScntIncRows,[5,8]); % gain as of each US
GperT = Aaug(TrlcntRows,[6,8]); % gain as of each CS offset

function G = InfoGains_local(Tb,Tcs,Nb,Ncs,alpha)
% Code for computing measure of cost of assuming raw background rate
% applies during both ITI and CS

Niti = Nb-Ncs + alpha; % alpha comes from the prior; it prevents the rate
% estimate from ever being 0. Defensible values for alpha are .5 or 1

Ncs = Ncs + alpha; % ditto

Nb = Nb + alpha; % ditto

lamITI = Niti/(Tb-Tcs); % "observed" rate during the ITI (modified by the prior)
lamCS = Ncs/Tcs; % "observed" rate during the CS (modified by the prior)
lamRaw = Nb/Tb; % "observed" raw rate

DklITI = log(lamITI/lamRaw) + lamRaw/lamITI - 1; % The divergence
% OF the raw rate for the background FROM the observed rate. This is the
% cost per interval of encoding the US-US intervals on the ITI clock using
% the raw US rate instead of the corrected background rate
DklCS = log(lamCS/lamRaw) + lamRaw/lamCS - 1; % The divergence OF the
% raw rate from the rate observed during the CS

G = Niti*DklITI + Ncs*DklCS;
    


