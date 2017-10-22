function y = y_for_ch(X, ch, beta)
% y supporting choice
% y = y_for_ch(X, ch, beta=1)
%
% X(tr, param)
% beta(param, 1)
% ch(tr,1): 0 or 1 or logical
%
% y(tr, 1)
%
% The sign of y is flipped if ch == 0 for the corresponding trial
if nargin < 3
    beta = 1;
end
beta = beta(:);

assert(all((ch == 0) | (ch == 1)));
if ~isscalar(beta) && (size(X, 2) < length(beta))
    X = [ones(size(X, 1), 1), X];
end

y = X * beta .* sign(ch - 0.5);
end