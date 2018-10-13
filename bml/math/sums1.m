function v = sums1(v, varargin)
v = bsxfun(@rdivide, v, sums(v, varargin{:}));
