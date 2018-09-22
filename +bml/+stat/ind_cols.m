function varargout = ind_cols(varargin)
% Returns reference-coded regressors as a logical matrix.
%
% tf = ind_cols(v, v_base)
% v can be a column vector or a matrix.
% v_base, if given, must match a row of v.
%
% EXAMPLE:
% 
% >> ind_cols([1 2 3 2 1])
% ans =
%      0     0
%      1     0
%      0     1
%      1     0
%      0     0
%
% >> ind_cols([1 2 3; 1 3 2; 1 2 3; 1 5 4], [1 6 5])
% v_incl:
%      1     2     3
%      1     3     2
%      1     5     4
% 
% v_base:
%      1     6     5
% 
% Error using ind_cols (line 31)
% v_base is not found among rows of v_incl!
% 
% >> ind_cols([1 2 3; 1 3 2; 1 2 3; 1 5 4], [1 3 2])
% 
% ans =
% 
%   4×2 logical array
% 
%    1   0
%    0   0
%    1   0
%    0   1
%
% See also: glmfit, fitglm

[varargout{1:nargout}] = ind_cols(varargin{:});