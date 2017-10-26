function r = coef_disc(yhat, ch)
% Coefficient of discrimination as proposed by Tjur 2009
%
% r = coef_disc(yhat, ch)
%
% yhat: probability of ch == 1, as returned from glmval( ..., 'logit')
% ch: 0 or 1

r = nanmean(yhat(ch == 1)) - nanmean(yhat(ch == 0));