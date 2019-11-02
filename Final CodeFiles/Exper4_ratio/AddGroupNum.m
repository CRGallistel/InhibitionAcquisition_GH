function Aout = AddGroupNum(Ain,ID)
Aout = [Ain repmat(ID,length(Ain),1)]; 