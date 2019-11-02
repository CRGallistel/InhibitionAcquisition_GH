function LocusVsCSdur(D,c1,c5)
% scatterplot of locus of post-acquisition minimum response rate within CS
% versus CS duration on double logarithmic coordinates with best-fit linear
% regression and a priori model lines
figure
[P,S] = polyfit(log10(D(:,c1)),log10(D(:,c5)),1);
[Y,E] = polyval(P,log10([10 20 40 80]),S);
eL = 10.^(Y-E);
eU = 10.^(Y+E);
LM = fitlm(D(:,1),D(:,5),'Intercept',false); % linear regression w 0 intercept
slope = LM.Coefficients.Estimate;
H1 = plot(D(:,1),D(:,5),'*',[0 80],[0 40],'k--',[0 unique(D(:,1))'],...
        slope*[0 unique(D(:,1))'],'k:');
xlim([0 82]);ylim([0 80])
xlabel('CS Duration (s)')
ylabel('Locus of Post-Acq Rate Min (s)')
hold on
H2 = plot(gca,[10 10],[eL(1) eU(1)],'k-.',[20 20],[eL(2) eU(2)],'k-.',...
        [40 40],[eL(3) eU(3)],'k-.',[80 80],[eL(4) eU(4)],'k-.');
legend([H1(1) H1(2) H1(3) H2(1)],'data','0-parameter Model',...
    'Best Scalar Model','Predictive Error','location','NW')
end