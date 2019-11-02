function ptbl = GroupBySesANOVA(A,mdl,nst,rnd,vars)
p = anovan(A(:,1),{(A(:,2)) (A(:,3)) (A(:,4))},'model',mdl,...
    'nested',nst,'random',rnd,'varnames',vars) 
% Building character array output
if p(1)<.001
    Pca{1} = 'Session p<.001';
else
    Pca{1} = ['Session p=' num2str(p(1),3)];
end

if p(2)<.001
    Pca{2} = 'Subject(Group) p<.001';
else
    Pca{2} = ['Subject(Group) p=' num2str(p(3),3)];
end

if p(3)<.001
    Pca{3} = 'Group p<.001';
else
    Pca{3} = ['Group p=' num2str(p(3),3)];
end

if p(5)<.001
    Pca{4} = 'SessionxGroup p<.001';
else
    Pca{4} = ['SessionxGroup p=' num2str(p(5),3)];
end
ptbl = char(Pca)