function A = Arrange4(D1,D2,D3,D4,D5,CSdurs,Inf,MI)
% Arranges the four group data in a single 5-col array: First 3 cols are
% the possible predictors (CSdur, Informativeness, Mutual Information).
% Last 2 are the response measures (locus of minimum rsp rate during CS,
% minimum normalized response rate at that locus)

G2020 = [repmat([CSdurs(1) Inf(1) MI(1)],length(D1),1) D1]; % the repmat does
% the 3 predictors; the last term in the horizontal concatenation (D1)
% gives the "response" variables (minimum & locus(minimum))
G2040 = [repmat([CSdurs(2) Inf(2) MI(2)],length(D2),1) D2];
G4020 = [repmat([CSdurs(3) Inf(3) MI(3)],length(D3),1) D3];
G4040 = [repmat([CSdurs(4) Inf(4) MI(4)],length(D4),1) D4];
G4080 = [repmat([CSdurs(5) Inf(5) MI(5)],length(D5),1) D5];
A = [G2020;G2040;G4020;G4040;G4080];
end