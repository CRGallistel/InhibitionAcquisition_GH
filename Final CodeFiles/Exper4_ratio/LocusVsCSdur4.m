function LocusVsCSdur4(D,c1,c5)
% scatterplot of locus of post-acquisition minimum response rate within CS
% versus CS duration on linear coordinates, with the 0-parameter model
% Rows 1:8 and 25:31 have CS duration 20s and Informativeness 2; Rows 9:24
% have CS duration 40 and Informativeness 3; Rows 32:39 have CS duration
% 80 and Informativeness 5
plot(D(:,1)-1,D(:,5),'k*')
