function Aout = AddGrpAndFVNums(Ain,ID)
% ID is 2-element vector: 1st element is CS dur (1= 30, 2=50); 2nd
    % element is fixed or variable, (1 or 2, respectively)
Aout = [Ain repmat(ID,length(Ain),1)]; 