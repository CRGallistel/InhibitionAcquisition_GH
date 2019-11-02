function AM = AcqMediansExper4(D1,D2,D3,D4,D5)
AM(:,1) = [1;2;3;4;5]; % Group ID #s
AM(:,2) = nanmedian([D1 D2 [D3;NaN] D4 D5])';