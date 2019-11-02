function [Mns,SEs] = MnsAndSEs2CS_10s(A,MinNumSes)
%%
LV = A(:,2)>MinNumSes;
A(LV,:)=[]; % deleting sessions greater than the minimum number
Mns = nan(MinNumSes,3);
%%
LV1 = A(:,4)==1; % flags membership in Group 1
LV3 = A(:,4)==3;  % flags membership in Group 3
LV4 = A(:,4)==4;  % flags membership in Group 4
%%
tmp1 = reshape(A(LV1,1),MinNumSes,8);
Mns(:,1) = mean(tmp1,2);
SEs(:,1) = std(tmp1,0,2)/sqrt(8);
%%
tmp3 = reshape(A(LV3,1),MinNumSes,8);
Mns(:,2) = mean(tmp3,2);
SEs(:,2) = std(tmp3,0,2)/sqrt(8);

tmp4 = reshape(A(LV4,1),MinNumSes,8);
Mns(:,3) = mean(tmp4,2);
SEs(:,3) = std(tmp4,0,2)/sqrt(8);
%%
figure
h=plot(1:MinNumSes,Mns);
legend('10s','10_3_0','10x4','location','NW')
xlabel('Session','FontSize',18)
ylabel('Mean Pokes/s During CS','FontSize',18)
set(h,'Color','k')
set(h(1),'LineStyle','-')
set(h(2),'LineStyle','-.')
set(h(3),'LineStyle',':')

set(h(1),'Marker','o')
set(h(2),'Marker','v')
set(h(3),'Marker','*')
