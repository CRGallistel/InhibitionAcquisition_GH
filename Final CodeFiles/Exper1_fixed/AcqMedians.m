function AM = AcqMedians(D1,D2,D3,D4,D5)
AM(:,1) = [10;20;40;80;nan]; % CS durations; the 5th groups had random CS
% durations
AM(:,2) = median([D1 D2 D3 D4 D5])';
AM(AM(:,2)==1500,2) = nan; % median = 1500, which is impossible. This arises
% because we initialized estimated acquisition points to 1500 for graphic
% reasons (so that failures to acquire were evident in cumulative
% distributions of acquisition points)