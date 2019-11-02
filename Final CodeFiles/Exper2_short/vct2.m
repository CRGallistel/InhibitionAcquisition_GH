function Aout = vct2(A1,A2,A3,A4,G1,G2,G3,G4,ns)
% Deleting supernumerary sessions
A1(:,ns+1:end)=[];
A2(:,ns+1:end) =[];
A3(:,ns+1:end) =[]; 
A4(:,ns+1:end) =[]; 

% Building array
Aout = [reshape(A1',[],1);reshape(A2',[],1);reshape(A3',[],1);reshape(A4',[],1)];
% the data column
sesnums = (1:ns)';
Aout(:,2) = [repmat(sesnums,numel(G1),1);repmat(sesnums,numel(G2),1);...
    repmat(sesnums,numel(G3),1);repmat(sesnums,numel(G4),1)]; % column for
% session number
Aout(:,3) = [reshape(repmat(G1,ns,1),[],1);reshape(repmat(G2,ns,1),[],1);...
    reshape(repmat(G3,ns,1),[],1);reshape(repmat(G4,ns,1),[],1)]; % sub IDs
Aout(:,4) = [ones(numel(G1)*ns,1);2*ones(numel(G2)*ns,1);...
    3*ones(numel(G3)*ns,1);4*ones(numel(G4)*ns,1)];
% group IDs