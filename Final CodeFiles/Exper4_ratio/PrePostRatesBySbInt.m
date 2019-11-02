function [Pre,Post,Nrmd]=PrePostRatesBySbInt(RateArray,AcqPt)
if AcqPt < 1500
    Pre = mean(RateArray(1:AcqPt-1,:));
    Post = mean(RateArray(AcqPt:end,:));
    Nrmd = Post./Pre;
else % did not aquire
    Pre = mean(RateArray);
    Post = [];
    Nrmd = [];
end
    