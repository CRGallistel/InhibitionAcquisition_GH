function Aout = vct6(Gn8c80i80,Gn32c80i20,Gn32c160i20,Gn64c80i10,G1,G2,G3,G4,bd,ns )

Gn64c80i10(:,bd) = []; % removing bad data column from 4th group, which
% reduces # sessions in this group to 20

% reducing # sessions in other 3 groups to 20
Gn8c80i80(:,ns+1:end) =[];
Gn32c80i20(:,ns+1:end) =[]; 
Gn32c160i20(:,ns+1:end) =[]; 

% building array
Aout = [reshape(Gn8c80i80,[],1);reshape(Gn32c80i20,[],1);...
    reshape(Gn32c160i20,[],1);reshape(Gn64c80i10,[],1)]; % data column
Aout(:,2) = repmat((1:20)',8*4,1); % column for session #
Aout(:,3) = [reshape(repmat(G1,20,1),[],1);reshape(repmat(G2,20,1),[],1);...
    reshape(repmat(G3,20,1),[],1);reshape(repmat(G4,20,1),[],1)]; % sub IDs
Aout(:,4) = [ones(8*20,1);2*ones(8*20,1);3*ones(8*20,1);4*ones(8*20,1)];
% group IDs
% NB cannot do interactions because factors only partially crossed