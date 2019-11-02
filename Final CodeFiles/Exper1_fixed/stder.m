function se = stder(v)
se = NaN;
if nanstd(v) > 0
    se = nanstd(v)/sqrt(sum(~isnan(v)));
end   