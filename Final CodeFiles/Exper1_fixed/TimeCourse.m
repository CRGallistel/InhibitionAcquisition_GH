function NR = TimeCourse(PkTms,AcqPt)
% Computes normalized poke rate during CS for successive 2.5s segments of
% the CS. The poke rates are normalized by the pre-acquisition mean

if AcqPt<1500 % acquisition occurred
    PreAcq=mean(Pktms