function Ind=anovanIndices(D,G1,G2,G3,G4,Gr)
%%
Ind{1} = D(:,2); % vector identifying subject from which each diff came

LV1 = ismember(D(:,2),G1); % flags members of Grp10s
LV2 = ismember(D(:,2),G2); % flags members of Grp20s
LV3 = ismember(D(:,2),G3); % flags members of Grp40s
LV4 = ismember(D(:,2),G4); % flags members of Grp80s
LVr = ismember(D(:,2),Gr);% flags members of GrpRnd
%
Ind{2} = 1*LV1; % Vector identifying the group membership of the subject
Ind{2} = Ind{2}+2*LV2;
Ind{2} = Ind{2}+3*LV3;
Ind{2} = Ind{2}+4*LV4;
Ind{2} = Ind{2}+5*LVr;
%
Ind{3} = []; % vector identifying the trial #
for S=1:length([G1 G2 G3 G4 Gr]) % stepping through the subjects
    LVs = D(:,2)==S; % flags trials from a given subject
    Ind{3} = [Ind{3};(1:sum(LVs))'];
end
%%
D = [D Ind{2} Ind{3}]; % 1st col = CS_ITI diffs; 2nd col = Sub Indx; 3rd col
% = Grp membership; 4th col = Trial #
%%
G1 = Experiment.Grp10s;
G2 = Experiment.Grp20s;
G3 = Experiment.Grp40s;
G4 = Experiment.Grp80s;
Gr = Experiment.GrpRnd;
%%
A1 = nan(length(G1),1120);
A2 = nan(length(G2),1120);
A3 = nan(length(G3),1120);
A4 = nan(length(G4),1120);
A5 = nan(length(Gr),1120);

r1 = 1;
r2 = 1;
r3 = 1;
r4 = 1;
r5 = 1;
for S=1:40
    if ismember(S,G1)
        LV = D(:,2)==S; % flags data from this subject
        A1(r1,1:sum(LV)) = D(LV,1)';
        r1=r1+1;
    end
    
    if ismember(S,G2)
        LV = D(:,2)==S; % flags data from this subject
        A2(r2,1:sum(LV)) = D(LV,1)';
        r2=r2+1;
    end
    
    if ismember(S,G3)
       LV = D(:,2)==S;
       A3(r3,1:sum(LV)) = D(LV,1)';
       r3=r3+1; 
    end
    
    if ismember(S,G4)
        LV = D(:,2)==S; % flags data from this subject
        A4(r4,1:sum(LV)) = D(LV,1)';
        r4=r4+1;
    end
    
    if ismember(S,Gr)
        LV = D(:,2)==S; % flags data from this subject
        A5(r5,1:sum(LV)) = D(LV,1)';
        r5 =r5+1;
    end
end % of building the arrays
%% Means ov 20-trial blocks
b = 1;
e = 20;
r = 1;
mn5 = nanmean(A5);
mrb=nan(55,1);
m1b=nan(55,1);
m2b=nan(55,1);
m3b=nan(55,1);
m4b=nan(55,1);
for r = 1:55
    mrb(r,1) = mean(mn5(b:e));
    m1b(r,1) = mean(mn1(b:e));
    m2b(r,1) = mean(mn2(b:e));
    m3b(r,1) = mean(mn3(b:e));
    m4b(r,1) = mean(mn4(b:e));
    b = b+20;
    e = e+20;
    r = r+1;
end

%%
figure

subplot(3,1,1) % in 20-trial blocks
    H=plot(1:55,mrb,'k--',1:55,m1b,'k',1:55,m2b,'b',1:55,m3b,'g',1:55,m4b,'r');
    legend('RndMxd','ITI10','ITI20','IIT40','ITI80','location','SW')
    set(gca,'FontSize',18)
    set(gca,'XTick',[1 10 20 30 40 50],'XTickLabel',...
        {'1:20' '180:200' '380:400' '580:600' '780:800' '980:1000'})
    ylabel({'Mean CS-ITI Rate Diff'; '(20-Trial Block)'})
    text(1,.05,'(a)','FontSize',24)
    
subplot(3,1,2)
    mn1 = nanmean(A1);
    sg1 = nanstd(A1);
    n1 = sum(~isnan(A1));
    se1 = sg1./sqrt(n1);
    %
    UL1 = mn1+se1;
    LL1 = mn1-se1;
    Trls = [1:1120 1120:-1:1];
    Y1 = [UL1 fliplr(LL1)];

    H = patch(Trls,Y1,[.3 .3 .3]);
    set(H,'EdgeColor',[1 1 1],'FaceAlpha',.5)
    hold on
    %
    mn2 = nanmean(A2);
    sg2 = nanstd(A2);
    n2 = sum(~isnan(A2));
    se2 = sg2./sqrt(n2);
    %
    UL2 = mn2+se2;
    LL2 = mn2-se2;
    Trls = [1:1120 1120:-1:1];
    Y2 = [UL2 fliplr(LL2)];
    H = patch(Trls,Y2,[0 0 .7]);
    set(H,'EdgeColor',[1 1 1],'FaceAlpha',.5)
    %
    mn3 = nanmean(A3);
    sg3 = nanstd(A3);
    n3 = sum(~isnan(A3));
    se3 = sg3./sqrt(n3);
    %
    UL3 = mn3+se3;
    LL3 = mn3-se3;
    Trls = [1:1120 1120:-1:1];
    Y3 = [UL3 fliplr(LL3)];
    H = patch(Trls,Y3,[0 .7 0]);
    set(H,'EdgeColor',[1 1 1],'FaceAlpha',.5)
    
    mn4 = nanmean(A4);
    sg4 = nanstd(A4);
    n4 = sum(~isnan(A4));
    se4 = sg4./sqrt(n4);
    %
    UL4 = mn4+se4;
    LL4 = mn4-se4;
    Trls = [1:1120 1120:-1:1];
    Y4 = [UL4 fliplr(LL4)];
    H = patch(Trls,Y4,[.7 0 0]);
    set(H,'EdgeColor',[1 1 1],'FaceAlpha',.5)
    set(gca,'FontSize',18)
    xlim([100 200])
    text(101,.25,'(b)','FontSize',24)
    

subplot(3,1,3)
    mn1 = nanmean(A1);
    sg1 = nanstd(A1);
    n1 = sum(~isnan(A1));
    se1 = sg1./sqrt(n1);
    %
    UL1 = mn1+se1;
    LL1 = mn1-se1;
    Trls = [1:1120 1120:-1:1];
    Y1 = [UL1 fliplr(LL1)];

    H = patch(Trls,Y1,[.3 .3 .3]);
    set(H,'EdgeColor',[1 1 1],'FaceAlpha',.5)
    hold on
    %
    mn2 = nanmean(A2);
    sg2 = nanstd(A2);
    n2 = sum(~isnan(A2));
    se2 = sg2./sqrt(n2);
    %
    UL2 = mn2+se2;
    LL2 = mn2-se2;
    Trls = [1:1120 1120:-1:1];
    Y2 = [UL2 fliplr(LL2)];
    H = patch(Trls,Y2,[0 0 .7]);
    set(H,'EdgeColor',[1 1 1],'FaceAlpha',.5)
    %
    mn3 = nanmean(A3);
    sg3 = nanstd(A3);
    n3 = sum(~isnan(A3));
    se3 = sg3./sqrt(n3);
    %
    UL3 = mn3+se3;
    LL3 = mn3-se3;
    Trls = [1:1120 1120:-1:1];
    Y3 = [UL3 fliplr(LL3)];
    H = patch(Trls,Y3,[0 .7 0]);
    set(H,'EdgeColor',[1 1 1],'FaceAlpha',.5)
    
    mn4 = nanmean(A4);
    sg4 = nanstd(A4);
    n4 = sum(~isnan(A4));
    se4 = sg4./sqrt(n4);
    %
    UL4 = mn4+se4;
    LL4 = mn4-se4;
    Trls = [1:1120 1120:-1:1];
    Y4 = [UL4 fliplr(LL4)];
    H = patch(Trls,Y4,[.7 0 0]);
    set(H,'EdgeColor',[1 1 1],'FaceAlpha',.5)
    set(gca,'FontSize',18)
    xlim([1050 1100])
    xlabel('Trial')
    ylabel('Mean CS-ITI Rate Diff +/-se')
    legend('ITI10','ITI20','IIT40','ITI80','location','N')
    text(1051,.4,'(c)','FontSize',24)
%%    
    
        
        
        
        
        
        
    H=plot(1:1120,mn1,'k',1:1120,mn2,'b',1:1120,mn3,'g',1:1120,mn4,'r');
    

