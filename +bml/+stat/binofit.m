function [est, ci] = binofit(n1, n, alpha)
% [est, ci] = binofit(n1, n, alpha=0.95)
%
% Works for any non-negative, non-integer n1 and n.
if ~exist('alpha', 'var')
    alpha = 0.95;
end
est = n1 ./ n;

a = n - n1 + 1;
b = n1 + 1;

ci(:,1) = betainv((1 - alpha) / 2, a(:), b(:));
ci(:,2) = betainv(1 - (1 - alpha) / 2, a(:), b(:));