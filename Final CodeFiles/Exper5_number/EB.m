function EB(m,se,Ax,Nms)
errorbar(Ax,1:10,m,se,se)
xlim([0 10.5])
set(Ax,'XTick',[1 5 10],'XTickLabel',Nms)