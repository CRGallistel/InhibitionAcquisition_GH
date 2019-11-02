function AM = AcqMedians(D1,D2,D3,D4)
AM(:,1) = [1;2;3;4]; % Group ID #s
AM(:,2) = median([D1 D2 D3 D4])';
AM(AM(:,2)==1500,2) = nan; % median = 1500 is impossible. This arises
% because we initialized estimated acquisition points to 1500 for graphic
% reasons (so that failures to acquire were evident in cumulative
% distributions of acquisition points)
%{
Group IDs
1 =CS30fix
2 = CS30var
3 = CS50fix
4 = CS50var
%}