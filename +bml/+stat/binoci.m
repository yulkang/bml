function ci = binoci(n1, n, alpha)
% ci = binoci(n1, n, alpha)
%
% Curiously, doesn't agree with binofit's second output.
if nargin < 3
    alpha = 0.05;
end
n0 = n - n1;
lb = alpha / 2;
ub = 1 - alpha / 2;
ci = [vVec(betainv(lb, n1 + 1, n0 + 1)), ...
      vVec(betainv(ub, n1 + 1, n0 + 1))];