function lAM_C = ContextRate(N_C,tsd)
lAM_C = sum(N_C)/tsd(end,1); % last time in TSData gives session duration
end

