function m = nanwmean(v, w, varargin)
% Weighted nanmean. W is expanded to match v's dimension, and vice versa.
%
% m = nanwmean(v, w, [dim])
%
% See also: reshape2vec, wmean

% 2019 (c) Yul Kang. yul.kang.on at gmail dot com.

[v, w] = rep2match({v, w});
w(isnan(v)) = 0;
v(isnan(v)) = 0;

sum_w = sum(w, varargin{:});
sum_v = sum(bsxfun(@times, v, w), varargin{:});
m     = bsxfun(@rdivide, sum_v, sum_w);