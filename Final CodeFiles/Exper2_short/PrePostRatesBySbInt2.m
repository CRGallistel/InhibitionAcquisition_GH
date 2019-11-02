function [Pre,Post,Nrmd]=PrePostRatesBySbInt2(RateArray,AcqPt)
if AcqPt < 1500
    Pre = mean(RateArray(1:AcqPt-1,:)); % a vector
    Post = mean(RateArray(AcqPt:end,:)); % a vector
    Nrmd = Post./Pre; % a vector
else % did not aquire
    Pre = mean(RateArray);
    Post = [];
    Nrmd = [];
end