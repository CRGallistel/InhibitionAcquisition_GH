function P = LinearFits(D)
% linear fits to possible models in which one or both axes data are logged
% 6-col output; Cols 1 & 2 are the intercept & slope, respectively;
% Cols 3 & 4 are the corresponding s.e.'s; Cols 5 & 6, the corresponding
% p values.     Each row is for a different one of the 6
% models obtained by crossing the three predictor variables (CS duration,
% Informativeness, and Mutual Information) with the two assumed forms for
% the decline function--the exponential and the hyperbolic. The odd rows
% are the exponential models (from semilogy regressions); the even rows are
% the hyperbolic models (from log-log regression)

%% 6 linear models
M1 = fitlm(D(:,1),log2(D(:,4))); % CSdur is predictor; exponential is the model
M2 = fitlm(log2(D(:,1)),log2(D(:,4))); % CSdur is the predictor; hyperbolic is the model
M3 = fitlm(D(:,2),log2(D(:,4))); % Informativeness is predictor; exponential is the model
M4 = fitlm(log2(D(:,2)),log2(D(:,4))); % Informativeness is the predictor; hyperbolic is the model
M5 = fitlm(D(:,3),log2(D(:,4))); % Mutual Information is predictor; exponential is the model
M6 = fitlm(log2(D(:,3)),log2(D(:,4))); % Mutual Information is the predictor; hyperbolic is the model
%% Extracting parameters, their s.e.'s, and p values
P = [M1.Coefficients.Estimate' M1.Coefficients.SE' M1.Coefficients.pValue';...
    M2.Coefficients.Estimate' M2.Coefficients.SE' M2.Coefficients.pValue';...
    M3.Coefficients.Estimate' M3.Coefficients.SE' M3.Coefficients.pValue';...
    M4.Coefficients.Estimate' M4.Coefficients.SE' M4.Coefficients.pValue';...
    M5.Coefficients.Estimate' M5.Coefficients.SE' M5.Coefficients.pValue';...
    M6.Coefficients.Estimate' M6.Coefficients.SE' M6.Coefficients.pValue'];
end

