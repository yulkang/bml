function v = unique_general(v0)
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
%
% Yul Kang. hk2699 at columbia dot edu.

if isempty(v0)
    if iscell(v0)
        v = {};
    else
        v = [];
    end
    return;
end

n = numel(v0);
v = feval(class(v0), size(v0));

v(1) = v0(1);
n_unique = 1;
for ii = 2:n
    is_unique = true;
    for jj = 1:n_unique
        if isequal(v(jj), v0(ii))
            is_unique = false;
            break;
        end
    end
    
    if is_unique
        n_unique = n_unique + 1;
        v(n_unique) = v0(ii);
    end
end

v = v(1:n_unique);