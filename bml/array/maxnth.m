function [m, ix] = maxnth(v, n, dim)
% n-th largest element on dim.
%
% [m, ix] = maxnth(v, n, dim)
%
% EXAMPLE:
% >> v = magic(5)
% v =
%     17    24     1     8    15
%     23     5     7    14    16
%      4     6    13    20    22
%     10    12    19    21     3
%     11    18    25     2     9
% 
% >> [m, ix] = argmaxnth(v, 4, 2)
% m =
%      8
%      7
%      6
%     10
%      9
% 
% ix =
%      4
%      3
%      2
%      1
%      5
%
% See also: MAX, SORT

% 2018 (c) Yul Kang. yul dot kang dot on at gmail dot com.
     
if nargin < 3
    if isrow(v)
        dim = 2;
    else
        dim = 1;
    end
end

[v, ix0] = sort(v, dim);
n_dim = ndims(v);
sub = repmat({':'}, [1, n_dim]);
siz = size(v);
sub{dim} = siz(dim) - n + 1;
m = v(sub{:});

if nargout >= 2
    ix = ix0(sub{:});
end


        