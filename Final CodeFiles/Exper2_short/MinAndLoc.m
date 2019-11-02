function O = MinAndLoc(V)
% Returns 2-col array with minimum and locus of minimum in V
[m,l] = min(V);
O = [m l];