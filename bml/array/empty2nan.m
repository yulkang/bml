function vec = empty2nan(cellVec)
% EMPTY2NAN Converts cell to vector, filling empty elements with NaN.
%
% vec = empty2nan(cellVec)
%
% See also CROSSEQ

isE         = isempty(cellVec);
vec         = nan(size(cellVec));
vec(~isE)   = cell2mat(cellVec(~isE));