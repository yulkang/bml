function v = sums1(v, varargin)
% v = sums1(v, [dim=all]) = v ./ sums(v, [dim=all])

v = bsxfun(@rdivide, v, sums(v, varargin{:}));
