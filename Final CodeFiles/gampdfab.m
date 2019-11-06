function pd = gampdfab(lambda,alpha,beta)
% the gamma function parameterized in terms of shape and inverse scale, the
% parameterization used when it is the conjugate prior for the exponential.
% lambda is a vector of possible values for the rate parameter of the
% exponential; alpha is the number of events; beta is the sum of the
% interevent intervals
% syntax   lgpd = alpha*log(beta) - gammaln(alpha) + (alpha-1)*log(lambda) -lambda*beta;
lgpd = alpha*log(beta) - gammaln(alpha) + (alpha-1)*log(lambda) -lambda*beta;
% computation done with logs to avoid overflows from gamma function
pd = exp(lgpd);