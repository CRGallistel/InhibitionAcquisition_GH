function [nDkl,p,pdfLamC,pdfLamCS] = ExpoNDkl(Ncs,Tcs,Nc,Tc,Plot)
% Computes the nDkl statistic and its significance:
% syntax   [nDkl,p,pdfLamC,pdfLamCS] = ExpoNDkl(Ncs,Tcs,Nc,Tc,Plot)
% Ncs = cumulative number of reinforcements during the CSs
% Tcs = cumulative CS duration
% Nc = cumulative number of reinforcements
% Tc = cumulative duration of context (cumulative session time)
%%
if Ncs>Nc
    fprintf('\ninput error: Ncs must be <=Nc\n')
end
if Tcs>=Tc
    fprintf('\ninput error: Tcs must be <Tc\n')
end
a0 = 1; % Jeffreys prior on lambda is<= gamma(1,0)
%%
lamC = round([1 Tcs/Tc;1 1]^-1*[Nc/Tc;Ncs/Tcs],4); % 
% [1 Tcs/Tc;1 1] = temporal coefficient matrix; [Nc/Tc;Ncs/Tcs] = raw rate
% vector. lamC = corrected rate vector; lamC(1) = rate ASCRIBED to context
% (NB not the RAW BACKGROUND RATE, Nc/Tc, which is the comparison rate
% when assessing the evidence that the CS matters; 2nd = ascribed CS rate.
% When there are only 1 or 2 USs, the matrix computation sometimes yields 
% a minute negative value for the  corrected background rate. It can never 
% be negative. The rounding sets it to 0 when it is estimated to be
% negative.
%%
Min = min(lamC);
Mx = max(lamC);
if Min==0
    dlam = .01*Mx; % rate scale
else % both rates non zero
    dlam = .01*Min; % time scale for numerical intergration
end
lam = dlam:dlam:10*Mx; % vector of possible rate values
%%
plamCraw = gampdfab(lam,a0+Nc,Tc); % unnormalized posterior dist on lam_C
plamCraw = plamCraw/sum(plamCraw); % normalizing posterior distribution on
% raw contextual rate
[~,Imd] = max(plamCraw);
mdplamCraw = lam(Imd); % mode of posterior predictive (maxmium likelhood
% value for raw context rate
mnplamCraw = sum(plamCraw.*lam); % mean of posterior predictive (best
% best Bayesian estimate of raw context rate
%%
plamCSest = gampdfab(lam,a0+lamC(2)*Tcs,Tcs); % unnormalized posterior on lam_CS
plamCSest = plamCSest/sum(plamCSest); % normalizing posterior dist on lam_CS
[~,Imd] = max(plamCSest);
mdplamCSest = lam(Imd); % mode of posterior predictive (maxmium likelhood
% value for raw context rate
mnplamCSest = sum(plamCSest.*lam); % mean of posterior predictive (best
% best Bayesian estimate of raw context rate
%%
UL = find(plamCSest>.01*max(plamCSest),1,'last');
pdfLamC = [lam(1:UL)' plamCraw(1:UL)'];
pdfLamCS = [lam(1:UL)' plamCSest(1:UL)'];
%%
if Plot
    figure
    plot(pdfLamC(:,1),pdfLamC(:,2),pdfLamCS(:,1),pdfLamCS(:,2))
    xlabel('\lambda','FontSize',24)
    ylabel('prob density')
    legend('Context','CS','location','NE')
end
%%
Dkl = expoKL(mdplamCSest,mdplamCraw); % divergence OF raw contextual rate
% estimate from CS rate estimate

nDkl = Ncs*Dkl;
p = 1-gamcdf(nDkl,.5,1);
end

