function yhat = glmval_lapse_asym(b, X0)
% glmval for the logistic model with a lapse term.
% b(1) : offset
% b(1 + (1:size(X0,2))): beta
% b([end-1, end]) : [logit(p_lapse0), logit(p_lapse1)]
%
% yhat : probability

% 2016 Yul Kang. hk2699 at columbia dot edu.

% bias = b(1);
offset = b(1);
beta = b(2:(end-2));
lapse = invLogit(b(end + [-1, 0]));

% y0 = invLogit((X0 - bias) * beta);
y0 = invLogit(X0 * beta(:) + offset);
yhat = y0 * (1 - sum(lapse)) + 0.5 * lapse(1);

