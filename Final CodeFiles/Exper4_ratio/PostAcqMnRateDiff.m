function df = PostAcqMnRateDiff(Dfs,AP)
if AP<1500
    df = mean(Dfs(AP:end));
else
    df=nan;
end