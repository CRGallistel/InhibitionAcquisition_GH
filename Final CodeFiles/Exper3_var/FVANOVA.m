function ptbl = FVANOVA(A,mdl,nst,rnd,vars)
p = anovan(A(:,1),{(A(:,2)) (A(:,3)) (A(:,4))},'model',...
    mdl,'nested',nst,'random',rnd,'varnames',vars); 
if p(1)<.001
    Pca{1} = 'Subject p<.001';
else
    Pca{1} = ['Subject p=' num2str(p(1),3)];
end
if p(2)<.001
    Pca{2} = 'Decile) p<.001';
else
    Pca{2} = ['Decile p=' num2str(p(2),3)];
end
if p(3)<.001
    Pca{3} = 'FixVar p<.001';
else
    Pca{3} = ['FixVar p=' num2str(p(3),3)];
end
if p(5)<.001
    Pca{4} = 'Decile*FixVar p<.001';
else
    Pca{4} = ['Decile*FixVar p=' num2str(p(5),3)];
end

ptbl = char(Pca) 