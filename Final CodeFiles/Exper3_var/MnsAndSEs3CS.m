function [Mns,SEs] = MnsAndSEs3CS(A)
%%
LV1 = (A(:,4)==1)&(A(:,5)==1); % flags membership in Group 1
LV2 = (A(:,4)==1)&(A(:,5)==2);  % flags membership in Group 2
LV3 = (A(:,4)==2)&(A(:,5)==1);  % flags membership in Group 3
LV4 = (A(:,4)==2)&(A(:,5)==2);  % flags membership in Group 4

%% 
tmp1 = reshape(A(LV1,1),[],8);
Mns(:,1) = mean(tmp1,2);
SEs(:,1) = std(tmp1,0,2)/sqrt(8);
%
tmp2 = reshape(A(LV2,1),[],8);
Mns(:,2) = mean(tmp2,2);
SEs(:,2) = std(tmp2,0,2)/sqrt(8);
%
tmp3 = reshape(A(LV3,1),[],8);
Mns(:,3) = mean(tmp3,2);
SEs(:,3) = std(tmp3,0,2)/sqrt(8);

tmp4 = reshape(A(LV4,1),[],8);
Mns(:,4) = mean(tmp4,2);
SEs(:,4) = std(tmp4,0,2)/sqrt(8);

figure
h=plot(1:length(Mns),Mns);
legend('30fix','30var','50fix','50var','location','SW')
xlabel('Session','FontSize',18)
ylabel('Mean Pokes/s During CS','FontSize',18)
set(h,'Color','k')
set(h(1),'LineStyle','-')
set(h(2),'LineStyle','--')
set(h(3),'LineStyle','-.')
set(h(4),'LineStyle','-')
set(h(1),'Marker','o')
set(h(2),'Marker','^')
set(h(3),'Marker','v')
set(h(4),'Marker','*')
