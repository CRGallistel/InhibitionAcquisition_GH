function [Mns,SEs] = MnsAndSEs1cs(A)
%%
% Subject 7 had only 33 sessions; 17, 27 and 37 had only 34; need to fill
% in missing rows with NaNs
r = find(A(:,3)==37,1','last');
A = [A(1:r,:);NaN 35 37 1;A(r+1:end,:)]; % filling in Grp10
%
r = find(A(:,3)==27,1','last');
A = [A(1:r,:);NaN 35 27 2;A(r+1:end,:)]; % filling in Grp20
%
r = find(A(:,3)==17,1','last');
A = [A(1:r,:);NaN 35 17 3;A(r+1:end,:)]; % filling in Grp40
%
r = find(A(:,3)==7,1','last');
A = [A(1:r,:);NaN 34 7 4;NaN 35 7 4;A(r+1:end,:)]; % filling in Grp80


%%
LV10 = A(:,4)==1; % flags membership in Group 1
LV20 = A(:,4)==2;  % flags membership in Group 2
LV40 = A(:,4)==3;  % flags membership in Group 3
LV80 = A(:,4)==4;  % flags membership in Group 4
LVrnd = A(:,4)==5;  % flags membership in Group  5
%% 
tmp1 = reshape(A(LV10,1),35,8);
Mns(:,1) = nanmean(tmp1,2);
SEs(:,1) = nanstd(tmp1,0,2)/sqrt(8);
%
tmp2 = reshape(A(LV20,1),35,8);
Mns(:,2) = nanmean(tmp2,2);
SEs(:,2) = nanstd(tmp2,0,2)/sqrt(8);
%
tmp3 = reshape(A(LV40,1),35,8);
Mns(:,3) = nanmean(tmp3,2);
SEs(:,3) = nanstd(tmp3,0,2)/sqrt(8);

tmp4 = reshape(A(LV80,1),35,8);
Mns(:,4) = nanmean(tmp4,2);
SEs(:,4) = nanstd(tmp4,0,2)/sqrt(8);

tmp5 = reshape(A(LVrnd,1),35,8);
Mns(:,5) = nanmean(tmp5,2);
SEs(:,5) = nanstd(tmp5,0,2)/sqrt(8);

figure
h=plot(1:35,Mns);
legend('10s','20s','40','80s','rnd','location','SW')
xlabel('Session','FontSize',18)
ylabel('Mean Pokes/s During CS','FontSize',18)
set(h,'Color','k')
set(h(1),'LineStyle','-')
set(h(2),'LineStyle','--')
set(h(3),'LineStyle','-.')
set(h(4),'LineStyle','-')
set(h(5),'LineStyle','-.')
set(h(1),'Marker','o')
set(h(2),'Marker','^')
set(h(3),'Marker','v')
set(h(4),'Marker','*')
set(h(5),'Marker','*')


