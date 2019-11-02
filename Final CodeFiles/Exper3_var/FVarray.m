function A = FVarray(Af,Av)
%Creates long-table array to be fed to ANOVA
Af(:,3) = repmat((1:10)',numel(unique(Af(:,2))),1); % deciles column
Af(:,4) = ones(length(Af),1); % fix-variable column

Av(:,3) = repmat((1:10)',numel(unique(Av(:,2))),1); % deciles column
Av(:,4) = 2*ones(length(Av),1); % fix-variable column

A = [Af;Av];
end