function [FtP,PltV] = FitLines(D)
[P1,S1] = polyfit(D(:,1),log(D(:,4)),1); % minima vs log2(CSdur)
[P2,S2] = polyfit(log(D(:,1)),log(D(:,4)),1); % loci of minima vs log2(CSdur)
[P3,S3] = polyfit(D(:,2),log(D(:,4)),1); % minima vs log2(Inf) [= I(CS_off,d_lambR)]
[P4,S4] = polyfit(D(:,2),log(D(:,4)),1); % loci of minima vs vs log2(Inf) = I(CS_off,lambda_R)
[P5,S5] = polyfit(D(:,3),log(D(:,4)),1); % log2(minima) vs I(CS_off,lambda_R)
[P6,S6] = polyfit(log(D(:,3)),log(D(:,4)),1); % log2(loci) vs log2(CSdur)
%
[PV1,E1] = polyval(P1,unique(D(:,1)),S1);
[PV2,E2] = polyval(P2,unique(D(:,1)),S2);
[PV3,E3] = polyval(P3,unique(D(:,2)),S3);
[PV4,E4] = polyval(P4,unique(D(:,2)),S4);
[PV5,E5] = polyval(P5,unique(D(:,3)),S5);
[PV6,E6] = polyval(P6,unique(D(:,3)),S6);

%
FtP = [P1' P2' P3' P4' P5' P6']; % fit parameters: row 1 = slopes; row 2 = 
% intercepts

PltV = [PV1 E1 PV2 E2 PV3 E3 PV4 E4 PV5 E5 PV6 E6]; % values for plotting 
% regression with predictive errors (+/-standard deviation of the
% predictive distribution (NB, NOT s.e. & not confidence limits)
%% Writing regression parameters with standard errors and p values into base
% workspace, where can be copied into script
M1 = char({'';'';'CSdur Exponential Model'});
M2 = char({'';'';'CSdur Hyperbolic Model'});
M3 = char({'';'';'Info Exponential Model'});
M4 = char({'';'';'Info Hyperbolic Model'});
M5 = char({'';'';'MI Exponential Model'});
M6 = char({'';'';'MI Hyperbolic Model'});

evalin('base','disp(M1)')
evalin('base','LM=fitlm(D(:,1),log(D(:,4)))')
evalin('base','disp(M2)')
evalin('base','LM=fitlm(log(D(:,1)),log(D(:,4)))')

evalin('base','disp(M3)')
evalin('base','LM=fitlm(D(:,2),log(D(:,4)))')
evalin('base','disp(M4)')
evalin('base','LM=fitlm(log(D(:,2)),log(D(:,4)))')

evalin('base','disp(M5)')
evalin('base','LM=fitlm(D(:,3),log(D(:,4)))')
evalin('base','disp(M6)')
evalin('base','LM=fitlm(log(D(:,3)),log(D(:,4)))')
end
