function Aout = vct3(A1,A2,A3,A4,ns)
% vertically concatenates the arrays for the 4 groups and eliminates the
% "supernumerary" sessions, so that all groups have the same number of
% sessions; ns = # of sessions to be entered into the ANOVA

% Deleting supernumerary sessions
A1(:,ns+1:end)=[];
A2(:,ns+1:end) =[];
A3(:,ns+1:end) =[]; 
A4(:,ns+1:end) =[]; 

% Building array
Aout = [reshape(A1',[],1);reshape(A2',[],1);reshape(A3',[],1);reshape(A4',[],1)];
% the data column

N = 4*8; % number of subjects
sesnums = (1:ns)'; % sequence of ns sessions for one subject
Aout(:,2) = repmat(sesnums,N,1); % column for session numbers
subnums = 1:32; % different # for each subject

Aout(:,3) = reshape(repmat(subnums,ns,1),[],1); % column for subjects
Aout(:,4) = [ones(16*ns,1);2*ones(16*ns,1)];% CS dur (Col 4)
Aout(:,5) = repmat([ones(8*ns,1);2*ones(8*ns,1)],2,1); % Fixed vs Variable
% CS duration (Col 5)