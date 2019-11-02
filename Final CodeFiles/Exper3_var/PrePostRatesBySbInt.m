function [Pre,Post,Nrmd,NrmdL]=PrePostRatesBySbInt(RateArray,Lst1s,AcqPt)
if AcqPt < 1500
    Pre = mean(RateArray(1:AcqPt-1,:)); % a vector
    Post = mean(RateArray(AcqPt:end,:)); % a vector
    Nrmd = Post./Pre; % a vector
    NrmL = mean(Lst1s(AcqPt:end)); % mean response rate during the last 1
    % s of the ITIs after acquisition (a scalar)
    NrmdL = Post/NrmL; % a vector
else % did not aquire
    Pre = mean(RateArray);
    Post = [];
    Nrmd = [];
    NrmdL =[];
end   