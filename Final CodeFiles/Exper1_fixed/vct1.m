function Aout = vct1(A1,A2,A3,A4,G1,G2,G3,G4,ns)
% Deleting supernumerary sessions
A1(:,ns+1:end)=[];
A2(:,ns+1:end) =[];
A3(:,ns+1:end) =[]; 
A4(:,ns+1:end) =[]; 

% Building array
Aout = [reshape(A1',[],1);reshape(A2',[],1);reshape(A3',[],1);reshape(A4',[],1)];
% the data column
Aout(:,2) = repmat((1:ns)',32,1); % column for session # (32 = # subjects)
Aout(:,3) = [reshape(repmat(G1,ns,1),[],1);reshape(repmat(G2,ns,1),[],1);...
    reshape(repmat(G3,ns,1),[],1);reshape(repmat(G4,ns,1),[],1)]; % sub IDs
Aout(:,4) = [ones(8*ns,1);2*ones(8*ns,1);3*ones(8*ns,1);4*ones(8*ns,1)];
% group IDs