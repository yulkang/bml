function y = mdl_pred(mdl, vars, to_excl)
% y = mdl_pred(mdl, vars, to_excl)
%
% y = X(:,vars) * coef;
%
% vars: cell array of variable names to include
% to_excl: exclude VARS if true. Defaults to false.

% 2016 (c) Yul Kang. hk2699 at columbia dot edu.

if nargin < 3
    to_excl = false;
end
if nargin < 2
    vars = mdl.VariableNames(mdl.VariableInfo.InModel);
end
if to_excl
    vars = setdiff(mdl.VariableNames, vars, 'stable');
end
incl = ismember(mdl.VariableNames, vars) & mdl.VariableInfo.InModel;
X = table2array(mdl.Variables);
X = X(:, incl);

incl_wi_inModel = strcmpfinds(vars, mdl.PredictorNames);
incl_wi_inModel = incl_wi_inModel(~isnan(incl_wi_inModel));

n_tr = size(X, 1);
X = [ones(n_tr, 1), X];

coef = mdl.Coefficients.Estimate([1; (incl_wi_inModel(:) + 1)]);
y = X * coef;
end