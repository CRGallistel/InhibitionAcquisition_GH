function AM = AcqMedians(D1,D2,D3,D4)
AM(:,1) = [2030;2060;8030;8060]; % exprimental groups
AM(:,2) = median([D1 D2 D3 D4])';
AM(AM(:,2)==1500,2) = nan; % median = 1500, which is impossible. This arises
% because we initialized estimated acquisition points to 1500 for graphic
% reasons (so that failures to acquire were evident in cumulative
% distributions of acquisition points).