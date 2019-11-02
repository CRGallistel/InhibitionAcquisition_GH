function ptbl = GroupBySesANOVA5(A,mdl,nst,rnd,vars)
p = anovan(A(:,1),{(A(:,2)) (A(:,3)) (A(:,4)) (A(:,5))},...
    'model',mdl,'nested',nst,'random',rnd,'varnames',vars) 
%
if p(1)<.001
    Pca{1} = 'Session p<.001';
else
    Pca{1} = ['Session p=' num2str(p(1),3)];
end
if p(2)<.001
    Pca{2} = 'Subject(Group) p<.001';
else
    Pca{2} = ['Subject(Group) p=' num2str(p(2),3)];
end
if p(3)<.001
    Pca{3} = 'ITIdur p<.001';
else
    Pca{3} = ['ITIdur p=' num2str(p(3),3)];
end
if p(4)<.001
    Pca{4} = 'CSdur p<.001';
else
    Pca{4} = ['CSdur p=' num2str(p(4),3)];
end
if p(6)<.001
    Pca{5} = 'SessionxITIdur p<.001';
else
    Pca{5} = ['SessionxITIdur p=' num2str(p(6),3)];
end
if p(7)<.001
    Pca{6} = 'SessionxCSdur p<.001';
else
    Pca{6} = ['SessionxCSdur p=' num2str(p(7),3)];
end
if p(8)<.001
    Pca{7} = 'ITIdurxCSdur p<.001';
else
    Pca{7} = ['ITIdurxCSdur p=' num2str(p(8),3)];
end
ptbl = char(Pca) 