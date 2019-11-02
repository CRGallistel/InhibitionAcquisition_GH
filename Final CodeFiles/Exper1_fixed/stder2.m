function se = stder2(v)
se = nanstd(v)./sqrt(sum(~isnan(v)));