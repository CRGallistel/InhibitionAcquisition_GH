function PlotsForDeclineModels(D,P)
%%
R = D(:,4); % response variable vector
CSdur = D(:,1); % CS dur predictor vector
Info = D(:,2); % Informativeness predictor vector
MI = D(:,3); % Mutual Information predictor vector
Int = P(:,1); % the vector of intercepts
Slp = P(:,2); % the vector of slopes
LV = false(size(D(:,1)));
LV([1 end]) = true; % flags minimum and maximum values of predictors
ymd = [median(log2(R(1:4))) median(log2(R(5:11))) median(log2(R(12:19))) median(log2(R(20:27)))];
%%
figure
subplot(3,2,1)
    xVals = CSdur(LV);
    yVals = Slp(1)*xVals + Int(1);
    plot(CSdur,log2(R),'*',xVals,yVals,'k')
    xlim([0 85]);ylim([-2.1 1])
    xlabel('CS duration (s)')
    set(gca,'YTick',[-3 -2 -1 0 1],'YTickLabel',{'0.12' '0.25' '0.5' '1' '2'})
subplot(3,2,2)
    xVals = log2(CSdur(LV));
    yVals = Slp(2)*xVals + Int(2);
    plot(log2(CSdur),log2(R),'*',xVals,yVals,'k')
    xlim([3 6.5]);ylim([-2.1 1])
    set(gca,'YTick',[-3 -2 -1 0 1],'YTickLabel',{'0.12' '0.25' '0.5' '1' '2'},...
        'XTick',unique(log2(CSdur)),'XTickLabel',{'10' '20' '40' '80'})
    xlabel('CS duration (s, log scale)')
    hold on
    x = unique(log2(CSdur));
    plot(x,ymd,'k--')
subplot(3,2,3)
    xVals = Info(LV);
    yVals = Slp(3)*xVals + Int(3);
    plot(Info,log2(R),'*',xVals,yVals,'k')
    xlim([1 5.5]);ylim([-2.1 1])
    xlabel('Informativeness (\lambda_I_T_I/\lambda_C)')
    set(gca,'YTick',[-3 -2 -1 0 1],'YTickLabel',{'0.12' '0.25' '0.5' '1' '2'})
    ylabel('Minimum Normalized Rate (log scale)')
subplot(3,2,4)
    xVals = log2(Info(LV));
    yVals = Slp(4)*xVals + Int(4);
    plot(log2(Info),log2(R),'*',xVals,yVals,'k')
    xlim([.5 2.5]);ylim([-2.1 1])
    set(gca,'YTick',[-3 -2 -1 0 1],'YTickLabel',{'0.12' '0.25' '0.5' '1' '2'},...
        'XTick',unique(log2(Info)),'XTickLabel',{'1.5/1' '2/1' '3/1' '4/1'})
    xlabel('Informativeness (log scale)')
    hold on
    x = unique(log2(Info));
    plot(x,ymd,'k--')
subplot(3,2,5)
    xVals = MI(LV);
    yVals = Slp(5)*xVals + Int(5);
    plot(MI,log2(R),'*',xVals,yVals,'k')
    xlim([.5 2.5]);ylim([-2.1 1])
    xlabel('MI = log_2(\lambda_I_T_I/\lambda_C)')
    set(gca,'YTick',[-3 -2 -1 0 1],'YTickLabel',{'0.12' '0.25' '0.5' '1' '2'})
subplot(3,2,6)
    xVals = log2(MI(LV));
    yVals = Slp(6)*xVals + Int(6);
    plot(log2(MI),log2(R),'*',xVals,yVals,'k')
    xlim([-.85 1.3]);ylim([-2.1 1])
    set(gca,'YTick',[-3 -2 -1 0 1],'YTickLabel',{'0.12' '0.25' '0.5' '1' '2'},...
        'XTick',unique(log2(MI)),'XTickLabel',{'.58' '1' '1.58' '2.32'})
    xlabel('log_2[log_2(\lambda_I_T_I/\lambda_C)]')
    hold on
    x = unique(log2(MI));
    plot(x,ymd,'k--')
end
% The slopes over the last 3 medians in the loglog plots (right column,
% dashed lines) are .73, 1.11 and 1.20 from top to bottom

