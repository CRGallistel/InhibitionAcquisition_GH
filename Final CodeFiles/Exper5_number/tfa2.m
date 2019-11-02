function P2 = tfa2(V1,V2,V3,V4)
A = [[V1;V2] [V3;V4]]; % 2-col array
P2=anova2(A,length(V1)) % the 2nd arguments specifies the n per cell
% the Row factor is the factor that varies between the first and second
% input vectors, which is CS duration; the Column factor is what varies
% between V1V2 and V3V4, which is the ITI duration
