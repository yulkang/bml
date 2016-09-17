function varargout = unique_general(varargin)
% v = unique_general(v0)
%
% EXAMPLE:
% >> bml.matrix.unique_general({2, 1, 4, 'a', 'b', 'a', 4})
% ans = 
%     [2]    [1]    [4]    'a'    'b'
% 
% >> bml.matrix.unique_general([2 1 4 3 4 1])
% ans =
%      2     1     4     3
[varargout{1:nargout}] = unique_general(varargin{:});