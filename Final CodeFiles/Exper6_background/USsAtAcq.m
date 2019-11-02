function O = USsAtAcq(USs,ap)
O=[]; % initializing
CmUSs = cumsum(USs);
if ap<length(USs) % subject acquired
    O = CmUSs(ap);
end