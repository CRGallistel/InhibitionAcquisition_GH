function Mn = PkRateMeans(A)
Mn = zeros(121,2);
for r = 1:121
    LV = A(:,2)==r;
    n = sum(LV);
    Mn(r,:) = [sum(A(LV,1))/n n]; % means and n's on which they are based
end
return
%% Code to determine maximum numbers of 1s intervals in the different groups
% Need to know this to make field concatenable
MxG10 = 0;
for S=Experiment.GrpCS10
    for s = 1:Experiment.Subject(S).NumSessions
        mx = max(Experiment.Subject(S).Session(s).PkRatePerITISubInt(:,2));
        if mx>MxG10
            MxG10 = mx;
        end
    end
end
MxG10
% MxG10 =91.00

MxG40 = 0;
for S=Experiment.GrpCS40
    for s = 1:Experiment.Subject(S).NumSessions
        mx = max(Experiment.Subject(S).Session(s).PkRatePerITISubInt(:,2));
        if mx>MxG40
            MxG40 = mx;
        end
    end
end
MxG40
% MxG40 =91.00

MxG10_30 = 0;
for S=Experiment.GrpCS10_30
    for s = 1:Experiment.Subject(S).NumSessions
        mx = max(Experiment.Subject(S).Session(s).PkRatePerITISubInt(:,2));
        if mx>MxG10_30
            MxG10_30 = mx;
        end
    end
end
MxG10_30
% MxG10_30 =121.00

MxG10X4 = 0;
for S=Experiment.GrpCS10X4
    for s = 1:Experiment.Subject(S).NumSessions
        mx = max(Experiment.Subject(S).Session(s).PkRatePerITISubInt(:,2));
        if mx>MxG10X4
            MxG10X4 = mx;
        end
    end
end
MxG10X4
% MxG10X4 =91.00

