function Aout = AddCSandITIdurs(Ain,Sids,rv)
% Ain has row for each subject and column for each session. However, there
% are only 18 sessions for some subjects
Ain(:,19:end) = []; % getting rid of sessions after 18
Aout = reshape(Ain,[],1); % col vec w mean poke rates
Aout(:,2) = repmat((1:18)',length(Sids),1); % col for session
Aout(:,3) = reshape(repmat(Sids,18,1),[],1); % col for Subject
% 1st element of rv indicates ITI dur (1=20, 2=80); 2nd element indicates
% CS dur (1=30, 2=60)
Aout = [Aout repmat(rv,length(Aout),1)];
end