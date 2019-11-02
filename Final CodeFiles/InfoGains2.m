function G = InfoGains2(Tb,Tcs,Nb,Ncs,alpha)
% Code for computing the information gain from an excitatory protocol in 4
% different ways

lamCSo = Ncs/Tcs; % observed rate during CS
lamRawo = Nb/Tb; % observed raw rate

Dkl1o = lamCSo/lamRawo;
Dkl2o = log(lamCSo/lamRawo);

Nitib = Nb-Ncs + alpha; % alpha comes from the prior; it prevents the rate
% estimate from ever being 0. Defensible values for alpha are .5 or 1. The
% b at the end of 'Nitib' is for Bayesian

Ncsb = Ncs + alpha; % ditto

Nbb = Nb + alpha; % ditto

lamITIb = Nitib/(Tb-Tcs); % "observed" rate during the ITI (modified by the prior)
lamCSb = Ncsb/Tcs; % "observed" rate during the CS (modified by the prior)
lamRawb = Nbb/Tb; % "observed" raw rate

DklITIb = log(lamITIb/lamRawb) + lamRawb/lamITIb - 1; % The divergence
% OF the raw rate for the background FROM the observed rate. This is the
% cost per interval of encoding the US-US intervals on the ITI clock using
% the raw US rate instead of the corrected background rate
DklCSb = log(lamCSb/lamRawb) + lamRawb/lamCSb - 1; % The divergence OF the
% raw rate from the rate observed during the CS

Ge = Nitib*DklITIb + Ncsb*DklCSb; % the correct calculation, that is, the
% cumulative cost in bits of encoding all the intervals, including the
% ever-expanding single interval on the CS clock, using the raw rate model
% as opposed to the correct model, the model that predicts the actually
% observed CS and ITI rates

Gp = abs(Nitib*log(lamITIb) - Ncsb*log(lamCSb)); % Peter's suggestion that
% we use the absolute value of the difference in entropies rather than the
% Dkl

G = [Ncs*[Dkl1o Dkl2o] Ge Gp];