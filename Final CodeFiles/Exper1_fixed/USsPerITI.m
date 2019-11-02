function O = USsPerITI(drs,USs)
USsPerSec = sum(USs)/sum(drs);
O = mean(drs)*USsPerSec;