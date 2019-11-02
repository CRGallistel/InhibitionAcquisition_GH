function [M,SE] = ProfMean(A)
% A is 2-col array with deciles repeated in 2nd col
Ar = reshape(A(:,1),10,[]);
M = mean(Ar,2);
SE = std(Ar,0,2)/sqrt(size(Ar,2));