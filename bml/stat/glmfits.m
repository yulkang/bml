function S = glmfits(x, yAll, varargin)
% S = glmfits(x, yAll, varargin)
%
% yAll: one y per column.
% S: an array of output struct from glmwrap. Contains b, dev, stats, p, se.
%
% See also: glmfit

% 2015 (c) Yul Kang. hk2699 at columbia dot edu.

S = arrayfun(@(ii) glmwrap(x, yAll(:,ii), varargin{:}), 1:size(yAll,2));