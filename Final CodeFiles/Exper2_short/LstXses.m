function O = LstXses(D,ns)
Da=D;
LVt1 = Da(:,3)<2; % flags 1st ITI in each session, because these did not have
% the intitial 30s
Da(LVt1,:)=[]; % deleting those initial ITIs
%
LVs = Da(:,4)>(35-ns); % flags sessions
LV30 = Da(:,2)<32; % flags 1st 31 s of the ITIs
A = reshape(Da(LVs&LV30,1),[],31);
O = mean(A);
end