% exploratory code for assessing how well the new (04/10) way of computing
% info gain predicts not only the 6 inhibition experiment results and the
% Gibbon and Balsam (1980) results but also the poor positive results
% (Balsam, Fairhurst and Gallistel (2006) results. The new way brings in a
% "prior" to the estimation of a rate by adding 0.5 (or maybe 1) to the
% cumulative number of USs observed during both the ITIs and during the
% CSs. The function that implements this new calculation of information
% gain is ExcessCostOfNull, where "Null" refers to the null hypothesis that
% the lower of the two raw rates (ITI & CS) is not different from the
% higher. THIS WHOLE EFFORT DID NOT PAN OUT. I NOW USE THIS SCRIPT AS A
% CODE SCRATCH PAD

He = 20*ones(8,4);
ITIdur = 20;
%%
NumTrls = Grp80sAcqPts;
Grp = 4;
CSdur = 80;
%
Per = ITIdur+CSdur; % cycle period
Liti = .0496;
Lcs = 0;


for t = 1:length(NumTrls)
    if NumTrls(t)==1500
        continue
    else
        Tb = NumTrls(t)*Per;
        Tcs = NumTrls(t)*CSdur;
        Ncs = Lcs*Tcs; % total number of USs when CS present
        Niti = Liti*(Tb-Tcs); %  cumulative number of ITI USs 
        Nb = Niti+Ncs; % cumulative USs
        H(t,Grp) = ExcessCostOfNull(Tb,Tcs,Nb,Ncs);
    end
end


%% Experiment 1 nats to acquisition plots
cdfplot(H(:,1))
hold on
cdfplot(H(:,2))
cdfplot(H(:,3))
cdfplot(H(:,4))

%% Gibbon and Balsam (1980)
% Following numbers derived from C/T plot of Gibbon & Balsam data
CSdur = 20;
ITIdur = 180;
TrlsAtAcq = 40;
% The above values come from where the regression lines cross, so are
% valid for either regression
CSdur = 5;
ITIdur = 45;
TrlsAtAcq = 40;
% Same but with different scale

% Values below are for left (high) end of the regression
CSdur = 5;
ITIdur = 5;
TrlsAtAcq = 140; % best fit regression
TrlsAtAcq = 190; % slope -1 regression

CSdur = 20;
ITIdur = 20;
TrlsAtAcq = 140; % best fit
TrlsAtAcq = 190; % slope = -1

% Values below are for right (low) end of regression
CSdur = 5;
ITIdur = 245;
TrlsAtAcq = 10; % best fit
TrlsAtAcq = 7; % slope = -1

CSdur = 20;
ITIdur =980;
TrlsAtAcq = 10; % best fit
TrlsAtAcq = 7; % slope = -1

%% Using above values and InfoGain (06/03/2017)
CSdur = 5;
ITIdur = 5;
% TrlsAtAcq = 140; % best fit regression
TrlsAtAcq = 190; % slope -1 regression
Tb = TrlsAtAcq*(CSdur+ITIdur);
Tcs = TrlsAtAcq*CSdur;
Ncs = TrlsAtAcq;
Nb = TrlsAtAcq;
alpha = .5;
[Grfc,Gcfr] = InfoGain(Tb,Tcs,Nb,Ncs,alpha);
% G = 94 % when using best fit regression estimate & alpha =1
% G = 129 when using slope -1 & alpha = 1
% Changing alpha to .5 has negligible effect on these results
% When running the divergences the other way around and using the slope -1
% value, I get Gcfr = 61 
%%
CSdur = 5;
ITIdur = 245;
% TrlsAtAcq = 10; % best fit regression
TrlsAtAcq = 7; % slope -1 regression
Tb = TrlsAtAcq*(CSdur+ITIdur);
Tcs = TrlsAtAcq*CSdur;
Ncs = TrlsAtAcq;
Nb = TrlsAtAcq;
alpha = .5;
[Grfc,Gcfr] = InfoGain(Tb,Tcs,Nb,Ncs,alpha);
% G = 39 when using best fit regression estimate & alpha = 1
% G = 27 when using slope -1 & alpha = 1
% Changing alpha to .5 has negligible effect on these results
% Running it other way round and using slope -1 values, gives Gcfr =339
%% Poor positive experiment using InfoGain algorithm (06/03/2017) Exper 1A (control)
CSdur1 = 21; % gain at end of every CS (I suspect 21 is a typo; should be 12)
CSdur2 = 12;
ITIdur = 96; % no ITI reinforcements
% The raw rate of CS reinforcement in this group was either 1/21 or 1/12,
% that is, either .0476 or .0833; the rate of ITI reinforcement was 0
Ncs = 24; % median number of CS reinforcements at acqusition (from Figure 1C
% in B,F,&G 2006)
Tcs1 = Ncs*CSdur1;
Tcs2 = Ncs*CSdur2;
Niti = 0;
Tb1 = Ncs*(CSdur1+ITIdur);
Tb2 = Ncs*(CSdur2+ITIdur);
Nb = Ncs;
[G1rfc,G1cfr] = InfoGain(Tb1,Tcs1,Nb,Ncs,alpha);
[G2cfr,G2cfr] = InfoGain(Tb2,Tcs2,Nb,Ncs,alpha);
% G1rfc = 40 
% G2rfc = 51
% G1cfr = 71
% G2cfr = 143
%% Poor Positive Experiment 1A (experimental group)
CSdur1 = 21; % gain at end of every CS (I suspect 21 is a typo; should be 12)
CSdur2 = 12;
ITIdur = 96; % no ITI reinforcements
% The raw rate of CS reinforcement in this group was either 1/21 or 1/12,
% that is, either .0476 or .0833; the rate of ITI reinforcement was 0
Ncs = 24; % median number of CS reinforcements at acqusition (from Figure 1C
% in B,F,&G 2006)
Tcs1 = Ncs*CSdur1;
Tcs2 = Ncs*CSdur2;
Niti = 0;
Tb1 = Ncs*(CSdur1+ITIdur);
Tb2 = Ncs*(CSdur2+ITIdur);
Nb = 2*Ncs; % because there was 1 US in each ITI
[G1rfc,G1cfr] = InfoGain(Tb1,Tcs1,Nb,Ncs,alpha);
[G2rfc,G2cfr] = InfoGain(Tb2,Tcs2,Nb,Ncs,alpha);
% G1rfc = 13
% G2rfc = 23
% G1cfr = 22
% G2cfr = 53
%%
% What B,F & G 2006 basically shows is that changing the ratio of the CS
% rate to the background rate has the same effect on acquisition whether
% one changes it by changing the C/T or by changing the rate of background
% reinforcement, that is, by adding ITI reinforcements.So, when the rate
% ratio was 16/1, trials to acquisition was 13. When the rate ratio was
% 2/1, trials to acquisition was 75
%% code for computing H values given above Gibbon and Balsam (1980) numbers
NumTrls = [40 40 140 190 140 190 10 7 10 7]; % taken from TrlsAtAcq #s above
CSdur = [20 5 5 5 20 20 5 5 20 20]; % taken from corresponding CSdur values
ITIdur = [180 45 5 5 20 20 245 245 980 980]; % from corresponding ITI values
H = nan(10,1);
for t = 1:10
    Per = ITIdur(t)+CSdur(t); % cycle period
    Liti = 0;
    Lcs = 1/CSdur(t);
    Tb = NumTrls(t)*Per;
    Tcs = NumTrls(t)*CSdur(t);
    Ncs = NumTrls(t); % total number of USs when CS present
    Niti = 0; %  cumulative number of ITI USs 
    Nb = NumTrls(t); % cumulative USs
    H(t) = ExcessCostOfNull(Tb,Tcs,Nb,Ncs);
end

%{
H =

          2.80  using either regression at the crossing point (C/T = 10)
          2.80   same value obtained when C & T scaled down by 4

          2.32  using best fit regression at high end of regression (C/T=2)
          2.47  using slope = -1 regression at high end
          2.32  same as above but with C & T values scaled up by 4
          2.47  same as above but with C & T values scaled up by 4

          2.97  using best fit regression at low end (C/T = 50)
          2.80  using slope = -1 regression at low end (C/T = 50)
          2.97  same as above but with C & T scaled up by factor of 4
          2.80  same as above but with C & T scaled up by factor of 4
%}

%% Poor Positive data (Balsam, Fairhurst & Gallistel, 2006)
% Experiment 1A control group
CSdur1 = 21; % gain at end of every CS (I suspect 21 is a typo; should be 12)
CSdur2 = 12;
ITIdur = 96; % no ITI reinforcements
% The raw rate of CS reinforcement in this group was either 1/21 or 1/12,
% that is, either .0476 or .0833; the rate of ITI reinforcement was 0
Ncs = 40; % median number of CS reinforcements at acquisition (from Figure 1C
% in B,F,&G 2006)
Tcs1 = Ncs*CSdur1;
Tcs2 = Ncs*CSdur2;
Niti = 0;
Titi = Ncs*ITIdur;
Lcs1 = (Ncs+.5)/Tcs1; % rate estimate for the CS; the .5 is the correction from
% the prior. When Ncs=0, then the rate estimate for the CS is .5/Tcs
Lcs2 = (Ncs+.5)/Tcs2;
Liti = (Niti+.5)/Titi; % rate estimate for the background (the ITI). Again,
% the .5 is the correction from the prior. (I imagine gamma(.5,0) as the
% prior, so when Niti = 0, the prior distribution is gamma(.5,Titi)
H1A1c = (Niti+.5)*(log(Lcs1/Liti) + Liti/Lcs1 -1); % The divergence OF the
% rate estimate during the ITI FROM the rate estimate during the CS TIMES
% the number of USs during the ITI (with the .5 addition from the prior).
% If Niti= 0, then this is .5*(log(Lcs/Liti)+Liti/Lcs -1). If the two rate
% estimates are equal
H1A2c = (Niti+.5)*(log(Lcs2/Liti) + Liti/Lcs1 -1);


%%
% Experiment 1A poor positive experimental group
CSdur1 = 21; % gain at end of every CS (rates of either .0476 or .0833
CSdur2 = 12;
ITIdur = 96; % 1 reinforcement per ITI
% the rate of CS reinforcement was either .0476 or .0833, while the rate of
% ITI reinforcement was 1/96 .0104
Ncs = 40; % median number of CS reinforcements at acquisition (from Figure
% 1C in B,F,&G 2006)
Tcs1 = Ncs*CSdur1;
Tcs2 = Ncs*CSdur2;
Niti = Ncs; % there was 1 ITI reinforcement for each CS reinforcement
Titi = Ncs*ITIdur;
Lcs1 = (Ncs+.5)/Tcs1;
Lcs2 = (Ncs+.5)/Tcs2;
Liti = (Niti+.5)/Titi;
H1A1e = (Niti+.5)*(log(Lcs1/Liti) + Liti/Lcs1 -1); % The divergence OF the
% rate estimate during the ITI FROM the rate estimate during the CS TIMES
% the number of USs during the ITI (with the .5 addition from the prior).
% If Niti= 0, then this is .5*(log(Lcs/Liti)+Liti/Lcs -1). If the two rate
% estimates are equal
H1A2e = (Niti+.5)*(log(Lcs2/Liti) + Liti/Lcs1 -1);
%{
H1A1e =

   29.9123

H1A2e

H1A2e =

   52.5768

Disastrously wrong
%}

%%

% Experiment 1B (partial reinforcement) control
CSdur = 12;
ITIdur = 132; % 11*CSdur
% only 4 out of every 10 CS presentations was reinforced; thus, Ncs=.4*NumTrls
% no ITI reinforcements in control group
% The rate of CS reinforcement was .4/12 = .0333; rate of ITI reinforcement
% was 0.
% NumCSreinforcements = 24


% Experiment 1B (partial reinforcement) experimental group
CSdur = 12; 
ITIdur = 132;
% 4 out of 10 CSs were reinforced, 
% 6 out of 110 ITIs were reinforced, so lambda_ITI = 6/(110*12) = .00455
% Rate of CS reinforcement was .0333
% NumCSreinforcements = 24


% The median CS reinforcements to acquisition for all but the 1A exper group
% was 24; for that group, it was 40

%% New tack
% At the end of the poor positive paper, we make the point that our
% calculation of bits acquired per CS assumes that the rate differences are
% known a priori, which, of course, they are not. It makes the point that
% one needs to take into account the growth of knowledge about what that
% difference actually is. At the time, I did not have the conceptual tools
% to do that, but now, with the KL divergence, I do
% close all

alpha_0 = .5;
beta_0 = 0;% initial value of shape parameter in gamma prior on mean
lam = 0:.0005:.0495; % possible values of the exponential expectation

n = [1 2 5 10 20 50 100];
T = 100*n;
pk = nan(7,1);
figure
for i = 1:7
    pd = gampdfab(lam,n(i)+alpha_0,T(i));
    pk(i) = max(pd);
    plot(lam,pd)
    hold on
end
%%
figure
plot(n,.001*pk)

%% Computing the double integral
% Make the array for the joint distribution of the probabilities and the
% corresponding array for the KL divergences, multiply, and sum. Make the
% arrays 101 x 100 (so I know which dimension is which). First problem is
% to choose the range of the vector of values for lambda. The raw rate
% estimate is N/T. Exploratory plots suggest that a range from 0 to 5x(N/T)
% will do the trick
Dkl = nan(8,2);
N =  [1 2 4 8 16 32 64 128];
r = 1;
for n = N
%%  
    N1 = 0; % number on which first rate estimate is based
    T1 = n*100; % observation interval on which first rate estimate is based
    N2 = n; % number on which second rate estimate is based
    T2 = n*10; % observation interval on which 2nd rate estimate is based

    lam1ml = (N1+1)/T1; % maximum likelihood estimate of lam1
    lam2ml = (N2+1)/T2; % maximum likelihood estimate of lam2

    lam1 = linspace(2*lam1ml/101,2*lam1ml,101); % vector of values for 1st rate
    lam2 = linspace(2*lam2ml/100,2*lam2ml,100); % vector of values for 2nd rate

    pd1 = gampdfab(lam1,N1+.5,T1); % probability density function on 1st rate
    pd2 = gampdfab(lam2,N2+.5,T2); % probability density function on 2nd rate
%%
    [PD1,PD2] = meshgrid(pd1,pd2);

    JP = PD1.*PD2; % joint probability array
    JP = JP/sum(JP(:)); % normalizing joint probability distribution

    
    mesh(lam1,lam2,JP) % 3D plot of joint probability distribution
    xlabel('\lambda_1');ylabel('\lambda_2');zlabel('Probability Density')
keyboard
%%
    [Lam1,Lam2] = meshgrid(lam1,lam2);

    Dkl12 = expDKL(Lam1,Lam2); % Dkl array for transition from 2 to 1
    Dkl21 = expDKL(Lam2,Lam1); % Dkl array for transition from 1 to 2
    % figure; mesh(lam1,lam2,Dkl12)
    % xlabel('\lambda_1');ylabel('\lambda_2');zlabel('D_K_L (nats)')
    % figure; mesh(lam2,lam1,Dkl21)
    % xlabel('\lambda_1');ylabel('\lambda_2');zlabel('D_K_L (nats)')    
    %

    Dkl(r,1) = sum(JP(:).*Dkl12(:));
    Dkl(r,2) = sum(JP(:).*Dkl21(:));
    r = r+1;
end
% The double integral is much larger when the n is very small but it
% converges rapidly, so that it is close to the max likelihood value by the
% time the # trials has increased to 10 (or rather by the time the # of
% reinforcers has increased to 10). However, if the n on which the lower
% rate is based does not increase beyond its initial value of .5 or 1, then
% the double integral increases without limit; it does not converge on the
% maximum likelihood result
%{
20:1 rate ratio
DklB =
N   low->high  high->low   N = # of trials; every CS reinforced
1   60.4897    2.1571
2   32.8873    2.0879
4   22.1581    2.0611
8   18.7773    2.0527
16  17.3331    2.0491
32  16.6494    2.0473
64  16.3217    2.0465
ML  16.043     2.0457

2:1 rate ratio
DklS =
1   4.7549    1.3014
2   1.9951    0.6150
    0.9222    0.3470
    0.5842    0.2625
    0.4397    0.2264
    0.3714    0.2093
    0.3386    0.2011
ML  0.3069    0.1931

% poor positive w 5:1 rate ratio
DklBk =
N
1   6.3236    1.0179
2   3.7467    0.8259
4   3.0150    0.7939
8   2.7249    0.8020
16  2.5659    0.8067
32  2.4778    0.8080
ML  2.3984    0.8110
%}
%% Convergence figure
close
figure
subplot(3,2,1)
plot(N(1:7),DklB(1:7,1))
xlim([0 65])
hold on
plot(xlim,[16.043 16.043],'k--')
title({'Low->High';'C/T 20:1, no ITI USs'})
legend('Integrated','Max Like','location','NE')
set(gca,'FontSize',12)
ylabel('Info Gain per Trial (nats)')

subplot(3,2,2)
plot(N(1:7),DklB(1:7,2))
xlim([0 65])
hold on
plot(xlim,[2.0457 2.0457],'k--')
title({'High->Low';' '})
set(gca,'FontSize',12)


subplot(3,2,3)
plot(N(1:7),DklS(1:7,1))
xlim([0 65])
hold on
plot(xlim,[.3069 .3069],'k--')
title('C/T 2:1, no ITI USs')
set(gca,'FontSize',12)
ylabel('Info Gain per Trial (nats)')

subplot(3,2,4)
plot(N(1:7),DklS(1:7,2))
xlim([0 65])
hold on
plot(xlim,[.1931 .1931],'k--')
set(gca,'FontSize',12)


subplot(3,2,5)
plot(N(1:7),DklBk(1:7,1))
xlim([0 65])
hold on
plot(xlim,[2.3984 2.3984],'k--')
title('C/T 5:1, Bkgrnd USs')
set(gca,'FontSize',12)
ylabel('Info Gain per Trial (nats)')

subplot(3,2,6)
plot(N(1:7),DklBk(1:7,2))
xlim([0 65])
hold on
plot(xlim,[.8111 .8111],'k--')
set(gca,'FontSize',12)

%% Sooo...
% It seems that one has to go with the contrasts between the raw background
% rate--which always has an increasing n(!) and the transitions from that to
% the CS. Those transitions are upward (low to high) at CS onset and
% downward at CS offset in the excitatory case and the reverse in the
% inhibitory case. Thus, in the excitatory case, the transitions are from raw
% background to corrected CS and back, while in the inhibitory case, the
% transitions are from raw background to corrected background and back.
% That is, one does not consider transitions to conditions where there are
% no USs(??!?)

%% Maybe the system only uses the scalar approximations (and maybe only one
% of them)

LambRatio = logspace(-2,2);
Dkl = log(fliplr(LambRatio))+LambRatio-1; %
figure
subplot(2,1,1)
plot(LambRatio,Dkl)
hold on
plot(LambRatio,LambRatio,'k--')
set(gca,'FontSize',18)
xlabel('\lambda_A/\lambda_T')
text(1,90,'Approximation > True','FontSize',18)
subplot(2,1,2)
semilogx(LambRatio,Dkl)
ylim([0 4])
hold on
plot(LambRatio,-log(LambRatio),'k--');
set(gca,'FontSize',18,'XTick',[.01 .02 .05 .1 .2 .5 1],'XTickLabel',...
    {'.01' '.02' '05' '.1' '.2' '.5' '1'})
ylim([0 4])
xlim([0 1])
xlabel('\lambda_A/\lambda_T')
text(.01,.3,'Approximation < True','FontSize',18)

%% Entropy of an exponential with n bins
% The low boundary for the last bin should be expinv(1-1/n,mu) with an upper
% boundary of +inf, because then the last bin has probability of
% approximately 1/n. There should be n-1 evenly spaced boundaries between
% 0 and that last low boundary

N = [8 16 32 64 128 256 512 1024];
for i = 1:length(N)
    n = N(i);
    mu = 100;
    edges = [linspace(0,expinv(1-1/n,mu),n) inf];
    D = exprnd(mu,10000,10); % draws from the distribution
    C = histc(D(:),edges); % counts

    P = C/sum(C);% the "empirical" probability distribution
    H(i) = nansum(P.*log2(1./P));
    propMx(i) = H(i)/log2(n);
end
%%
figure
plot(N,propMx)
xlabel('Number of Bins','FontSize',18)
ylim([0 1])
ylabel('H_e/H_u','FontSize',18)
%% Trial by trial reponse patterns after acquisition in 80s duration inhibitory
% CS
D = Experiment.Subject(7).Session(20).PkRatePerCSsubInt;
figure
t=1;
for t = 1:32
    plot(cumsum(D(t,:)))
    hold on
    pause
end
%%
Ncs = [1 2 5];
CSdur = 5;
CTratio = 10;
figure
for i = 1:length(Ncs)
    Tcs(i) = Ncs(i)*CSdur;
    Nc(i) = Ncs(i);
    Tc(i) = Ncs(i)*CTratio*Ncs(i);
    [nDkl(i),p(i),pdfC,pdfCS] = ExpoNDkl(Ncs(i),Tcs(i),Nc(i),Tc(i),false);
    subplot(3,1,i)
    plot(pdfC(:,1),pdfC(:,2),pdfCS(:,1),pdfCS(:,2))
    title(['Number of Trials = ' num2str(Ncs(i))])
    if i==1
        legend('p(\lambda_C)','p(\lambda_C_S)','location','NE')
    elseif i==3
        xlabel('\lambda','Fontsize',24)
    else
        ylabel('Probability Density','FontSize',24)
    end
    Ylm = ylim;
    x = pdfCS(end,1)/4;
    text(x,Ylm(2)/2,['p = ' num2str(p(i),1)])
        
end

[nDkla,pa,pdfC,pdfCSa] = ExpoNDkl(5,25,6,250,true);

%% Plug-in Pavlovian contingencies
lam1 = .005;
lam2 = .01;
DF = nan(5,50);
for c = 1:50
    D1 = exprnd(1/lam1,100000,1);
    D2 = exprnd(1/lam2,100000,1);
    nb2 = [4 8 16 32 64];
    %%
    i = 1;
    H1 = nan(5,1);
    H2 = nan(5,1);
    M = nan(5,1);
    for n = nb2
        [n2,bc2] = hist(D2,n);
        dbc2 = bc2(2)-bc2(1); % bin widths
        bc1 = dbc2/2:dbc2:(lam2/lam1)*bc2(end);
        bc1 = [bc1 bc1(end)+dbc2];
        n1 = hist(D1,bc1);
        p1 = n1/sum(n1);
        p2 = n2/sum(n2);
        H1(i) = nansum(p1.*log(1./p1));
        H2(i) = nansum(p2.*log(1./p2));
        M(i) = H1(i)-H2(i);
%         Cnt(i) = M(i)/log(n*lam2/lam1);
        i = i+1;     
    end
    %%
    DF(:,c) = log(nb2)'-H1;
end
    
% The entropy of the exponential distribution with n bins is consistently
% .53 nats less than log(n). The maximum entropy in nats of a distribution 
% with n possbilities (n bins) is ln(n). This obtains when all the
% possibilities have equal probabilities. The entropy of the exponential is
% .78 nats less than the maximum so long as the number of bins >=8
%%
nb = [4 8 16 32 64];
i = 1; 
for n = nb
    N = hist(D2,n);
    p = N/sum(N);
    H(i) = nansum(p.*log(1./p));
    i = i+1;
end
%%
figure
plot(nb,H)
hold on
plot(nb,.97*log(nb)-1.3315)
%%
N = [8 16 32 64 128 256 512 1024 2048];
i=1;
R = nan(9,4);
for nb = N   
    bw = 10/nb;
    t=bw/2:bw:10;
    p = exppdf(t,1);
    pn = p/sum(p);
    H =sum(pn.*log(1./pn))
    R(i,:) = [nb H log(nb)-H H/log(nb)];
    i = i+1;
end
R
%%
% So the plug-in entropy of the exponential is 1.3 nats (=1.89 bits) less 
% than the maximum entropy (log(n)) regardless of the number of bins used to
% estimate it, at least for n>=16. This suggests normalizing the mutual
% information by an assumed resolution for the span of the background
% exponetial.
figure
semilogx(R(:,1),R(:,2),R(:,1),log(R(:,1)))

%%
A = Experiment.PstAcqCSMinRatesAndLoci;
Am = A;
Am(Am(:,1)==1,1)=.58;
Am(Am(:,1)==2,1)=1;
Am(Am(:,1)==3,1)=1.58;
Am(Am(:,1)==4,1)=2.32;
%%
[Pm,Sm] = polyfit(D(:,2),D(:,3),1);
[Y,E] = polyval(Pm,[.58 1 1.58 2.32],Sm);
figure;errorbar([.58 1 1.58 2.32],Y,E,E)
hold on
plot(D(:,2),D(:,3),'k*')
plot(xlim,[1 1],'k:')
xlabel('I(CS_o_f_f,\lambda_R) (bits)')
ylabel('CS Rate Minimum')
%%
figure
plot(D(:,2),D(:,4),'*')
hold on
xlabel('I(CS_o_f_f,\lambda_R) (bits)')
ylabel('Locus of Minimum (s)')
errorbar([.58 1 1.58 2.32],PltV(:,7),PltV(:,8),PltV(:,8),'k')
ylim([0 70])
plot(xlim,[40 40],'k:')
%% linear-linear estimation of the intercept for the time-scale invariant
% model
LM = fitlm(2.^D(:,1),D(:,4),'Intercept',false) % linear model with no intercept
% slope = .44+/-.04
%% Time-Scale Invariance or Not in the Depth of Decline
D = Experiment.PstAcqCSMinRatesAndLoci;
% Col 1 of D = log2(d_CS)
% Col 2 = I(CS,lambda_R)
% Col 3 = minima (dept of decline)

figure % exponential decline

subplot(3,1,1) % linear-linear m vs d_CS
    plot(2.^D(:,1),D(:,3),'*') % concave upward, as it must be (!) because
    % it cannot go below 0
    
subplot(3,1,2) % semilogy m vs I(CS,lambda_R)
    plot(D(:,2),log2(D(:,3)),'*') % concave downward. This rules out
    % the time-scale-invariant model in which the decline is exponential
    
subplot(3,1,3) % semilogy m vs d_CS
    plot(2.^D(:,1),log2(D(:,3)),'*') % also concave downward. This rules
    % out the fixed-time-scale model in which the decline is exponential

    % Fitting quandratic models to these data is a waste of time because
    % they are too noisy and the models have too many free parameters (3)
    % for the limited spans of these data. In the second plot, NONE of the
    % coefficients is significant, despite the obvious decline
    
%%
figure % hyperbolic decline (log-log plots)

subplot(2,1,1) % log-log m vs I(CS,lambda_R)
    plot(log(D(:,2)),log(D(:,3)),'*')
    
subplot(2,1,2) % log-log m vs d_CS
    plot((D(:,1)),log(D(:,3)),'*')
    
    % by eyeball little to choose. However, it is of some interest to
    % compute the "terminal" slopes. 'Terminal' is is scare quotes because
    % here it just means slopes determined by last two groups
LV40 =  2.^D(:,1)>20.1 & 2.^D(:,1)<70;
LV80 = 2.^D(:,1)>40.1;

trmslp1 = (mean(log(D(LV80,3)))-mean(log(D(LV40,3))))/(mean(log(D(LV80,2)))-mean(log(D(LV40,2))))
% -1.48+/-.5, too steep, BUT slope of -1 is within .se. of estimate
    LV2 = 2.^D(:,1)>20.1;
    Lm = fitlm(log(D(LV2,2)),log(D(LV2,3)))
    %{
    Linear regression model:
        y ~ 1 + x1

    Estimated Coefficients:
                       Estimate     SE     tStat    pValue
                       ________    ____    _____    ______

        (Intercept)     0.19       0.34     0.56    0.58  
        x1             -1.48       0.50    -2.93    0.01  


    Number of observations: 16, Error degrees of freedom: 14
    Root Mean Squared Error: 0.384
    R-squared: 0.381,  Adjusted R-Squared 0.337
    F-statistic vs. constant model: 8.61, p-value = 0.0109    
    %}
    Lm = fitlm(log(D(~LV2,2)-1.34),log(D(~LV2,3)-1.34)) % initial slope
    %{
    Estimated Coefficients:
                   Estimate     SE     tStat    pValue
                   ________    ____    _____    ______

    (Intercept)    -0.05       0.11    -0.41    0.69  
    x1             -0.07       0.36    -0.21    0.84  


    Number of observations: 11, Error degrees of freedom: 9
    Root Mean Squared Error: 0.304
    R-squared: 0.0048,  Adjusted R-Squared -0.106
    F-statistic vs. constant model: 0.0434, p-value = 0.84
    %}
    % Sooo, initial slope is too shallow to be consistent with k = 1,
    % because two s.e. below the estimate is still only -.79, whereas if k
    % were 1, then the slope btw CSdur 10 and CSdur 20 should be -.93. If k
    % were .2 or smaller, we would be within 2 s.e. of the initial slope.
    % To get down to the actual estimate of .07 requires k of .005, but
    % THAT predicts a slope of only .22 btw 40 & 80. Thus, an estimate of


trmslp2 = (mean(log(D(LV80,3)))-mean(log(D(LV40,3))))/(mean(D(LV80,1))-mean(D(LV40,1)))
% -.56, so not yet close to -1; regression says it's more than 2 s.e
% distant
    Lm = fitlm(D(LV2,1),log(D(LV2,3)))
    %{
    Linear regression model:
    y ~ 1 + x1

    Estimated Coefficients:
                       Estimate     SE     tStat    pValue
                       ________    ____    _____    ______

        (Intercept)     2.51       1.12     2.24    0.04  
        x1             -0.56       0.19    -2.93    0.01  


    Number of observations: 16, Error degrees of freedom: 14
    Root Mean Squared Error: 0.384
    R-squared: 0.381,  Adjusted R-Squared 0.337
    F-statistic vs. constant model: 8.61, p-value = 0.0109
    so estimated slope is more than 2 s.e. shallower than -1. Implies a
    VERY small value of k
    %}
    Lm = fitlm(D(~LV2,1),log(D(~LV2,3))) % initial slope
    %{
    Estimated Coefficients:
                   Estimate     SE     tStat    pValue
                   ________    ____    _____    ______

    (Intercept)     0.12       0.76     0.16    0.87  
    x1             -0.04       0.19    -0.21    0.84  


    Number of observations: 11, Error degrees of freedom: 9
    Root Mean Squared Error: 0.304
    R-squared: 0.0048,  Adjusted R-Squared -0.106
    F-statistic vs. constant model: 0.0434, p-value = 0.84
    %}
    % Sooo, no significant initial slope, which is consistent with VERY
    % small value for k. Because the plausible ranges for the two slope
    % values overlap, there seems little justification for squeezing the
    % estimate from both sides using these slope estimates
    
%% When does ln(1+kx) approximate ln(kx)?
x = 0:1:100;
figure;semilogx(x,log(x),x,log(1+x))
log2(81)-log2(41)
% .98
log2(21)-log2(11)
% .93, so slope is within 10% of 1 when x>10
log2(15)-log2(8)

