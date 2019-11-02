function [M,SE] = ProfMean(A)
% A is 2-col array with deciles repeated in 2nd colin
A(A(:,1)==0,:)=[]; % deleting 11th bins (always 0)
Ar = reshape(A(:,1),10,[]);
M = mean(Ar,2);
SE = std(Ar,0,2)/sqrt(size(Ar,2));