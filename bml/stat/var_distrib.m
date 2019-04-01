function [v, m] = var_distrib(varargin)
% [v, m] = var_distrib(p, v, d)
%
% See also: std_distrib, mean_distrib
[s, m] = std_distrib(varargin{:});
v = s .^ 2;