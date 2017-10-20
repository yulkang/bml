function tf = ind_cols(v, v_base)
% Returns reference-coded regressors as a logical matrix.
% In a special case where all rows are identical, returns an
% [nrows x 0] empty matrix.
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
% ans =
%   4×2 logical array
% 
%    1   0
%    0   0
%    1   0
%    0   1
%
% >> ind_cols([1 2 3; 1 2 3])
% ans =
%   2×0 empty logical array
%
% See also: glmfit, fitglm

[v_incl, ~, ic] = unique(v, 'rows');

if nargin < 2
    i_base = 1;
else
    assert(isrow(v_base));
    assert(length(v_base) == size(v_incl, 2));
    
    [~, i_base] = intersect(v_incl, v_base, 'rows');
    if isempty(i_base)
        disp('v_incl:');
        disp(v_incl);
        disp('v_base:');
        disp(v_base);
        error('v_base is not found among rows of v_incl!');
    end
end
i_incl = setdiff(1:max(ic), i_base);

tf = bsxfun(@eq, ic, i_incl);