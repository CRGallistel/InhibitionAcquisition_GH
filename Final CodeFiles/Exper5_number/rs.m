function O = rs(cv,cols)  
O = reshape(cv,cols,[]); % converts column vector to 11-col array
O(end,:)= []; % deleting terminal 0 (11th column)
O=O';